% Clear workspace
clear;
close all;
clc;

tic;
% Get the ID of the participant.
ParticipantID = input('Input your identity code:  ', 's');
TestNumber    = input('What is this trial? t (Traning) or 1 (first)','s');
 
% To allow the participants enough time to read the question statement,
% time delay of the response panels is implemented.
WaitingTime = 10;                   
                                
% Choose a session to start         
if strcmp(TestNumber,'t')||strcmp(TestNumber,'1')
    
    % Measure the scale of the significant amount of money
    MoneyScale = OutcomeMeasure_Main(ParticipantID, TestNumber);
    % Display the delineator
    EndOfPart; 

    % Measure the regret
    RobotHumanCollabScenario(MoneyScale);
    RegretMeasure(ParticipantID, TestNumber, MoneyScale, WaitingTime);
        
else
    error('Invalid input for the number of trial.');
end

% Finish the experiment
Finish(2, 2);
disp('Well done, you have finished this trial!');   
t= toc;  
disp(['Total time spend: ', char(10), num2str(t/60), 'min']);
         
    