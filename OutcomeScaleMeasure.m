function varargout = OutcomeScaleMeasure(varargin)
% OUTCOMESCALEMEASURE MATLAB code for OutcomeScaleMeasure.fig
%      OUTCOMESCALEMEASURE, by itself, creates a new OUTCOMESCALEMEASURE or raises the existing
%      singleton*.
%
%      H = OUTCOMESCALEMEASURE returns the handle to a new OUTCOMESCALEMEASURE or the handle to
%      the existing singleton*.
%
%      OUTCOMESCALEMEASURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTCOMESCALEMEASURE.M with the given input arguments.
%
%      OUTCOMESCALEMEASURE('Property','Value',...) creates a new OUTCOMESCALEMEASURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutcomeScaleMeasure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutcomeScaleMeasure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutcomeScaleMeasure

% Last Modified by GUIDE v2.5 20-Nov-2017 18:17:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutcomeScaleMeasure_OpeningFcn, ...
                   'gui_OutputFcn',  @OutcomeScaleMeasure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before OutcomeScaleMeasure is made visible.
function OutcomeScaleMeasure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutcomeScaleMeasure (see VARARGIN)

% =========================================================
% Initialize the radio buttons of the first question as off
set(handles.RadioQ1_1, 'Value', 0);
set(handles.RadioQ1_2, 'Value', 0);
set(handles.RadioQ1_3, 'Value', 0);
set(handles.RadioQ1_4, 'Value', 0);

% =========================================================
% Initialize the radio buttons of the first question as off
set(handles.RadioQ2_1, 'Value', 0);
set(handles.RadioQ2_2, 'Value', 0);
set(handles.RadioQ2_3, 'Value', 0);
set(handles.RadioQ2_4, 'Value', 0);

% =========================================================
% Initially Question Set 2 is invisible
set(handles.PanelQS2, 'Visible', 'off')

% =========================================================
% Initialize as off the radio buttons of the first question in Question
% Set 2
set(handles.RadioQS21_1, 'Value', 0);
set(handles.RadioQS21_2, 'Value', 0);
set(handles.RadioQS21_3, 'Value', 0);
set(handles.RadioQS21_4, 'Value', 0);
set(handles.RadioQS21_5, 'Value', 0);
set(handles.PanelQS21, 'Visible', 'off');
set(handles.PushButtonQS21, 'Visible', 'off');

% =========================================================
% Initialize as off the radio buttons of the second question in Question
% Set 2
set(handles.RadioQS22_1, 'Value', 0);
set(handles.RadioQS22_2, 'Value', 0);
set(handles.RadioQS22_3, 'Value', 0);
set(handles.RadioQS22_4, 'Value', 0);
set(handles.RadioQS22_5, 'Value', 0);
set(handles.PanelQS22, 'Visible', 'off');
set(handles.PushButtonQS22, 'Visible', 'off');

% =========================================================
% Initialize as off the radio buttons of the third question in Question
% Set 2
set(handles.RadioQS23_1, 'Value', 0);
set(handles.RadioQS23_2, 'Value', 0);
set(handles.RadioQS23_3, 'Value', 0);
set(handles.RadioQS23_4, 'Value', 0);
set(handles.RadioQS23_5, 'Value', 0);
set(handles.PanelQS23, 'Visible', 'off');
set(handles.PushButtonQS23, 'Visible', 'off');

% =========================================================
% Initialize as off the radio buttons of the fourth question in Question
% Set 2
set(handles.RadioQS24_1, 'Value', 0);
set(handles.RadioQS24_2, 'Value', 0);
set(handles.RadioQS24_3, 'Value', 0);
set(handles.RadioQS24_4, 'Value', 0);
set(handles.RadioQS24_5, 'Value', 0);
set(handles.PanelQS24, 'Visible', 'off');
set(handles.PushButtonQS24, 'Visible', 'off');

% =========================================================
% Initialize as invisible the fifth question in Question Set 2
set(handles.PanelQS25, 'Visible', 'off');
set(handles.PushButtonDone, 'Visible', 'off');

% ========================================================
% Initialize the question number in Question Set 2 to be 1
set(handles.TxtQS2Num, 'String', '1');
 
% Choose default command line output for OutcomeScaleMeasure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OutcomeScaleMeasure wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutcomeScaleMeasure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% Get the money amount scale from orders of income and expense,
% respectively, and the significant amount.
AmountScale = handles.SignificantAmount;

% Output the money scale, type: scalar
varargout{1} = AmountScale;
% Output the answer to Question Set 1, type: 3 by 2 matrix
varargout{2} = handles.AnswerQS1;
% Output the answer to Question Set 2, type: 5 by 4 matrix
varargout{3} = handles.AnswerQS2;
% Output the text answer to question 2-5, type: string
varargout{4} = handles.EditQS25.String;


delete(hObject);

% --- Executes on button press in PushButtonQS21.
function PushButtonQS21_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonQS21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If an answer is provided, then go to the next question.
    % Get the responses of options
    Val1 = get(handles.RadioQS21_1, 'Value');
    Val2 = get(handles.RadioQS21_2, 'Value');
    Val3 = get(handles.RadioQS21_3, 'Value');
    Val4 = get(handles.RadioQS21_4, 'Value');
    Val5 = get(handles.RadioQS21_5, 'Value');
    Val  = Val1 + Val2 + Val3 +Val4 + Val5;
    
    ValVecQS21 = [Val1, Val2, Val3, Val4, Val5]';
    % Store this vector into handles.
    handles.AnswerQS21 = ValVecQS21;
    
   % If an answer is provided, then proceed.
    if Val > 0
       % This question is finished, so make it invisible.
       set(handles.PanelQS21, 'Visible', 'off');
       set(handles.PushButtonQS21, 'Visible', 'off');
       % Make the next question visible
       set(handles.PanelQS22, 'Visible', 'on');
       set(handles.PushButtonQS22, 'Visible', 'on');
       % Increase the question number in Question Set 2
       set(handles.TxtQS2Num, 'String', '2');
    % Otherwise, display the warning message.    
    else
        Warning = 'Please complete this question!';
        set(handles.TxtWarningMsg, 'String', Warning);
        load('attention.mat');
        sound(attention, attentionFs);
    end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in PushButtonQS22.
function PushButtonQS22_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonQS22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If an answer is provided, then go to the next question.
    % Get the responses of options
    Val1 = get(handles.RadioQS22_1, 'Value');
    Val2 = get(handles.RadioQS22_2, 'Value');
    Val3 = get(handles.RadioQS22_3, 'Value');
    Val4 = get(handles.RadioQS22_4, 'Value');
    Val5 = get(handles.RadioQS22_5, 'Value');
    Val  = Val1 + Val2 + Val3 +Val4 + Val5;
    
    ValVecQS22 = [Val1, Val2, Val3, Val4, Val5]';
    % Store this vector into handles.
    handles.AnswerQS22 = ValVecQS22;
   % If an answer is provided, then proceed.
    if Val > 0
       % This question is finished, so make it invisible.
       set(handles.PanelQS22, 'Visible', 'off');
       set(handles.PushButtonQS22, 'Visible', 'off');
       % Make the next question visible
       set(handles.PanelQS23, 'Visible', 'on');
       set(handles.PushButtonQS23, 'Visible', 'on');
       % Clear the warning message 
       set(handles.TxtWarningMsg, 'String', []);
       % Increase the question number in Question Set 2
       set(handles.TxtQS2Num, 'String', '3');
    % Otherwise, display the warning message.    
    else
        Warning = 'Please complete this question!';
        set(handles.TxtWarningMsg, 'String', Warning);
        load('attention.mat');
        sound(attention, attentionFs);
    end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in PushButtonQS23.
function PushButtonQS23_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonQS23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If an answer is provided, then go to the next question.
    % Get the responses of options
    Val1 = get(handles.RadioQS23_1, 'Value');
    Val2 = get(handles.RadioQS23_2, 'Value');
    Val3 = get(handles.RadioQS23_3, 'Value');
    Val4 = get(handles.RadioQS23_4, 'Value');
    Val5 = get(handles.RadioQS23_5, 'Value');
    Val  = Val1 + Val2 + Val3 +Val4 + Val5;

    ValVecQS23 = [Val1, Val2, Val3, Val4, Val5]';
    % Store this vector into handles.
    handles.AnswerQS23 = ValVecQS23;
    
   % If an answer is provided, then proceed.
    if Val > 0
       % This question is finished, so make it invisible.
       set(handles.PanelQS23, 'Visible', 'off');
       set(handles.PushButtonQS23, 'Visible', 'off');
       % Make the next question visible
       set(handles.PanelQS24, 'Visible', 'on');
       set(handles.PushButtonQS24, 'Visible', 'on');
       % Clear the warning message 
       set(handles.TxtWarningMsg, 'String', []);
       % Increase the question number in Question Set 2
       set(handles.TxtQS2Num, 'String', '4');
    % Otherwise, display the warning message.    
    else
        Warning = 'Please complete this question!';
        set(handles.TxtWarningMsg, 'String', Warning);
        load('attention.mat');
        sound(attention, attentionFs);
    end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in PushButtonQS24.
function PushButtonQS24_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonQS24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If an answer is provided, then go to the next question.
    % Get the responses of options
    Val1 = get(handles.RadioQS24_1, 'Value');
    Val2 = get(handles.RadioQS24_2, 'Value');
    Val3 = get(handles.RadioQS24_3, 'Value');
    Val4 = get(handles.RadioQS24_4, 'Value');
    Val5 = get(handles.RadioQS24_5, 'Value');
    Val  = Val1 + Val2 + Val3 +Val4 + Val5;

    ValVecQS24 = [Val1, Val2, Val3, Val4, Val5]';
    % Store this vector into handles.
    handles.AnswerQS24 = ValVecQS24;
    
   % If an answer is provided, then proceed.
    if Val > 0
       % This question is finished, so make it invisible.
       set(handles.PanelQS24, 'Visible', 'off');
       set(handles.PushButtonQS24, 'Visible', 'off');
       % Make the next question visible
       set(handles.PanelQS25, 'Visible', 'on');
       set(handles.PushButtonDone, 'Visible', 'on');
       % Clear the warning message 
       set(handles.TxtWarningMsg, 'String', []);
       % Increase the question number in Question Set 2
       set(handles.TxtQS2Num, 'String', '5');
    % Otherwise, display the warning message.    
    else
        Warning = 'Please complete this question!';
        set(handles.TxtWarningMsg, 'String', Warning);
        load('attention.mat');
        sound(attention, attentionFs);
    end
    
% =========================================================
% Prepare content for question 5.
    % Get the answers of the previous 4 questions in Question Set 2
    AnswerMatQS2 = [handles.AnswerQS21, handles.AnswerQS22, handles.AnswerQS23,...
                 handles.AnswerQS24]; % size: 5 by 4

    AnswerExtremVec = AnswerMatQS2(1, :);
    AnswerSignifVec = AnswerMatQS2(2, :);

    % Define the money amount vector
    AmountVec = [10, 100, 1000, 10000]';

    % If at least one question answered "significantly", the significant amount
    % is the minimum among the chosen amounts.
    if size( find(AnswerSignifVec, 1), 2 ) ~= 0
        SignifAmount = AmountVec( find(AnswerSignifVec, 1) );

    % If no "significantly" is chosen for the questions, check if at least one
    % question is answered as "Extremely". If yes, then the significant amount
    % is the minimum among the chosen amounts.
    elseif size( find(AnswerExtremVec, 1), 2 ) ~=0
        SignifAmount = AmountVec( find(AnswerExtremVec, 1) );

    % Otherwise, use 10000 as the default value and express my exclamation!     
    else
        SignifAmount = 10000; 
        set(handles.TxtWarningMsg, 'String', 'Are you serious?')
        load('attention.mat');
        sound(attention, attentionFs);
    end

    % Store the significant amount
    handles.SignificantAmount = SignifAmount;
    % Store their answers
    handles.AnswerQS2 = AnswerMatQS2;
    
    QuesStatement1 = 'List one important thing you can do with the $';
    QuesStatement2 = '. (e.g. Cover my vacation expense.)';

    % Display the question statement of question 5
    set(handles.TxtQS25Statement, 'String', [QuesStatement1,...
                                                num2str(SignifAmount),...
                                                    QuesStatement2]);

% Update handles structure
guidata(hObject, handles);
    
% --- Executes on button press in PushButtonDone.
function PushButtonDone_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If there is no input to the editable text box, then warn the user.
if size( get(handles.EditQS25, 'String'), 2 ) == 0
        Warning = 'Please provide your answer in the textbox!';
        set(handles.TxtWarningMsg, 'String', Warning);
        load('attention.mat');
        sound(attention, attentionFs);
        
% Otherwise, the program proceed.
else
    % Store their input answer
    uiresume(handles.figure1);
end


function EditQS25_Callback(hObject, eventdata, handles)
% hObject    handle to EditQS25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditQS25 as text
%        str2double(get(hObject,'String')) returns contents of EditQS25 as a double



% --- Executes on button press in PushButtonQS1.
function PushButtonQS1_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonQS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get answers from Question Set 1
Val1_1 = get(handles.RadioQ1_1, 'Value');
Val1_2 = get(handles.RadioQ1_2, 'Value');
Val1_3 = get(handles.RadioQ1_3, 'Value');

AnswerVec1 = [Val1_1, Val1_2, Val1_3]';
IncomeVec  = [100, 1000, 10000]';

% Get the order of magnitude of the user's income.
    % If the question is answered, get the value.
    if norm(AnswerVec1) ~= 0
        IncomeOrder = IncomeVec( find(AnswerVec1, 1) );
    
    % Otherwise, let's say 0
    else
        IncomeOrder = 0;
    end
% Store the order of income
handles.IncomeOrder = IncomeOrder;
    
    
Val2_1 = get(handles.RadioQ2_1, 'Value');
Val2_2 = get(handles.RadioQ2_2, 'Value');
Val2_3 = get(handles.RadioQ2_3, 'Value');

AnswerVec2 = [Val2_1, Val2_2, Val2_3]';
ExpenseVec  = [100, 1000, 10000]';

% Summarize and store the answers in Question Set 1
handles.AnswerQS1 = [AnswerVec1, AnswerVec2];

% Get the order of magnitude of the user's expense
    % If the question is answered, get the value.
    if norm(AnswerVec2) ~= 0
        ExpenseOrder = ExpenseVec( find(AnswerVec2, 1) );
    
    % Otherwise, let's say 0
    else
        ExpenseOrder = 0;
    end
% Store the order of expense
handles.ExpenseOrder = ExpenseOrder;

% Make Question Set 2 visible
set(handles.PanelQS2, 'Visible', 'on')

% Make the first question of Question Set 2 visible
set(handles.PanelQS21, 'Visible', 'on');
set(handles.PushButtonQS21, 'Visible', 'on');
% Update handles structure
guidata(hObject, handles);
