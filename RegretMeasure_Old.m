function RegretMeasure(ParticipantID,TestNumber, MoneyScale, WaitingTime)
% Run the regret measurement
% Two arguments should both be strings. ParticipantID is the identification
% of the participant. TestNumber is the enumerating of the tests among
% {'1', '2','3','4','5',}


% Pre-define the names of the fields used in the structure of a question
f1 = 'Question';
f2 = 'Iteration';
f3 = 'Belonging';
f4 = 'Generation';
f5 = 'Case'      ;
f6 = 'PreviousChoice';
f7 = 'NumChoiceChange';
f8 = 'CacluclationPad';
f9 = 'MoneyCost';
f10 = 'DegreeOfTruth';
f11 = 'InGroupIndex';
f12 = 'Recycle';

% Create and initialize the available set.
AvaSet = AvailableSet(ParticipantID, TestNumber, MoneyScale);

% Calculate the size of the available set.
[RowSize_AvaSet, ColSize_AvaSet] = size(AvaSet); 

% Create the empty complete W set.
SetW = cell(1,3);

% Define the index of the SetW
WInx = 1;

% Create the empty complete Q set.
SetQ = cell(2,9);


% Create the empty complete V set.
SetV = cell(2,10);


% Create an empty cell array to store results for each question.

    % W type
    ResultListCaseW1 = cell(1, 20);
    ResultListCaseW2 = cell(1, 20);

    % Q type
    ResultListCaseQ1 = cell(1, 20);
    ResultListCaseQ2 = cell(1, 20);
    ResultListCaseQ3 = cell(1, 20);
    ResultListCaseQ4 = cell(1, 20);
    ResultListCaseQ5 = cell(1, 20);
    ResultListCaseQ6 = cell(1, 20);
    ResultListCaseQ7 = cell(1, 20);
    ResultListCaseQ8 = cell(1, 20);
    
    % V type
    ResultListCaseV1 = cell(1, 2);
    ResultListCaseV2 = cell(1, 2);
    ResultListCaseV3 = cell(1, 2);
    ResultListCaseV4 = cell(1, 2);
    ResultListCaseV5 = cell(1, 2);
    ResultListCaseV6 = cell(1, 2);
    ResultListCaseV7 = cell(1, 2);
    ResultListCaseV8 = cell(1, 2);
    ResultListCaseV9 = cell(1, 2);
    ResultListCaseV10 = cell(1, 2);
      
% Create an empty vector to store the monetary cost
% Define the index of the ResultLists
ReInxW1 = 1;
ReInxW2 = 1;

ReInxQ1 = 1;
ReInxQ2 = 1;
ReInxQ3 = 1;
ReInxQ4 = 1;
ReInxQ5 = 1;
ReInxQ6 = 1;
ReInxQ7 = 1;
ReInxQ8 = 1;

ReInxV1 = 1;
ReInxV2 = 1;
ReInxV3 = 1;
ReInxV4 = 1;
ReInxV5 = 1;
ReInxV6 = 1;
ReInxV7 = 1;
ReInxV8 = 1;
ReInxV9 = 1;
ReInxV10 = 1;

% Define the index of the recorded question configuration with indifferent options
IndifCaseInx = 1;

% Create a empty vector to keep track of the recorded questions.
IndifCases = -10 * ones(1,9);

% Initial the progress to be 0
Prog = 0;

% Start of the first for loop, go through each modules 
for RowIndx_AvaSet = 1: RowSize_AvaSet  
    
    % Start of the second for loop, go through each question within a
    % module.
    for ColIndx_AvaSet = 1: ColSize_AvaSet
        % Progress spins once
        Prog = Prog + 1;

        % Display the separator page to indicate a separate question
        Separator(MoneyScale); 

        % Choose a question
        Ques   = AvaSet{RowIndx_AvaSet,ColIndx_AvaSet};

        % =================================================
        % Retrieve the question type indicator
        % =================================================
        TypeID = Ques.Belonging;


        % =================================================
        % Retrieve the question in group index
        % =================================================
        InGroupIndx = Ques.InGroupIndex;

        % =================================================
        % Retrieve the times of iteration
        % =================================================
        Iter = Ques.Iteration;

        % =================================================
        % Retrieve the generation of question evolution
        % =================================================
        Gen = Ques.Generation;

        % =================================================
        % Retrieve the case ID
        % =================================================
        CaseID = Ques.Case;

        % =================================================
        % Retrieve how may times the question is recycled
        % =================================================
        RecycNum = Ques.Recycle;

        % =================================================
        % Retrieve the previous choice
        % =================================================
        % PreviousChoice = Ques.PreviousChoice;

        % =================================================
        % Retrieve the number of choice changing in last 
        % consecutive steps.
        % =================================================
        CountDiff = Ques.NumChoiceChange;

        % =================================================
        % Call the GUI question page
        % =================================================

        % Retrieve the question content
        C_A = Ques.Question(1); 
        C_B = Ques.Question(2);
        C_AA = Ques.Question(3);
        Prob = Ques.Question(4);

        % Call the question page 
        [TruthVector, YourChoice, ActualCost, CalcPadCharac, CloseRequest]...
                         = QuestionPage(C_A,C_B,C_AA,Prob, WaitingTime, Prog);

        % Because the questionis answered once by the user, the iteration spins
        % forward one time. 
        Iter_Current = Iter + 1;

        % If the CloseRequest is placed by the user, break the while loop.
        if strcmpi(CloseRequest,'on')
            % break the while loop
            break;
        end

        % Updated information back its structure
        Ques = struct(f1,[C_A,C_B,C_AA,Prob],f2, Iter_Current,f3,TypeID, f4, Gen,...
                      f5, CaseID, f6, YourChoice, f7, CountDiff, f8, CalcPadCharac,...
                      f9, ActualCost, f10, TruthVector, ...
                                    f11, InGroupIndx, f12, RecycNum);

        % Start the counter of the choice oscillating
        % If the current choice is the same as the previous choice, resume the
        % counter to 0,
        %     if strcmpi(YourChoice, PreviousChoice)
        %         CountDiff = 0;
        %     % If the current choice is different to the previous choice, counter
        %     % pluses one.
        %     else
        %         CountDiff = CountDiff + 1;
        %     end

        % ==========================================================
        % Store your result.
        % ==========================================================

        % Determine the question type
        switch TypeID

            % when the question type is W
            case 'W'
                % Determine the question number
                switch InGroupIndx

                    % when it is the first question, store it into
                    % ResultListCaseW1.
                    case 1
                        ResultListCaseW1{ReInxW1} = Ques;
                        % spin once
                        ReInxW1 = ReInxW1 + 1;

                    % when it is the second question, store it into
                    % ResultListCaseW2.                    
                    case 2
                        ResultListCaseW2{ReInxW2} = Ques;
                         % spin once
                        ReInxW2 = ReInxW2 + 1;
                    otherwise
                        error('More W type questions than expected');
                end

            % When the question type is Q
            case 'Q'

                % Determine the question number
                switch InGroupIndx

                    % when it is the first question, store it into
                    % ResultListCaseQ1.
                    case 1
                        ResultListCaseQ1{ReInxQ1} = Ques;
                        % spin once
                        ReInxQ1 = ReInxQ1 + 1;

                    % when it is the second question, store it into
                    % ResultListCaseQ2.                    
                    case 2
                        ResultListCaseQ2{ReInxQ2} = Ques;
                         % spin once
                        ReInxQ2 = ReInxQ2 + 1;

                    % when it is the third question, store it into
                    % ResultListCaseQ3.                    
                    case 3
                        ResultListCaseQ3{ReInxQ3} = Ques;
                         % spin once
                        ReInxQ3 = ReInxQ3 + 1;

                    % when it is the fourth question, store it into
                    % ResultListCaseQ4.                    
                    case 4
                        ResultListCaseQ4{ReInxQ4} = Ques;
                         % spin once
                        ReInxQ4 = ReInxQ4 + 1;

                    % when it is the fifth question, store it into
                    % ResultListCaseQ5.                    
                    case 5
                        ResultListCaseQ5{ReInxQ5} = Ques;
                         % spin once
                        ReInxQ5 = ReInxQ5 + 1;

                    % when it is the sixth question, store it into
                    % ResultListCaseQ6.                    
                    case 6
                        ResultListCaseQ6{ReInxQ6} = Ques;
                         % spin once
                        ReInxQ6 = ReInxQ6 + 1;

                     % when it is the seventh question, store it into
                    % ResultListCaseQ7.                    
                    case 7
                        ResultListCaseQ7{ReInxQ7} = Ques;
                         % spin once
                        ReInxQ7 = ReInxQ7 + 1;

                     % when it is the eighth question, store it into
                    % ResultListCaseQ8.                    
                    case 8
                        ResultListCaseQ8{ReInxQ8} = Ques;
                         % spin once
                        ReInxQ8 = ReInxQ8 + 1;

                    otherwise
                        error('More Q type questions than expected');
                end

            % when the question type is 'Q'    
            case 'V'
             % Determine the question number
                switch InGroupIndx

                    % when it is the first question, store it into
                    % ResultListCaseV1.
                    case 1
                        ResultListCaseV1{ReInxV1} = Ques;
                        % spin once
                        ReInxV1 = ReInxV1 + 1;

                    % when it is the second question, store it into
                    % ResultListCaseV2.                    
                    case 2
                        ResultListCaseV2{ReInxV2} = Ques;
                         % spin once
                        ReInxV2 = ReInxV2 + 1;

                    % when it is the third question, store it into
                    % ResultListCaseV3.                    
                    case 3
                        ResultListCaseV3{ReInxV3} = Ques;
                         % spin once
                        ReInxV3 = ReInxV3 + 1;

                    % when it is the fourth question, store it into
                    % ResultListCaseV4.                    
                    case 4
                        ResultListCaseV4{ReInxV4} = Ques;
                         % spin once
                        ReInxV4 = ReInxV4 + 1;

                    % when it is the fifth question, store it into
                    % ResultListCaseV5.                    
                    case 5
                        ResultListCaseV5{ReInxV5} = Ques;
                         % spin once
                        ReInxV5 = ReInxV5 + 1;

                    % when it is the sixth question, store it into
                    % ResultListCaseV6.                    
                    case 6
                        ResultListCaseV6{ReInxV6} = Ques;
                         % spin once
                        ReInxV6 = ReInxV6 + 1;

                     % when it is the seventh question, store it into
                    % ResultListCaseV7.                    
                    case 7
                        ResultListCaseV7{ReInxV7} = Ques;
                         % spin once
                        ReInxV7 = ReInxV7 + 1;

                     % when it is the eighth question, store it into
                    % ResultListCaseV8.                    
                    case 8
                        ResultListCaseV8{ReInxV8} = Ques;
                         % spin once
                        ReInxV8 = ReInxV8 + 1;                
                    % when it is the seventh question, store it into
                    % ResultListCaseV9.                    
                    case 9
                        ResultListCaseV9{ReInxV9} = Ques;
                         % spin once
                        ReInxV9 = ReInxV9 + 1;
                    % when it is the eighth question, store it into
                    % ResultListCaseV10.                    
                    case 10
                        ResultListCaseV10{ReInxV10} = Ques;
                         % spin once
                        ReInxV10 = ReInxV10 + 1;                
                     otherwise
                        error('More V type questions than expected');
                end

            otherwise
                error('Unexpected question type received.');
        end
        % The end of storing the result.

        % ==========================================================
        % Update the current question based on the response
        % ==========================================================


        % TruthVector is degree of truth of
        % [ prefer R, Prefer H, Indifferent, Slow, Fast]. 
        DT_R = TruthVector(1);
        DT_H = TruthVector(2);
        DT_I = TruthVector(3);
        DT_S = TruthVector(4);
        DT_F = TruthVector(5);

        % Rule 1: If prefer R and fast, than Epsilon1 (-Delta1)
        DT_rule1 = min(DT_R, DT_F);

        % Rule 2: If prefer R and slow, than Epsilon2 (-Delta2)
        DT_rule2 = min(DT_R, DT_S);

        % Rule 3: If indifferent and fast, than 0
        DT_rule3 = min(DT_I, DT_F);

        % Rule 4: If indifferent and slow, than 0
        DT_rule4 = min(DT_I, DT_S);

        % Rule 5: If prefer H and fast, than -Epsilon1 (Delta1)
        DT_rule5 = min(DT_H, DT_F);

        % Rule 6: If prefer H and slow, than -Epsilon2 (Delta2)
        DT_rule6 = min(DT_H, DT_S);

        % The sum of rule degree of truth is,
        SumDT_rule = DT_rule1 + DT_rule2 + DT_rule3 + DT_rule4...
                     + DT_rule5 + DT_rule6;

        % If this is a question of type W
        if strcmpi(TypeID,'W')

            % ======================================================
            % Update the question base on the update rule of W
            % ======================================================

            % ---------------------------------------------------
            % Define the fuzzy controller for W function
            % ---------------------------------------------------
            % The control matrix is
            %          Prefer R       Indifferent     Prefer H
            %        --------------------------------------------
            % Fast   | Epsilon1         0             -Epsilon1
            % Slow   | Epsilon2         0             -Epsilon2

            % Define control signals
            Epsilon1 = 2;
            Epsilon2 = 0.4;

            % Sythesize the control signal,
                % The denominator is the sum of the rule degree of truth
                % The numerator is:
                Nmrt_w = DT_rule1 * Epsilon1 + DT_rule2 * Epsilon2...
                         -DT_rule5 * Epsilon1 - DT_rule6 * Epsilon2;        
                % The sythesized control signal is:
                u_w  = Nmrt_w / SumDT_rule;

            % Update the value of C_B and round to 0.1
            C_B = C_B + round( u_w *10)/10;

        % If this is a question of type Q   
        elseif strcmpi(TypeID,'Q')

            % ======================================================
            % Update the question base on the update rule of Q
            % ======================================================

            % ---------------------------------------------------
            % Define the fuzzy controller for Q function
            % ---------------------------------------------------
            % The control matrix is
            %          Prefer R       Indifferent     Prefer H
            %        --------------------------------------------
            % Fast   |  -Delta1         0             Delta1
            % Slow   |  -Delta2         0             Delta2
                    % Define control signals
            Delta1 = 0.6;
            Delta2 = 0.1;

            % Sythesize the control signal,
                % The denominator is the sum of the rule degree of truth
                % The numerator is:
                Nmrt_q = DT_rule1 * (-Delta1) + DT_rule2 * (-Delta2)...
                         +DT_rule5 * Delta1 + DT_rule6 * Delta2;        
                % The sythesized control signal is:
                u_q  = Nmrt_q / SumDT_rule;

            % Update the value of  and round to 0.001%
            s = log(Prob) - log(1-Prob);
            s = s + u_q;
            Prob = 1/( 1+exp(-s) ); 

       % Otherwise, this question is of type V   
        else
            % ============================================
            % Store this question into the completed V set
            % ============================================
            SetV{Iter_Current, InGroupIndx} = Ques; 

             % If the question has not been recycled, put it back into the
             % question pool. 
                    if RecycNum < 1

                        % =======================================================
                        % Construct the questoin structure for the new
                        % iteration and append the question to the end of non-empty
                        % elements in the available set.
                        % =======================================================

                        % The question is recycled one more time.
                        RecycNumNext = RecycNum + 1;
                        AvaSet{1,Adrs+19} = struct(f1,[C_A,C_B,C_AA,Prob],...
                                    f2,Iter_Current,f3,TypeID, f4, Gen,...
                                    f5, CaseID, f6, YourChoice, f7, CountDiff,...
                                    f8, CalcPadCharac,...
                                    f9, ActualCost, f10, TruthVector,...
                                    f11, InGroupIndx, f12, RecycNumNext);
                        % Delete the question from the current position.        
                        AvaSet(Adrs) = [];
                    % Otherwise, the generation is high enough, delete this
                    % question from the pool.
                    else
                        % Delete this question from the available set
                        AvaSet(Adrs) = [];
                    end
        % End of "if this is a question of type W"    
        end

        % =================================================================
        % Determine the update operation and storing path for this question
        % =================================================================    
        % The the question is not the validation question
        if ~strcmpi(TypeID,'V')

            % ======================================================
            % Store the updated information back its structure
            % ======================================================
            % Round the probability to 0.0001;
            Prob    = min(0.99999, max(round( Prob*100000 ) / 100000,0.00001) );

            % Store the updated information back its structure
            Ques = struct(f1,[C_A,C_B,C_AA,Prob],f2,Iter_Current,f3,TypeID, f4, Gen,...
                  f5, CaseID, f6, YourChoice, f7, CountDiff, f8, CalcPadCharac,...
                  f9, ActualCost, f10, TruthVector,f11, InGroupIndx, f12, RecycNum);    

            % If the response is close to indifferent attitude 
            if DT_I >=0.75

                % And further if the question is of type W
                if strcmpi(TypeID, 'W')      
                    % ============================================
                    % Store this question into the completed W set
                    % ============================================
                    SetW{WInx} = Ques;

                    % The WInx moves to the next position
                    WInx = WInx + 1;

                    % Store the case ID to the tracking vector
                    IndifCases(IndifCaseInx)= CaseID;

                    % Move the index to the indifferent cases to the next.
                    IndifCaseInx = IndifCaseInx + 1;

                    % If this question is NOT the last elicitation point of the W
                    % function (last generation),
                    if Gen < 2

                        % ====================================================
                        % Evolve the question of W type to the next generation
                        % ====================================================
                        % Redefine the new C_AA
                        C_AA_Nxt = C_B;

                        % Redefine the new initial value of C_B 
                        C_B_Nxt = C_AA_Nxt * (1-Prob) + C_A * Prob;

                        % Update the CaseID
                        CaseID = CaseID + 1;
                        % Restore the times of iteration back to 0
                        Iter_New = 0;
                        % Restore the recycle times
                        RecycNum_New = 0;
                        % Indicate it is the next generation
                        Gen_Nxt = Gen + 1;

                        % Indicate it is the next case
                        InGroupIndx = InGroupIndx + 1;

                        % =======================================================
                        % Construct the questoin structure for the new generation
                        % and store in the same location in the available set.
                        % =======================================================
                        AvaSet{1,Adrs} = struct(f1,[C_A,C_B_Nxt,C_AA_Nxt,Prob],...
                                    f2,Iter_New,f3,TypeID, f4, Gen_Nxt,...
                                    f5, CaseID, f6, YourChoice, f7, CountDiff,...
                                    f8, CalcPadCharac,...
                                    f9, ActualCost, f10, TruthVector, ...
                                    f11, InGroupIndx, f12, RecycNum_New);

                        % If the question has not been recycled, recycle it.
                        if RecycNum < 1

                            % The question is recycled one more time.
                            RecycNumNext = RecycNum + 1;
                            Ques.Recycle = RecycNumNext;
                            AvaSet{1,Adrs+19} = Ques;    
                        end

                    % If this question of type W is the last generation,
                    else 

                        % If the question has not been recycled, recycle it.
                        if RecycNum < 1

                            % Now the question is recycled one more time.
                            RecycNumNext = RecycNum + 1;
                            Ques.Recycle = RecycNumNext;
                            AvaSet{1,Adrs+19} = Ques;
                        end
                        % ===========================================
                        % Delete this question from the available set
                        % ===========================================
                        AvaSet(Adrs) = [];

                    % End of "if this question is not the last generation"    
                    end

                % If the question is of type Q 
                else

                    % ============================================
                    % Store this question into the completed Q set
                    % ============================================
                    SetQ{Gen, InGroupIndx} = Ques;

                    % Store the case ID to the tracking vector
                    IndifCases(IndifCaseInx)= CaseID;

                    % Move the index to the indifferent cases to the next.
                    IndifCaseInx = IndifCaseInx + 1;

                    % If the question has not been recycled, recycle it.
                    if RecycNum < 1
                        % The question is recycled one more time.
                        RecycNumNext = RecycNum + 1;
                        Ques.Recycle = RecycNumNext;
                        AvaSet{1,Adrs+19} = Ques;
                    end
                    % Delete this question from the current location in the 
                    % available set
                    AvaSet(Adrs) = [];


                % End of "And further if the question is of type W "    
                end

            % If the responses osillates around the indifferent attitude, we assume
            % the indifferent configuration of the question is the average of the
            % previous data and the updated data.
    %         elseif CountDiff > 8
    %             % Resume the counter to 0
    %             CountDiff = 0;
    % 
    %             % ======================================================
    %             % Store the updated information back its structure
    %             % ======================================================
    %             % The values of C_B and Prob to construct indifferent options are
    %             % the average of the previous and the updated C_B and Prob,
    %             % respectively.
    %             C_B = (C_B+Previous_C_B)/2;
    %             Avg_LogProbW = (LogProbW + Previous_LogProbW)/2;
    %             Avg_LogProbR = (LogProbR + Previous_LogProbR)/2;
    %             % Inverse logarithm transformation
    %             if (C_AA-C_B) < (C_B-C_A)
    %                 Prob = 1 - exp( Avg_LogProbW );
    %             else
    %                 Prob = exp( Avg_LogProbR );
    %             end
    %             % Round the probability to 0.0001;
    %             Prob    = min(0.999999, max(round( Prob*1000000 ) / 1000000,0.000001));
    %             % Store the updated information back its structure
    %             Ques = struct(f1,[C_A,C_B,C_AA,Prob],f2,Iter+1,f3,TypeID, f4, Gen,...
    %                           f5, CaseID, f6, YourChoice, f7, CountDiff);
    % 
    %              % And further if the question is of type W
    %             if strcmpi(TypeID, 'W')
    % 
    %                 % ============================================
    %                 % Store this question into the completed W set
    %                 % ============================================
    %                 SetW{WInx} = Ques;
    %                 % The WInx moves to the next position
    %                 WInx = WInx + 1;
    %                 
    %                 % Store the case ID to the tracking vector
    %                 IndifCases(IndifCaseInx)= CaseID;
    %                 
    %                 % Move the index to the indifferent cases to the next.
    %                 IndifCaseInx = IndifCaseInx + 1;
    %                 
    %                 % If this question is NOT the last elicitation point of the W
    %                 % function (last generation),
    %                 if Gen < 5
    % 
    %                     % ====================================================
    %                     % Evolve the question of W type to the next generation
    %                     % ====================================================
    %                     % Redefine the new C_AA
    %                     C_AA_Nxt = C_B;
    % 
    %                     % Redefine the new initial value of C_B 
    %                     C_B_Nxt = C_AA_Nxt * (1-Prob) + C_A * Prob;
    % 
    %                     % Update the CaseID
    %                     CaseID = CaseID + 1;
    % 
    %                     % Restore the times of iteration back to 0
    %                     Iter_New = 0;
    % 
    %                     % Indicate it is the next generation
    %                     Gen_Nxt = Gen + 1;
    % 
    %                     % =======================================================
    %                     % Construct the questoin structure for the new generation
    %                     % and store in the same location in the available set.
    %                     % =======================================================
    %                     AvaSet{1,Adrs} = struct(f1,[C_A,C_B_Nxt,C_AA_Nxt,Prob],...
    %                                 f2,Iter_New,f3,TypeID, f4, Gen_Nxt,...
    %                                 f5, CaseID, f6, YourChoice, f7, CountDiff); 
    % 
    %                 % If this question of type W is the last generation,
    %                 else 
    %                     % ===========================================
    %                     % Delete this question from the available set
    %                     % ===========================================
    %                     AvaSet(Adrs) = [];
    %                 % End of "if this question is not the last generation"    
    %                 end

                % If the question is of type Q 
    %             else
    % 
    %                 % ============================================
    %                 % Store this question into the completed Q set
    %                 % ============================================
    %                 SetQ{QInx} = Ques;
    %                 % The WInx moves to the next position
    %                 QInx = QInx + 1;
    %                 
    %                 % Store the case ID to the tracking vector
    %                 IndifCases(IndifCaseInx)= CaseID;
    %                 
    %                 % Move the index to the indifferent cases to the next.
    %                 IndifCaseInx = IndifCaseInx + 1;
    %                 
    %                 % ===========================================
    %                 % Delete this question from the available set
    %                 % ===========================================
    %                 AvaSet(Adrs) = [];
    % 
    %             % End of "And further if the question is of type W "    
    %             end





            % ===========================================================
            % Otherwise, if the respose is NOT close to indifferent attitude         
            else 
               % If the question is unrecycled,
               if RecycNum < 1

                   % and if the Iteration times is less then 10, keep the question
                   % at the current location,
                   if Iter_Current < 10
                        AvaSet{1,Adrs} = Ques;

                    % or, if current iteration is equal 10 times,
                    % recycle this option.
                   else
                       % The question is recycled one more time.
                        RecycNumNext = RecycNum + 1;
                        Ques.Recycle = RecycNumNext;
                        AvaSet{1,Adrs+19} = Ques;

                        % Delete this question from the current location in the 
                        % available set
                        AvaSet(Adrs) = [];  
                   end


                % Otherwise, if the question has been recycled once,  
               else
                   % and if the iteration times is less then 15 times, keep the
                   % question at the current location.
                   if Iter_Current < 15
                       AvaSet{1,Adrs} = Ques;

                   % or, if the iteration times equal 15 times, delete the
                   % question from the question pool
                   else
                       AvaSet(Adrs) = [];  
                   end



                % The end of "% If the question is unrecycled".
               end


            % End of "If the respose is close to indifferent attitude "
            end

        % End of "If the question is not validation question,"
        end    
        % ====================================
        % Update the size of the available set
        % End of the while loop    
        % ====================================
        Size_AvaSet = size(AvaSet,2);
        
    % End of the second for loop    
    end
  
% End of the first for loop
end

% Store all the answered questions into a single cell array
    ResultList = {ResultListCaseW1, ResultListCaseW2,...
                  ResultListCaseQ1, ResultListCaseQ2,...
                  ResultListCaseQ3, ResultListCaseQ4,...
                  ResultListCaseQ5, ResultListCaseQ6,...
                  ResultListCaseQ7, ResultListCaseQ8,...
                  ResultListCaseV1, ResultListCaseV2,...
                  ResultListCaseV3, ResultListCaseV4,...
                  ResultListCaseV5, ResultListCaseV6,...
                  ResultListCaseV7, ResultListCaseV8,...
                  ResultListCaseV9, ResultListCaseV10};

% Save the results.
save(...
    ['ParticipantsRegretData/NewParticipant/' ParticipantID '_' TestNumber...
                                                                 '.mat'],...
    'SetQ','SetW','SetV','ResultList');

 % If the CloseRequest is placed by the user, display the error message
if strcmpi(CloseRequest,'on')
    error('The program is force to close.');
end
