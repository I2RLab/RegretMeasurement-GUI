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
AvaSet = AvailableSet(TestNumber, MoneyScale);

% Calculate the size of the available set.
[RowSize_AvaSet, ColSize_AvaSet] = size(AvaSet); 

% Create an empty cell array to store results for each question.
ResultArray = cell(12, 12); % the column is 10 + 2, with the first 10 columns
                            % correspond to the columns in AvaSet and the 
                            % last 2 columns for the two indifferent cases
                            % of this module (row).
                            
% % Define the index of the recorded question configuration with indifferent options
% IndifCaseInx = 1;
% 
% % Create a empty vector to keep track of the recorded questions.
% IndifCases = -10 * ones(1,9);

% Initial the progress to be 0
Prog = 0;

% Start of the first for loop, go through each modules 
for RowIndx_AvaSet = 1:RowSize_AvaSet  
    
    % Start of the second for loop, go through each question within a
    % module.
    for ColIndx_AvaSet = 1: ColSize_AvaSet
        
        % Save the results in case any inner error happens.
        save(...
        ['ParticipantsRegretData/' ParticipantID '_' TestNumber...
                                                                 '.mat'],...
         'ResultArray', 'AvaSet');   
           
        % Determine the title of the seperation page. For the very first
        % page, the title is "Begin"; for the following pages, the title is
        % "Start Over"
        if Prog < 1
            TitleCase = 1;
        else
            TitleCase = 2;
        end
        
        % Progress spins once
        Prog = Prog + 1;

        % Display the separator page to indicate a separate question
        Separator(MoneyScale, TitleCase); 

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

        % Updated user response back its structure
        Ques = struct(f1,[C_A,C_B,C_AA,Prob],f2, Iter_Current,f3,TypeID, f4, Gen,...
                      f5, CaseID, f6, YourChoice, f7, CountDiff, f8, CalcPadCharac,...
                      f9, ActualCost, f10, TruthVector, ...
                      f11, InGroupIndx, f12, RecycNum);

        % Store this result
        ResultArray{RowIndx_AvaSet, ColIndx_AvaSet} = Ques;
        
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
            Epsilon1 = 0.1;
            Epsilon2 = Epsilon1/8;

            % Sythesize the control signal,
                % The denominator is the sum of the rule degree of truth
                % The numerator is:
                Nmrt_w = DT_rule1 * Epsilon1 + DT_rule2 * Epsilon2...
                         -DT_rule5 * Epsilon1 - DT_rule6 * Epsilon2;        
                % The sythesized control signal is:
                u_w  = Nmrt_w / SumDT_rule;

            % Scale C_B to a dimensionless value
            C_B_Scale = C_B/(-C_AA);
                
            % Update the scaled C_B and round to 0.001
            C_B_Scale = C_B_Scale + round( u_w *1000)/1000;
            
            % Scale the dimensionless C_B_Scale back to dimensional C_B
            C_B = C_B_Scale * (-C_AA);

            % Set boundaries for C_B
            
            C_B = min(0, max(C_B, C_AA));
            
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
            Delta1 = 0.4;
            Delta2 = Delta1/8;

            % Sythesize the control signal,
                % The denominator is the sum of the rule degree of truth
                % The numerator is:
                Nmrt_q = DT_rule1 * (-Delta1) + DT_rule2 * (-Delta2)...
                         +DT_rule5 * Delta1 + DT_rule6 * Delta2;        
                % The sythesized control signal is:
                u_q  = Nmrt_q / SumDT_rule;
    
            % Introduce damping on u_q when Prob is close to 0.5. This
            % damping improves the controlling performance near p=0.5.
                % Define the distance of Prob to 0.5 as a new variable
                % DistProb
                DistProb = abs(Prob-0.5);
                
                % Define two gains
                    % The gain of u_q at p=0 or p=1
                    k_1or0 = 1;
                    % The gain of u_q at p=0.5
                    k_05   = k_1or0 / 5 ;
                % Calculate the damping
                k = 2 * DistProb * k_1or0 - ( 2*DistProb - 1) * k_05;
                
                
            % Update the value
                % Transform the probability to state s
                s = log(Prob) - log(1-Prob);
                
                % Update the state
                s = s + k * u_q;
                
                % Transform state s back to the probability
                Prob = 1/( 1+exp(-s) ); 

       % Otherwise, this question is of type, no further task needs to
       % do, skip the remained body of this iteration.
        else
            continue;
        end

       % update the information to the question struction
       Prob    = min(0.999, max(round( Prob*1000 ) / 1000,0.001) );

       % Store the updated information back its structure and initialize 
       % user responses
        % Define initial values
        InitialChoice = 'N';
        InitCalcPadCharac = cell(1,1);
        InitDT = -1*ones(5,1);
        InitCost = -1;
       
       Ques_Next = struct(f1,[C_A,C_B,C_AA,Prob],f2,Iter_Current,f3,TypeID, f4, Gen,...
          f5, CaseID, f6, InitialChoice, f7, CountDiff, f8, InitCalcPadCharac,...
          f9, InitCost, f10, InitDT,f11, InGroupIndx, f12, RecycNum);  

        % =================================================================
        % Determine the update operation
        % =================================================================   
        
        % If the response is close to indifferent attitude 
        if DT_I == 1
            
            % Update the information further in the ResultArray
                % If this is the first time to be indifferent, store the
                % updated question in the second last column within the 
                % ResultArray
                if RecycNum < 1
                    ResultArray{RowIndx_AvaSet, end-1} = Ques_Next;
                    
                    % Spin the number of recycle once.
                    RecycNum = RecycNum + 1;
                    
                    % Update the number of recycle to the question
                    % structure
                    Ques_Next.Recycle = RecycNum;
                    
                    % Recycle the question to the end of this module for
                    % conformation.
                    AvaSet{RowIndx_AvaSet, end} = Ques_Next;
                    
                % Otherwise, this is the second time to be indifferent,
                % store the updated question in the last column within the 
                % ResultArray
                else
                    ResultArray{RowIndx_AvaSet, end} = Ques_Next;
                end   

            % And further if the question is of type W
            if strcmpi(TypeID, 'W')      

                % If this question is NOT the last elicitation point (i.e. last generation)
                % of the W function (i.e. last generation),
                if Gen < 2
                    
                    % Evolve the Question of W type to the Next Generation
                   
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

                        % Construct the questoin structure for the new generation
                        % and store in the same location in the available set.
                        AvaSet{2,1} = struct(f1,[C_A,C_B_Nxt,C_AA_Nxt,Prob],...
                                    f2,Iter_New,f3,TypeID, f4, Gen_Nxt,...
                                    f5, CaseID, f6, InitialChoice, f7, CountDiff,...
                                    f8, InitCalcPadCharac,...
                                    f9, InitCost, f10, InitDT, ...
                                    f11, InGroupIndx, f12, RecycNum_New); 
                % End of "if this question is not the last generation"    
                end
                
                % If the index does not point at the last two questions in
                % the current module,
                if ColIndx_AvaSet < ColSize_AvaSet -1   
                    
                    % Update the Question in the Current Generation
                    %
                    % Start a new iteration for the current point. Take
                    % current option configuration as the baseline, the
                    % initial starting configuration is on one side of this
                    % baseline. The new starting configuration will be on
                    % the other side of this baseline.
                        % Decide the current option config (i.e. baseline)
                        C_B_Baseline = C_B;
                        
                        % Calculate the initial starting config
                        C_B_InitStart = C_AA*Prob;
                        
                        % Decide which side the new starting config is
                        % based on the baseline
                        Sign_C_B = -1 * sign(C_B_InitStart - C_B_Baseline);
                            % In case Sign_C_B == 0
                            if Sign_C_B == 0
                                Sign_C_B = -1;
                            end

                        % Further update the question to construct the new
                        % starting config.
                        
                            % Scale C_B_Baseline to a dimensionless value
                            C_B_Scale_BL = C_B_Baseline/(-C_AA);
                            
                            % Define the magnitude of the jump
                            C_B_Jump = 0.1;
                            % Update the scaled C_B_Baseline
                            C_B_Scale_NS = C_B_Scale_BL + Sign_C_B * C_B_Jump;

                            % Scale the dimensionless C_B_Scale_BL back to
                            % dimensional C_B_Baseline
                            C_B_NewStart = C_B_Scale_NS * (-C_AA);

                            % Set boundaries for C_B
                            C_B_NewStart = min(0, max(C_B_NewStart, C_AA));
                            
                        % Further update the question
                        Ques_NewStart = Ques_Next;
                        Ques_NewStart.Question = [C_A,C_B_NewStart,...
                                                  C_AA,Prob];
                                     
                        % Set the new starting question to be the next
                        % question in the current module.
                        AvaSet{RowIndx_AvaSet, ColIndx_AvaSet + 1} =...
                                                        Ques_NewStart;
                                                        
                % The end of "if the index does not point at the last question" 
                end
            
            % Otherwise, the question type must be Q.     
            else
                
                % If the index does not point at the last two questions in
                % the current module,
                if ColIndx_AvaSet < ColSize_AvaSet - 1       
                    
                    % Update the Question in the Current Generation
                    %
                    % Start a new iteration for the current point. Take
                    % current option configuration as the baseline, the
                    % initial starting configuration is on one side of this
                    % baseline. The new starting configuration will be on
                    % the other side of this baseline.
                        % Decide the current option config (i.e. baseline)
                        C_B_Baseline = C_AA * (1-Prob) + C_A * Prob;
                        
                        % Calculate the initial starting config
                        C_B_InitStart = C_B;
                        
                        % Decide which side the new starting config is
                        % based on the baseline
                        Sign_s = -1 * sign(C_B_InitStart-C_B_Baseline);
                        
                        % Further update the question to construct the new
                        % starting config.
                            % Transfer Prob to state s
                            s_Baseline = log(Prob) - log(1-Prob);
                            
                            % Update the state
                                % Define the jump magnitude
                                s_Jump = 0.2;
                                % Update the state
                                s_NewStart = s_Baseline + s_Jump * Sign_s;
                                
                            % Transfer state s back to Prob
                            Prob_NewStart = 1/( 1+exp(-s_NewStart) ); 
  
                        % Further update the question
                        Ques_NewStart = Ques_Next;
                        Ques_NewStart.Question = [C_A,C_B,...
                                                  C_AA,Prob_NewStart];
                                     
                        % set the new starting question to be the next
                        % question in the current module.
                        AvaSet{RowIndx_AvaSet, ColIndx_AvaSet + 1} =...
                                                        Ques_NewStart;
                    
                % The end of "if the index does not point at the last question"     
                end 
                
            % End of "And further if the question is of type W "    
            end

        % Otherwise, if the respose is NOT close to indifferent attitude         
        else 
            
            % Further if the index does not point at the last two questions in
            % the current module,
            if ColIndx_AvaSet < ColSize_AvaSet - 1
                
                % use the question with the updated information as the next
                % question.
                AvaSet{RowIndx_AvaSet, ColIndx_AvaSet + 1} = Ques_Next;
            
            % Otherwise, if the current question is the second last question
            % in the current module, 
            elseif ColIndx_AvaSet < ColSize_AvaSet
                    
                % furthermore, if none indifference has been obtained before,
                % the last question of the current module is empty.
                if RecycNum < 1
                    
                    % use the question with the updated information as the next
                    % question.
                    AvaSet{RowIndx_AvaSet, ColIndx_AvaSet + 1} = Ques_Next;
                
                % otherwise, the indifference has been obtain before, the
                % last question of the current module is the copy of the
                % indifferent choice question. We should do nothing.
                end
                
            % Otherwise, the index points at the last question in the
            % current module, we can only update the question with this
            % final response.
            else
                % Update the information further in the ResultArray
                    % If none indifference has been obtained before, just store the
                    % updated question in the second last column within the 
                    % ResultArray.
                    if RecycNum < 1
                        ResultArray{RowIndx_AvaSet, end-1} = Ques_Next;
                        
                       % If the caseID is 1, then also let the AvaSet{2,1} to
                       % be the next generation of W type. This is because 
                       % the eliciation of Case 2 depends on the indifferent 
                       % situation.
                       if CaseID == 1
                        % Evolve the question of W type to the next generation
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

                        % Construct the questoin structure for the new generation
                        % and store in the same location in the available set.
                        AvaSet{2,1} = struct(f1,[C_A,C_B_Nxt,C_AA_Nxt,Prob],...
                                    f2,Iter_New,f3,TypeID, f4, Gen_Nxt,...
                                    f5, CaseID, f6, InitialChoice, f7, CountDiff,...
                                    f8, InitCalcPadCharac,...
                                    f9, InitCost, f10, InitDT, ...
                                    f11, InGroupIndx, f12, RecycNum_New); 
                       end
                       
                    % Otherwise, indifference must be obtained at least once, but
                    % the user dose not confirm this indifference. We just
                    % store the latest updated question in the last column 
                    % within the ResultArray.
                    else
                        ResultArray{RowIndx_AvaSet, end} = Ques_Next;

                    end
            
            % The end of "Further if the index does not point at the last two questions"    
            end

        % End of "If the respose is close to indifferent attitude "
        end
 
    % End of the second for loop    
    end
    
% If the CloseRequest is placed by the user, break the while loop.
    if strcmpi(CloseRequest,'on')
        % break the while loop
        break;
    end    

 % Inform the user the end of the module.
  Finish(1, RowIndx_AvaSet);
  
% End of the first for loop
end

% Save the results.
save(...
    ['ParticipantsRegretData/' ParticipantID '_' TestNumber...
                                                                 '.mat'],...
     'ResultArray', 'AvaSet', 'MoneyScale');

 % If the CloseRequest is placed by the user, display the error message
if strcmpi(CloseRequest,'on')
    error('The program is force to close.');
end
