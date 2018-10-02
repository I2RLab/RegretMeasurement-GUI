function varargout = QuestionPage(varargin)
%QUESTIONPAGE M-file for QuestionPage.fig
%      [PL_now] = QUESTIONPAGE(Zeta_0, Zeta_k, Zeta_kPlus1,P)
%      creates a GUI to display a survey question in the form,
%
%                      A (Option R)                  B (Option H)
%             =======================          ========================
%   Result:   Outcome:    Probability:         Outcome:     Probability:
%   Correct   Zeta_0           p               Zeta_k          1
%   Wrong     Zeta_kPlus1     1-p                0             0
%
%      to a participant. The inputs define these two options.
%      Facing this question, the participant is asked to
%      indicate her level of preference in Robot option and Human option.
%      There is a linear scale through extremely prefer
%      robot, prefer robot, somewhat prefer robot, indifferent, somewhat
%      prefer human, prefer human and extremely prefer human. The
%      participant input her level of preference by sliding the slider to
%      her desired tick on the scale. The minmium value is -100 at
%      "extremely prefer robot" and the maximum value is 100 at "extremely
%      prefer human". The participant's input is a integer in [-100, 100]
%      and is recorded.
%
%      The output of this function is the recorded level of preference.
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Last Modified by Longsheng Jiang@Clemson Univerisyt 11-May-2017

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuestionPage_OpeningFcn, ...
                   'gui_OutputFcn',  @QuestionPage_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before QuestionPage is made visible.
function QuestionPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for QuestionPage
handles.output = hObject;

%% Begin user's code
% Take the input arguments
R_crct_o_raw  = varargin{1};
H_crct_o_raw  = varargin{2};
R_wrng_o_raw  = varargin{3};
P_raw         = varargin{4};
Waiting       = varargin{5};
QuesNum       = varargin{6};

% ============================================
% Show the progress in total questions
set(handles.TxtProgTo, 'String', [num2str(QuesNum), '/120']);

% Show the progress of module completion
    ModuleNum = ceil( QuesNum/10 );
    set(handles.TxtProgMo, 'String', [num2str(ModuleNum), '/12']);

% Show the progress in the current module
    QuesNumCM = mod(QuesNum, 10);
    % When QuesNumCM is 0, it means it is the last question in this module.
    if QuesNumCM == 0
        QuesNumCM = 10;
    end
    set(handles.TxtProgCM, 'String', [num2str(QuesNumCM), '/10']);
% =============================================
% Round them
R_crc_o_round = round(R_crct_o_raw * 100)/100;
H_crc_o_round = round(H_crct_o_raw * 100)/100;
R_wrng_o_round = round(R_wrng_o_raw * 100)/100;
P_round       = round( P_raw * 1000 )/1000;

% Calculate the difference between robot and human outcomes
Delta_RH_1 = R_crc_o_round - H_crc_o_round;
Delta_RH_2 = R_wrng_o_round - H_crc_o_round;

% Save these values into the handles
handles.CostRCorrect = R_crc_o_round;
handles.CostRWrong = R_wrng_o_round;
handles.CostHCorrect = H_crc_o_round;
handles.ProbToCorrect = P_round;

% Convert them to strings
Robot_crct_outcome = ['$' num2str(R_crc_o_round)];     % Zeta_0
Human_crct_outcome = ['$' num2str(H_crc_o_round)];     % Zeta_k
Robot_wrng_outcome = ['$' num2str(R_wrng_o_round)];    % Zeta_kPlus1;   
Robot_crct_prob    = [num2str(100*P_round) '%' ]; % Probability
Robot_wrng_prob    = [num2str( 100*(1-P_round) ) '%'];
Delta_RH_outcome1 = ['$' num2str(Delta_RH_1)]; 
Delta_RH_outcome2 = ['$' num2str(Delta_RH_2)]; 

Human_crct_prob    = '100%';
% Preset the location of the popped window to be 3/4 of the screen
% Used normalized unit in which 1 means full dimension   
set(handles.figure1, 'units','normalized','outerposition',[0 0 1 1]);

% Expected values of the robot option
E_R_round = R_wrng_o_round * (1-P_round);
% Round it further
E_R = round(E_R_round * 100)/100;

% Store this value to the handles
handles.ExpectRobot = E_R; 

% Convert it to a string
Str_E_R = ['$', num2str(E_R)];

% Display the expected values
set(handles.TxtExpect_A, 'String', ['Expected Value: ',Str_E_R] );
set(handles.TxtExpect_B, 'String', ['Expected Value: ', Human_crct_outcome]);


% ===============================================
% Initialize the data for robot option
set(handles.Robot_crct_outcome,'string',Robot_crct_outcome);
set(handles.Robot_crct_probability,'string',Robot_crct_prob);
set(handles.Robot_wrng_outcome,'string',Robot_wrng_outcome);
set(handles.Robot_wrng_probability,'string',Robot_wrng_prob);


% Plot the visualization of robot cost
RobotCrctCostBar = bar(handles.A_CostChart, ...
                         1,R_crc_o_round,0.6,'FaceColor',[0.94,0.94,0.94]);
text(handles.A_CostChart,1,R_crc_o_round, Robot_crct_outcome,...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top');
           
% Save the axis of the bar in the handles.
handles.BarAxis.RobotCrct = RobotCrctCostBar;  

%set(handles.A_CostChart,'XTickLabel',{['Prob:' Robot_crct_prob]});
grid(handles. A_CostChart, 'on');
hold(handles. A_CostChart, 'on');
RobotWrngCostBar = bar(handles.A_CostChart, ...
                           2,R_wrng_o_round,0.6,'FaceColor',[0.5,0.5,0.5]);
text(handles. A_CostChart, 2,R_wrng_o_round, Robot_wrng_outcome,...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top');
           
% Save the axis of the bar in the handles.
handles.BarAxis.RobotWrng = RobotWrngCostBar;  

% Calculate the range of cost graphs. 
MinY= floor( 1.1 * R_wrng_o_round );
% Set the range of the cost graph 
axis(handles.A_CostChart,[0,3,MinY, 0]);

% Round the value for easy display
Robot_crct_prob_round = [num2str(round(P_round*1000)/10) '%' ];
Robot_wrng_prob_round = [num2str(round( (1-P_round)*1000)/10) '%' ];
set(handles.A_CostChart,'XTick',0:2,'XTickLabel',...
                    {'Prob:',Robot_crct_prob_round,...
                             Robot_wrng_prob_round});
                         
hold(handles. A_CostChart, 'off');


% Plot the visualization of robot probability
    % Define the x and y values for plotting horizontal bars
    A_barhX = [0, 1, 2];
    A_barhY = [0, 0; ...
               P_round, 1-P_round;
               0, 0];
    % Plot the stacked horizontal bars (The name is inherited from previous
    % pie plot, so the name looks weird here).
    barh(handles.A_ProbChart, A_barhX, A_barhY, 'stacked');  
    % Choose the right color for each bar
    colormap(handles.A_ProbChart, [0.94, 0.94, 0.94; 0.5, 0.5, 0.5]);
    % Make sure the bars occupy the full axes.
    ylim(handles.A_ProbChart, [0.6, 1.4]);
    % Name the plot
    title(handles.A_ProbChart, 'Probability distribution');
    % Set the ticks for x-axis from 0 to 1 with sets of 0.1
    set(handles.A_ProbChart,'XTick',0:0.1:1);
    % Set the ticks for y-axis as empty
    set(handles.A_ProbChart, 'YTick', []);
    % Plot the home-made grids in front of the bars.
        % hold the plot
        hold(handles.A_ProbChart, 'on');
        % Define each line of the grid
        GX = ones(1,2);
        GY = [0.6, 1.4];
        % Create the grid
        plot(handles.A_ProbChart, 0.05*GX, GY,'k:', ...
                                  0.1*GX, GY,'k:', 0.15*GX, GY,'k:', ...
                                  0.2*GX, GY,'k:', 0.25*GX, GY,'k:', ...
                                  0.3*GX, GY,'k:', 0.35*GX, GY,'k:', ...
                                  0.4*GX, GY,'k:', 0.45*GX, GY,'k:', ...
                                  0.5*GX, GY,'k:', 0.55*GX, GY,'k:', ...
                                  0.6*GX, GY,'k:', 0.65*GX, GY,'k:', ...
                                  0.7*GX, GY,'k:', 0.75*GX, GY,'k:', ...
                                  0.8*GX, GY,'k:', 0.85*GX, GY,'k:', ...
                                  0.9*GX, GY,'k:', 0.95*GX, GY,'k:');
        % hold off
        hold(handles.A_ProbChart, 'off');


% % Plot the visualization of robot probability (Previous vesion using Pie chart)
% A_PieLabel = { Robot_crct_prob,...
%                Robot_wrng_prob  };
% explode = [0, 1];
% A_Pie = pie(handles.A_ProbChart,[P_round, 1-P_round], explode,A_PieLabel);
% colormap(handles.A_ProbChart, [0.94, 0.94, 0.94; 0.5, 0.5, 0.5]);
% set(A_Pie(2),'BackgroundColor', 'white');
% set(A_Pie(4),'BackgroundColor', 'white');

% ===============================================
% Initialize the data for human option
set(handles.Human_crct_outcome,'string',Human_crct_outcome);
set(handles.Human_crct_probability,'string',['100' '%']);


% Plot the visualization of  human cost
HumanCostBar = bar(handles.B_CostChart, ...
                         1,H_crc_o_round,0.4,'FaceColor',[0.83,0.82,0.78]);
text(handles. B_CostChart, 1,H_crc_o_round, Human_crct_outcome,...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top');
           
% Save the axis of the bar in the handles.
handles.BarAxis.Human = HumanCostBar;

% Edit this plot
grid(handles. B_CostChart, 'on');
axis(handles.B_CostChart,[0,2,MinY, 0]);
set(handles.B_CostChart,'XTick',0:1,'XTickLabel',{'Prob:', '100%'});

% Plot the visualization of robot probability

    % Plot the stacked horizontal bars (The name is inherited from previous
    % pie plot, so the name looks weird here).
    barh(handles.B_ProbChart, 1);  
    % Choose the right color for each bar
    colormap(handles.B_ProbChart, [0.83, 0.82, 0.78]);
    % Make sure the bars occupy the full axes.
    ylim(handles.B_ProbChart, [0.6, 1.4]);
    % Name the plot
    title(handles.B_ProbChart, 'Probability distribution');
    % Set the ticks for x-axis from 0 to 1 with sets of 0.1
    set(handles.B_ProbChart,'XTick',0:0.1:1);
    % Set the ticks for y-axis as empty
    set(handles.B_ProbChart, 'YTick', []);
    % Plot the home-made grids in front of the bars.
        % hold the plot
        hold(handles.B_ProbChart, 'on');
        % Create the grid
        plot(handles.B_ProbChart, 0.05*GX, GY,'k:', ...
                                  0.1*GX, GY,'k:', 0.15*GX, GY,'k:', ...
                                  0.2*GX, GY,'k:', 0.25*GX, GY,'k:', ...
                                  0.3*GX, GY,'k:', 0.35*GX, GY,'k:', ...
                                  0.4*GX, GY,'k:', 0.45*GX, GY,'k:', ...
                                  0.5*GX, GY,'k:', 0.55*GX, GY,'k:', ...
                                  0.6*GX, GY,'k:', 0.65*GX, GY,'k:', ...
                                  0.7*GX, GY,'k:', 0.75*GX, GY,'k:', ...
                                  0.8*GX, GY,'k:', 0.85*GX, GY,'k:', ...
                                  0.9*GX, GY,'k:', 0.95*GX, GY,'k:');
        % hold off
        hold(handles.B_ProbChart, 'off');

% ===============================================================
% Initialize the Option Comparison panel
    
    % Outcome comparison graphs
        % Plot the visualization of robot succeeding cost
        bar(handles.OutcomeCmpChart, ...
                             1,R_crc_o_round,0.6,'FaceColor',[0.94,0.94,0.94]);
        hold(handles.OutcomeCmpChart, 'on');
        text(handles.OutcomeCmpChart,1,R_crc_o_round, Robot_crct_outcome,...
                       'HorizontalAlignment','center',...
                       'VerticalAlignment','top');

        % Plot the visualization of robot failing cost
        bar(handles.OutcomeCmpChart, ...
                               2,R_wrng_o_round,0.6,'FaceColor',[0.5,0.5,0.5]);
        text(handles.OutcomeCmpChart, 2,R_wrng_o_round, Robot_wrng_outcome,...
                       'HorizontalAlignment','center',...
                       'VerticalAlignment','top');        
                   
        % Plot the visualization of  human cost
        bar(handles.OutcomeCmpChart, ...
                             3,H_crc_o_round,0.6,'FaceColor',[0.83,0.82,0.78]);
        text(handles.OutcomeCmpChart, 3,H_crc_o_round, Human_crct_outcome,...
                       'HorizontalAlignment','center',...
                       'VerticalAlignment','top');           


        % Edit this plot
        axis(handles.OutcomeCmpChart,[0,4,MinY, 0]);
        set(handles.OutcomeCmpChart,'XTick',1:3,'XTickLabel',{'Robot 1',...
                                                              'Robot 2',...
                                                              'Human'});
        set(handles.OutcomeCmpChart,'YTick', linspace(MinY,0 ,20), 'Yticklabel', []);   
        grid(handles.OutcomeCmpChart, 'on');
        hold(handles.OutcomeCmpChart, 'off');       

    % Outline comparison calculation
    set(handles.TxtOutcomeCmp1_1, 'String', Robot_crct_outcome);
    set(handles.TxtOutcomeCmp1_2, 'String', Human_crct_outcome);
    set(handles.TxtOutcomeCmp1_3, 'String', Delta_RH_outcome1);
    set(handles.TxtOutcomeCmp2_1, 'String', Robot_wrng_outcome);
    set(handles.TxtOutcomeCmp2_2, 'String', Human_crct_outcome);
    set(handles.TxtOutcomeCmp2_3, 'String', Delta_RH_outcome2);
    
    % Probability comparison
        % Plot the visualization of robot probability
        % Define the x and y values for plotting horizontal bars
        Cmp_barhX = [0, 1];
        Cmp_barhY_R = [0, 0;...
                       P_round, 1-P_round];
        Cmp_barhY_H = [1, 0;
                       0, 0];
        % Plot the stacked horizontal bars (The name is inherited from previous
        % pie plot, so the name looks weird here).
        barh(handles.ProbCmpChart, Cmp_barhX, Cmp_barhY_R, 'stacked');  
        % Choose the right color for each bar
        colormap(handles.ProbCmpChart, [0.94, 0.94, 0.94; 0.5, 0.5, 0.5]);
        % hold the plot
        hold(handles.ProbCmpChart, 'on');
        % Label the probabilities of the robot
        text(handles.ProbCmpChart, P_round/2, 1, Robot_crct_prob,...
                                        'HorizontalAlignment','center',...
                                        'VerticalAlignment','middle');
        text(handles.ProbCmpChart, P_round/2 + 1/2, 1, Robot_wrng_prob,...
                                        'HorizontalAlignment','center',...
                                        'VerticalAlignment','middle');
        % Plot the stacked horizontal bars (The name is inherited from previous
        % pie plot, so the name looks weird here).
        ProbBar_H = barh(handles.ProbCmpChart, Cmp_barhX, Cmp_barhY_H, 'stacked');  
        % Choose the right color for each bar
        set(ProbBar_H, 'FaceColor', [0.83, 0.82, 0.78]);
        
        % Edit the plot
            % Make sure the bars occupy the full axes.
            ylim(handles.ProbCmpChart, [-1, 2]);
            % Set the ticks for x-axis from 0 to 1 with sets of 0.1
            set(handles.ProbCmpChart,'XTick',0:0.1:1);
            % Set the ticks for y-axis as empty
            set(handles.ProbCmpChart, 'YTick', [0, 1],...
                                      'YTickLabel', {'Human ', 'Robot   '});
            grid(handles.ProbCmpChart, 'on');
        % hold off
        hold(handles.ProbCmpChart, 'off');

    
% ===============================================================
% Make sure all radio buttons are off    
handles.Statement1a_100.Value = 0;
handles.Statement1b_100.Value = 0;
handles.Statement1c_100.Value = 0;
handles.Statement2a_100.Value = 0;
handles.ButtonChooseR.Value = 0;
% ===============================================================
% Initialize the question panels to show question 1 and hide question2
set(handles.PanelQuestion1, 'Visible','off');
set(handles.PanelQuestion2, 'Visible','off');
    
% ===============================================================
% Display the preference spectrum to give users a spatial view of
% preference
PrefSpectrum = imread('PreferenceSpectrum.png');
imshow(PrefSpectrum, 'Parent', handles.AxesPrefSpectrum);

% ===============================================================    
% Initialize a field to store the particpant's choice into handles
handles.YourChoice = 'NA';

% Initialize the close button to be off
handles.CloseButton = 'off';

% Set a timer to enable answer the question after delay
t = timer;
t.StartDelay = Waiting;                    
t.ExecutionMode = 'singleShot';
t.TimerFcn = {@MyTimer_CallbackFcn, handles};
start(t);

% Store the handle of timer to handles
handles.timer = t;



%% End user's code

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QuestionPage wait for user response (see UIRESUME)
uiwait(handles.figure1);
 
function MyTimer_CallbackFcn(hObject, eventdata, handles)

% Turn on question panel.
set(handles.PanelQuestion1,'Visible','on');

% % Produce a sound hint 
% Beep = sin(0:1026);
% sound(Beep);

% --- Outputs from this function are returned to the command line.
function varargout = QuestionPage_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

%% Begin user's code

% =============================================
% Load the feedback of the participant
% =============================================

% Get the radio button values from statement 1a
r1a_000 = handles.Statement1a_000.Value;
r1a_025 = handles.Statement1a_025.Value;
r1a_050 = handles.Statement1a_050.Value;
r1a_075 = handles.Statement1a_075.Value;
r1a_100 = handles.Statement1a_100.Value;

% The truth value of statement 1a
truthPrefR = 0 * r1a_000 + 0.25 * r1a_025 + 0.5 * r1a_050...
          + 0.75 * r1a_075 + 1 * r1a_100;

% Get the radio button values from statement 1b
r1b_000 = handles.Statement1b_000.Value;
r1b_025 = handles.Statement1b_025.Value;
r1b_050 = handles.Statement1b_050.Value;
r1b_075 = handles.Statement1b_075.Value;
r1b_100 = handles.Statement1b_100.Value;

% The truth value of statement 1b
truthPrefH = 0 * r1b_000 + 0.25 * r1b_025 + 0.5 * r1b_050...
          + 0.75 * r1b_075 + 1 * r1b_100;

% Get the radio button values from statement 1c
r1c_000 = handles.Statement1c_000.Value;
r1c_025 = handles.Statement1c_025.Value;
r1c_050 = handles.Statement1c_050.Value;
r1c_075 = handles.Statement1c_075.Value;
r1c_100 = handles.Statement1c_100.Value;

% The truth value of statement 1c
truthIndif = 0 * r1c_000 + 0.25 * r1c_025 + 0.5 * r1c_050...
          + 0.75 * r1c_075 + 1 * r1c_100;
            
% Get the radio button values from statement 1a
r2a_000 = handles.Statement2a_000.Value;
r2a_025 = handles.Statement2a_025.Value;
r2a_050 = handles.Statement2a_050.Value;
r2a_075 = handles.Statement2a_075.Value;
r2a_100 = handles.Statement2a_100.Value;

% The truth value of statement 2a
truthSlow = 0 * r2a_000 + 0.25 * r2a_025 + 0.5 * r2a_050...
          + 0.75 * r2a_075 + 1 * r2a_100;

% Implication of the truth value of between slow.
truthFast = 1 - truthSlow;
      
% Get the radio button values from the final choice
radio_R = handles.ButtonChooseR.Value;
radio_E = handles.ButtonEitherOk.Value;
radio_H = handles.ButtonChooseH.Value;


% =============================================================
% Show the resolved results in the interface and the final cost
% =============================================================

% Play the sound effect 
% load external files
load('ChaChing.mat');
sound(ChaChing, ChaChingFs);

% Load the saved option characteristic data
R_crc_cost = handles.CostRCorrect;
R_wrng_cost = handles.CostRWrong;
H_crc_cost = handles.CostHCorrect;

% -----------------------------------------------------------
% Resolve the probablistic uncertainty and update the graphs.

% Create a random value.
RandomForProb = rand;

% Plot the random marker to indicate the resolved probability
hold(handles.A_ProbChart,'on');
GX   = ones(1,2);
GY   = [0.6, 1.4];
plot(handles.A_ProbChart, RandomForProb*GX,GY,'-b','Linewidth',2);
hold(handles.A_ProbChart,'off');

% Plot the random marker to indicate the resolved probability
hold(handles.B_ProbChart,'on');
plot(handles.B_ProbChart, RandomForProb*GX,GY,'-b','Linewidth',2);
hold(handles.B_ProbChart,'off');

% Update the visualization of  human cost
    handles.BarAxis.Human.EdgeColor = 'blue';
    handles.BarAxis.Human.LineWidth = 3;

    % If the opposite option (Robot) was chosen, then the edgeline is dashed.
    if radio_R ==1
        handles.BarAxis.Human.LineStyle = '--';
        
    % Otherwise, the edgeline is solid (default) 
    end


% Determine whether Option R is correct
    % If the result is correct
    if RandomForProb <= handles.ProbToCorrect
        % Update the plot of option R
         handles.BarAxis.RobotCrct.EdgeColor = 'blue';
         handles.BarAxis.RobotCrct.LineWidth = 3;
        
        % If the opposite option (Human) was chosen, then the edgeline is dashed.
        if radio_H ==1
            handles.BarAxis.RobotCrct.LineStyle = '--';

        % Otherwise, the edgeline is solid (default) 
        end

        % The resulting of option R is the cost to be correct
        RobotCost = 'Correct';
        
%         % What is the monetary result?
%         if strcmpi(Choice, 'R')
%             MoneyCost = R_crc_cost;
%         end


    % otherwise, the resolved result is wrong 
    else
        % Update the plot of option R
         handles.BarAxis.RobotWrng.EdgeColor = 'blue';
         handles.BarAxis.RobotWrng.LineWidth = 3;
         
        % If the opposite option (Human) was chosen, then the edgeline is dashed.
        if radio_H ==1
            handles.BarAxis.RobotWrng.LineStyle = '--';

        % Otherwise, the edgeline is solid (default) 
        end
         
        % The resulting of option R is the cost to be correct
         RobotCost = 'Wrong';
         
%         % What is the monetary result?
%         if strcmpi(Choice, 'R')
%             MoneyCost = R_wrng_cost;
%         end
    end

% ---------------------------------
% Determine the final choice

% Check the radiobuttons regarding the participant's crisp choice
    % If the middle radiobutton is on
    if radio_E == 1
        Choice = 'I';
%         % Highlight both the Choices
%         set(handles.panel_A,'ForegroundColor','blue');
%         set(handles.panel_B,'ForegroundColor','blue');
%         set(handles.panel_A,'HighlightColor','blue');
%         set(handles.panel_B,'HighlightColor','blue');
        
        %  Randomly choose either option R or option H.
        RandomForIndif = rand;
        
        % If the random choice is option R
        if RandomForIndif <= 0.5
            
            % Highlight the Option R
            set(handles.panel_A,'ForegroundColor','blue'); 
            set(handles.panel_A,'HighlightColor','blue');
            set(handles.panel_A,'Title','Computer chooses Robot');
            
            % The highlighting edge of human cost turns to be dashed
            handles.BarAxis.Human.LineStyle = '--';
            
            % If the resolved cost for option R is the cost to be correct,
            if strcmpi(RobotCost,'Correct')
                
                % Calculate the real cost
                MoneyCost = R_crc_cost;
                
            % otherwise, the resolved cost for option R is the cost to be
            % wrong.
            else
                % Calculate the real cost.
                MoneyCost = R_wrng_cost;
            end
            
        % otherwise, the random choice is option H.
        else
            % Highlight the Option H
            set(handles.panel_B,'ForegroundColor','blue'); 
            set(handles.panel_B,'HighlightColor','blue');
            set(handles.panel_B,'Title','Computer chooses Human');
            % Calculate the real cost.
            MoneyCost = H_crc_cost;
            
             % If the resolved cost for option R is the cost to be correct,
            if strcmpi(RobotCost,'Correct')
                % the highlighting edge becomes dashed.
                handles.BarAxis.RobotCrct.LineStyle = '--';
                
            % otherwise, the resolved cost for option R is the cost to be
            % wrong, 
            else
                % the highlight edge becomes dashed
                 handles.BarAxis.RobotWrng.LineStyle = '--';
            end
            
        end
        
    % If the first radiobutton is on,
    elseif radio_R == 1
        Choice = 'R';
        
        % Highlight the Option R
        set(handles.panel_A,'ForegroundColor','blue'); 
        set(handles.panel_A,'HighlightColor','blue');
        set(handles.panel_A,'Title','You choose Robot');
        
         % If the resolved cost for option R is the cost to be correct,
        if strcmpi(RobotCost,'Correct')
            MoneyCost = R_crc_cost;

        % otherwise, the resolved cost for option R is the cost to be
        % wrong.
        else
            MoneyCost = R_wrng_cost;
        end
        
    % Otherwise, the last radiobutton is on,
    else
        Choice = 'H';
        
        % Highlight the Option H
        set(handles.panel_B,'ForegroundColor','blue'); 
        set(handles.panel_B,'HighlightColor','blue');
        set(handles.panel_B,'Title','You choose Human');
        
        % The numerical cost of choosing option H
        MoneyCost = H_crc_cost;
    end

% Set all panels off, except the ones showing the result. Help the user 
% focus on the result by clearing other information.
set(handles.PanelCmpInfo, 'Visible', 'off');
set(handles.PanelProgress, 'Visible', 'off');
set(handles.PanelQuestion2, 'Visible', 'off');
set(handles.PanelPrefDim, 'Visible', 'off');
set(handles.TxtMainTitle, 'Visible', 'off');

% Update handles structure
guidata(hObject, handles);


% pause 3s to let the user see the result
pause(3);
 
% Arrange the output variables
varargout{1} = [ truthPrefR, truthPrefH, truthIndif, truthSlow, truthFast]';
varargout{2} = Choice;
varargout{3} = MoneyCost;
varargout{5} = handles.CloseButton;

% Delete the timer
delete(handles.timer);

% Delete the window
delete(hObject);
% End user's code

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Begin User's code
% Put on instructions on how to end this window
% set(handles.NoStop, 'String', 'Please request help from the experimentor.');
% Update the handles
handles.CloseButton = 'on';
guidata(hObject, handles);

% Resume the run of the figure
uiresume(handles.figure1);  
%% End user's code


% --- Executes on button press in ButtonQuestionNext1.
function ButtonQuestionNext1_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonQuestionNext1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hide question 1 and show question 2
set(handles.PanelQuestion1, 'Visible','off');
set(handles.PanelQuestion2, 'Visible','on');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ButtonQuestion2Done.
function ButtonQuestion2Done_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonQuestion2Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the radio button values from statement 1a
r1a_000 = handles.Statement1a_000.Value;
r1a_025 = handles.Statement1a_025.Value;
r1a_050 = handles.Statement1a_050.Value;
r1a_075 = handles.Statement1a_075.Value;
r1a_100 = handles.Statement1a_100.Value;

% Get the radio button values from statement 1b
r1b_000 = handles.Statement1b_000.Value;
r1b_025 = handles.Statement1b_025.Value;
r1b_050 = handles.Statement1b_050.Value;
r1b_075 = handles.Statement1b_075.Value;
r1b_100 = handles.Statement1b_100.Value;

% Get the radio button values from statement 1c
r1c_000 = handles.Statement1c_000.Value;
r1c_025 = handles.Statement1c_025.Value;
r1c_050 = handles.Statement1c_050.Value;
r1c_075 = handles.Statement1c_075.Value;
r1c_100 = handles.Statement1c_100.Value;

% Get the radio button values from statement 1a
r2a_000 = handles.Statement2a_000.Value;
r2a_025 = handles.Statement2a_025.Value;
r2a_050 = handles.Statement2a_050.Value;
r2a_075 = handles.Statement2a_075.Value;
r2a_100 = handles.Statement2a_100.Value;

% Get the radio button values from the final choice
radio_R = handles.ButtonChooseR.Value;
radio_E= handles.ButtonEitherOk.Value;
radio_H = handles.ButtonChooseH.Value;

% Calculate the sum of all radio button values
radio_sum = r1a_000 + r1a_025 + r1a_050 + r1a_075 + r1a_100...
            + r1b_000 + r1b_025 + r1b_050 + r1b_075 + r1b_100...
            + r1c_000 + r1c_025 + r1c_050 + r1c_075 + r1c_100...
            + r2a_000 + r2a_025 + r2a_050 + r2a_075 + r2a_100...
            + radio_R + radio_E + radio_H;
        
if radio_sum < 5 
    handles.TxtExitWarning.Visible = 'on';
    % put on alert sound
    load('attention.mat');
    sound(attention, attentionFs);
else
    handles.TxtExitWarning.Visible = 'off';
    
    % break the loop to output function
    uiresume(handles.figure1);  
end
% --- Executes on button press in ButtonQuestion2Previous.
function ButtonQuestion2Previous_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonQuestion2Previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hide question 1 and show question 2
set(handles.PanelQuestion2, 'Visible','off');
set(handles.PanelQuestion1, 'Visible','on');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
%function Statement1a_100_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Statement1a_100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Statement1a_000.
function Statement1a_000_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1a_000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1a_000

% Check if radiobuttons in statement1b, except statement1c_000, are disabled
% if so, enable them.
if  handles.Statement1b_000.Value == 1 ...
        && strcmpi(handles.Statement1b_025.Visible, 'off')
    
    % Reset Statement1b_000 to zero
    set(handles.Statement1b_000,'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1b_025, 'Visible','on');
    set(handles.Statement1b_050, 'Visible','on');
    set(handles.Statement1b_075, 'Visible','on');
    set(handles.Statement1b_100, 'Visible','on');
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for preferring H is 0, then the degree of
% agreement for indifference must be 1. This is a constraint.
if handles.Statement1b_000.Value == 1
    
    % Set the value of statement1c_000 to be 1
    handles.Statement1c_100.Value = 1;
    
    % Disable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','off');
    set(handles.Statement1c_025, 'Visible','off');
    set(handles.Statement1c_050, 'Visible','off');
    set(handles.Statement1c_075, 'Visible','off');
   
end

% Update handles structure
guidata(hObject, handles);   

% --- Executes on button press in Statement1a_025.
function Statement1a_025_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1a_025 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1a_025

% % Check if radiobuttons in statement1b, except statement1c_000, are disabled
% % if so, enable them.
% if  handles.Statement1b_000.Value == 1 ...
%         && strcmpi(handles.Statement1b_025.Visible, 'off')
%     
%     % Reset Statement1b_000 to zero
%     set(handles.Statement1b_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1b_025, 'Visible','on');
%     set(handles.Statement1b_050, 'Visible','on');
%     set(handles.Statement1b_075, 'Visible','on');
%     set(handles.Statement1b_100, 'Visible','on');
%        
% end


% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, enable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for R is better than H is more than 0, it is
% IMPOSSIBLE at the same time H is better than R. This is one constraint.

% Set the value of statement1b to be 0
set(handles.Statement1b_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1b_025, 'Visible','off');
set(handles.Statement1b_050, 'Visible','off');
set(handles.Statement1b_075, 'Visible','off');
set(handles.Statement1b_100, 'Visible','off');
    
% Update handles structure
guidata(hObject, handles);     

% --- Executes on button press in Statement1a_050.
function Statement1a_050_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1a_050 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1a_050

% % Check if radiobuttons in statement1b, except statement1c_000, are disabled
% % if so, enable them.
% if  handles.Statement1b_000.Value == 1 ...
%         && strcmpi(handles.Statement1b_025.Visible, 'off')
%     
%     % Reset Statement1b_000 to zero
%     set(handles.Statement1b_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1b_025, 'Visible','on');
%     set(handles.Statement1b_050, 'Visible','on');
%     set(handles.Statement1b_075, 'Visible','on');
%     set(handles.Statement1b_100, 'Visible','on');
%        
% end


% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for R is better than H is more than 0, it is
% IMPOSSIBLE at the same time H is better than R. This is one constraint.

% Set the value of statement1b to be 0
set(handles.Statement1b_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1b_025, 'Visible','off');
set(handles.Statement1b_050, 'Visible','off');
set(handles.Statement1b_075, 'Visible','off');
set(handles.Statement1b_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1a_075.
function Statement1a_075_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1a_075 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1a_075

% % Check if radiobuttons in statement1b, except statement1c_000, are disabled
% % if so, enable them.
% if  handles.Statement1b_000.Value == 1 ...
%         && strcmpi(handles.Statement1b_025.Visible, 'off')
%     
%     % Reset Statement1b_000 to zero
%     set(handles.Statement1b_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1b_025, 'Visible','on');
%     set(handles.Statement1b_050, 'Visible','on');
%     set(handles.Statement1b_075, 'Visible','on');
%     set(handles.Statement1b_100, 'Visible','on');
%        
% end


% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
       
end


% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for R is better than H is more than 0, it is
% IMPOSSIBLE at the same time H is better than R. This is one constraint.

% Set the value of statement1b to be 0
set(handles.Statement1b_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1b_025, 'Visible','off');
set(handles.Statement1b_050, 'Visible','off');
set(handles.Statement1b_075, 'Visible','off');
set(handles.Statement1b_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1a_100.
function Statement1a_100_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1a_100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1a_100

% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.

if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on'); 
       
end

% If the degree of agreement for R is better than H is more than 0, it is
% IMPOSSIBLE at the same time H is better than R. This is one constraint.
% 
% Set the value of statement1b to be 0
set(handles.Statement1b_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1b_025, 'Visible','off');
set(handles.Statement1b_050, 'Visible','off');
set(handles.Statement1b_075, 'Visible','off');
set(handles.Statement1b_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% If the degree of agreement for R is better than H is 1, it is 
% IMPOSSIBLE at the same time H is indifferent to R. This is another constraint.

% Set the value of statement1b to be 0
set(handles.Statement1c_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1c_025, 'Visible','off');
set(handles.Statement1c_050, 'Visible','off');
set(handles.Statement1c_075, 'Visible','off');
set(handles.Statement1c_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  


% --- Executes on button press in Statement1b_000.
function Statement1b_000_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1b_000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1b_000

% Check if radiobuttons in statement1a, except statement1a_000, are disabled
% if so, enable them.
if  handles.Statement1a_000.Value == 1 ...
        && strcmpi(handles.Statement1a_025.Visible, 'off')
    
    % Reset Statement1a_000 to zero
    set(handles.Statement1a_000,'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1a_025, 'Visible','on');
    set(handles.Statement1a_050, 'Visible','on');
    set(handles.Statement1a_075, 'Visible','on');
    set(handles.Statement1a_100, 'Visible','on');
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for preferring H is 0, then the degree of
% agreement for indifference must be 1.
if handles.Statement1a_000.Value == 1
    
    % Set the value of statement1c_000 to be 1
    handles.Statement1c_100.Value = 1;
    
    % Disable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','off');
    set(handles.Statement1c_025, 'Visible','off');
    set(handles.Statement1c_050, 'Visible','off');
    set(handles.Statement1c_075, 'Visible','off'); 
   
end

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1b_025.
function Statement1b_025_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1b_025 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1b_025

% % Check if radiobuttons in statement1a, except statement1a_000, are disabled
% % if so, enable them.
% if  handles.Statement1a_000.Value == 1 ...
%         && strcmpi(handles.Statement1a_025.Visible, 'off')
%     
%     % Reset Statement1a_000 to zero
%     set(handles.Statement1a_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1a_025, 'Visible','on');
%     set(handles.Statement1a_050, 'Visible','on');
%     set(handles.Statement1a_075, 'Visible','on');
%     set(handles.Statement1a_100, 'Visible','on');
%        
% end

% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% If the degree of agreement for H is better than R is more than 0, it is
% IMPOSSIBLE at the same time R is better than H. This is one constraint.

% Set the value of statement1b to be 0
set(handles.Statement1a_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1a_025, 'Visible','off');
set(handles.Statement1a_050, 'Visible','off');
set(handles.Statement1a_075, 'Visible','off');
set(handles.Statement1a_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1b_050.
function Statement1b_050_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1b_050 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1b_050

% % Check if radiobuttons in statement1a, except statement1a_000, are disabled
% % if so, enable them.
% if  handles.Statement1a_000.Value == 1 ...
%         && strcmpi(handles.Statement1a_025.Visible, 'off')
%     
%     % Reset Statement1a_000 to zero
%     set(handles.Statement1a_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1a_025, 'Visible','on');
%     set(handles.Statement1a_050, 'Visible','on');
%     set(handles.Statement1a_075, 'Visible','on');
%     set(handles.Statement1a_100, 'Visible','on');
%        
% end

% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');
       
end


% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% Set the value of statement1b to be 0
set(handles.Statement1a_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1a_025, 'Visible','off');
set(handles.Statement1a_050, 'Visible','off');
set(handles.Statement1a_075, 'Visible','off');
set(handles.Statement1a_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1b_075.
function Statement1b_075_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1b_075 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1b_075

% % Check if radiobuttons in statement1a, except statement1a_000, are disabled
% % if so, enable them.
% if  handles.Statement1a_000.Value == 1 ...
%         && strcmpi(handles.Statement1a_025.Visible, 'off')
%     
%     % Reset Statement1a_000 to zero
%     set(handles.Statement1a_000,'Value',0);
%     
%     % Enable the rest radiobuttons
%     set(handles.Statement1a_025, 'Visible','on');
%     set(handles.Statement1a_050, 'Visible','on');
%     set(handles.Statement1a_075, 'Visible','on');
%     set(handles.Statement1a_100, 'Visible','on');
%        
% end

% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on'); 
       
end

% Check if radiobuttons in statement1c, except statement1c_000, are disabled
% if so, emable them.
if  handles.Statement1c_000.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_000, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');  
    set(handles.Statement1c_100, 'Visible','on');
       
end

% Set the value of statement1b to be 0
set(handles.Statement1a_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1a_025, 'Visible','off');
set(handles.Statement1a_050, 'Visible','off');
set(handles.Statement1a_075, 'Visible','off');
set(handles.Statement1a_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  

% --- Executes on button press in Statement1b_100.
function Statement1b_100_Callback(hObject, eventdata, handles)
% hObject    handle to Statement1b_100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Statement1b_100


% Check if radiobuttons in statement1c, except statement1c_100, are disabled
% if so, emable them.
if  handles.Statement1c_100.Value == 1 ...
        && strcmpi(handles.Statement1c_025.Visible, 'off')
    
    % Reset Statement1c_100 to zero
    set(handles.Statement1c_100, 'Value',0);
    
    % Enable the rest radiobuttons
    set(handles.Statement1c_000, 'Visible','on');
    set(handles.Statement1c_025, 'Visible','on');
    set(handles.Statement1c_050, 'Visible','on');
    set(handles.Statement1c_075, 'Visible','on');
end

% Set the value of statement1a to be 0
set(handles.Statement1a_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1a_025, 'Visible','off');
set(handles.Statement1a_050, 'Visible','off');
set(handles.Statement1a_075, 'Visible','off');
set(handles.Statement1a_100, 'Visible','off');

% If the degree of agreement for R is better than H is 1, it is 
% IMPOSSIBLE at the same time H is indifferent to R. This is another constraint.

% Set the value of statement1c to be 0
set(handles.Statement1c_000, 'Value', 1);

% Disable the rest radiobuttons
set(handles.Statement1c_025, 'Visible','off');
set(handles.Statement1c_050, 'Visible','off');
set(handles.Statement1c_075, 'Visible','off');
set(handles.Statement1c_100, 'Visible','off');

% Update handles structure
guidata(hObject, handles);  
