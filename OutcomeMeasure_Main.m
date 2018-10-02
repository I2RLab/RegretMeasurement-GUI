
 function MoneyScale = OutcomeMeasure_Main(ParticipantID, TestNumber)

%  % Get the ID of the participant.
% ParticipantID = input('Input your initials:  ', 's');
% TestNumber    = input(['What is this trial? t (Traning), 1 (first),'...
%                       ' 2 (second), 3 (third),' ...
%                       ' 4 (fourth), 5 (fifth) or 6 (sixth)?'],'s');
 
% Call the OutcomeScale Measure function
[MoneyScale, AnsQS1, AnsQS2, AnsQ2_5] = OutcomeScaleMeasure;

% Save the results.
save(...
    ['ParticipantsRegretData/' ParticipantID '_' TestNumber...
                                             'OutcomeScaleMeasure.mat'],...
    'MoneyScale','AnsQS1','AnsQS2','AnsQ2_5');