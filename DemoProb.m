% Show the resolved results in the interface
function DemoProb()

% Assign a value to the probability
P_round = 0.90;


% Plot the visualization of the probability

    % Subplot 1
    AxTop = subplot(5,1,2);
    TitleTop = ['One round event realization (Probability: ', ...
                                                num2str(P_round), ')'];
    ProbabilityDistribution(P_round, AxTop, TitleTop);
    shg;
    
    % Subplot 2
    AxBottom = subplot(5,1,4);
    TitleBottom = 'History of happend events';
    ProbabilityDistribution(P_round, AxBottom, TitleBottom);
    


% Plot the initial marker
    % Add a time delay for visualization
    pause(1);
    
    MarkerLoc = rand;
    RandomMarker(AxTop, MarkerLoc);
    RandomMarker(AxBottom, MarkerLoc);

for i = 2:300
    
     % Add a time delay for visualization
    if i < 10
        pause(3);
    elseif i == 10
        input('Press enter to continue.');
        shg;
        pause(0.1);
    else
        pause(0.1);
    end
    
    % Delete the previous marker on the top subplot.
    delete(AxTop.Children(1));
    
    % Plot another random marker.
    MarkerLoc = rand;
    RandomMarker(AxTop, MarkerLoc);
    RandomMarker(AxBottom, MarkerLoc);


end

% Close the figure
% close all;

% Wait for the command to continue
input('Press enter to continue.');
  
% Show survey question pages
 SurveyQuestions(0);
 SurveyQuestions(1);
 SurveyQuestions(2);

% Close all figures at the end of the demo
close all;

function RandomMarker(Ax, RandomForProb)
    % Plot the random marker to indicate the resolved probability
    hold(Ax,'on');
    GX   = ones(1,2);
    GY   = [0.6, 1.4];
    plot(Ax, RandomForProb*GX,GY,'-b','Linewidth',2);
    hold(Ax,'off');
    
    
function ProbabilityDistribution(P_round, Ax, Title)
    A_barhX = [0, 1, 2];
    A_barhY = [0, 0; ...
               P_round, 1-P_round;
               0, 0];
    
    barh(Ax, A_barhX, A_barhY, 'stacked');  
    % Choose the right color for each bar
    colormap(Ax, [0.94, 0.94, 0.94; 0.5, 0.5, 0.5]);
    % Make sure the bars occupy the full axes.
    ylim(Ax, [0.6, 1.4]);
    % Name the plot
    title(Ax, Title);
    % Set the ticks for x-axis from 0 to 1 with sets of 0.1
    set(Ax, 'XTick',0:0.1:1);
    % Set the ticks for y-axis as empty
    set(Ax, 'YTick', []);
    % Plot the home-made grids in front of the bars.
        % hold the plot
        hold(Ax, 'on');
        % Define each line of the grid
        GX = ones(1,2);
        GY = [0.6, 1.4];
        % Create the grid
        plot(Ax, 0.05*GX, GY,'k:', ...  
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
        hold(Ax, 'off');