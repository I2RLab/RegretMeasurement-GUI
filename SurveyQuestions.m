function varargout = SurveyQuestions(varargin)
% SURVEYQUESTIONS MATLAB code for SurveyQuestions.fig
%      SURVEYQUESTIONS, by itself, creates a new SURVEYQUESTIONS or raises the existing
%      singleton*.
%
%      H = SURVEYQUESTIONS returns the handle to a new SURVEYQUESTIONS or the handle to
%      the existing singleton*.
%
%      SURVEYQUESTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURVEYQUESTIONS.M with the given input arguments.
%
%      SURVEYQUESTIONS('Property','Value',...) creates a new SURVEYQUESTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SurveyQuestions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SurveyQuestions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SurveyQuestions

% Last Modified by GUIDE v2.5 13-Dec-2017 09:51:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SurveyQuestions_OpeningFcn, ...
                   'gui_OutputFcn',  @SurveyQuestions_OutputFcn, ...
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


% --- Executes just before SurveyQuestions is made visible.
function SurveyQuestions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SurveyQuestions (see VARARGIN)

% Choose default command line output for SurveyQuestions
handles.output = hObject;

% Get the case number from the input
CaseID = varargin{1};

% We will only have two survey questions.
switch CaseID
    % If it is inital page., set up the question.
    case 0
        set(handles.PushButton, 'String', 'Next');
    % If it is the first question, set up the question.
    case 1
        QuesStatemnt = ['When tossing a fair coin 5 times successively, '...
                        'if results of the first 4 toss are all heads, '...
                        'what will be the result of the 5th toss? '...
                        'How likely this result will happen? '...
                         char(10) ...                      
                        'Tell your answer to the experimenter.'];
        set(handles.TxtQuestionSpace, 'String', QuesStatemnt);
        set(handles.PushButton, 'String', 'Next');
    % If it is the second question, set up the question.
    case 2
        QuesStatemnt = ['A random event has two outcomes: '...
                        '50% chance to lose $100 or 50% chance to lose $0. '...
                        'The expected value of this event is thus losing $50. '...
                        'What will be the real results of this event if it happened?  '...
                        '$100, $0 or $50? '...
                        char(10) ...
                        'Tell your answer to the experimenter.'];
        set(handles.TxtQuestionSpace, 'String', QuesStatemnt);
        set(handles.PushButton, 'String', 'Finish');
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SurveyQuestions wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SurveyQuestions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Delete the figure.
delete(hObject);

% --- Executes on button press in PushButton.
function PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
