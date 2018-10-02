function varargout = RobotHumanCollabScenario(varargin)
% ROBOTHUMANCOLLABSCENARIO MATLAB code for RobotHumanCollabScenario.fig
%      ROBOTHUMANCOLLABSCENARIO, by itself, creates a new ROBOTHUMANCOLLABSCENARIO or raises the existing
%      singleton*.
%
%      H = ROBOTHUMANCOLLABSCENARIO returns the handle to a new ROBOTHUMANCOLLABSCENARIO or the handle to
%      the existing singleton*.
%
%      ROBOTHUMANCOLLABSCENARIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTHUMANCOLLABSCENARIO.M with the given input arguments.
%
%      ROBOTHUMANCOLLABSCENARIO('Property','Value',...) creates a new ROBOTHUMANCOLLABSCENARIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotHumanCollabScenario_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotHumanCollabScenario_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotHumanCollabScenario

% Last Modified by GUIDE v2.5 13-Dec-2017 08:54:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RobotHumanCollabScenario_OpeningFcn, ...
                   'gui_OutputFcn',  @RobotHumanCollabScenario_OutputFcn, ...
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


% --- Executes just before RobotHumanCollabScenario is made visible.
function RobotHumanCollabScenario_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotHumanCollabScenario (see VARARGIN)

% Choose default command line output for RobotHumanCollabScenario
handles.output = hObject;

MoneyAmount = varargin{1};

% Decide what is the money amount.
switch MoneyAmount
    case 10
        % Display $10 bill
        DollarIm1 = imread('Dollar10.jpg');
        DollarIm2 = imread('Dollar1.jpg');
        
    case 100
        % Display $100 bill
        DollarIm1 = imread('Dollar100.png');
        DollarIm2 = imread('Dollar10.jpg');
        
    case 1000
        % Display $1000 bills
        DollarIm1 = imread('Dollar1000.png');
        DollarIm2 = imread('Dollar100.png');
        
    otherwise
       % Display $10000 bills
        DollarIm1 = imread('Dollar10000.jpg');  
        DollarIm2 = imread('Dollar1000.png');
        
end

% Show the dollar image in the axes. 
imshow(DollarIm1, 'Parent', handles.Axe_Dollar1);
imshow(DollarIm2, 'Parent', handles.Axe_Dollar2);

% Show the numerical amount of money
set(handles.TxtMoneyAmount1_1, 'String', ['$' num2str(MoneyAmount)]);
set(handles.TxtMoneyAmount1_2, 'String', ['$' num2str(MoneyAmount)]);
set(handles.TxtMoneyAmount2, 'String', ['$' num2str(MoneyAmount/10)]);
set(handles.TxtRobotWrngOutcome, 'String', ['$' num2str(-MoneyAmount)]);
set(handles.TxtHumanCrctOutcome, 'String', ['$' num2str(-MoneyAmount/10)]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotHumanCollabScenario wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RobotHumanCollabScenario_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% delete the figure
delete(hObject);

% --- Executes on button press in PushButtonNext.
function PushButtonNext_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
