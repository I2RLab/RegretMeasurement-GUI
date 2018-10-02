function varargout = Separator(varargin)
% FINISH MATLAB code for Finish.fig
%      FINISH, by itself, creates a new FINISH or raises the existing
%      singleton*.
%
%      H = FINISH returns the handle to a new FINISH or the handle to
%      the existing singleton*.
%
%      FINISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINISH.M with the given input arguments.
%
%      FINISH('Property','Value',...) creates a new FINISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Finish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Finish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Finish

% Last Modified by GUIDE v2.5 10-Nov-2017 13:18:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Separator_OpeningFcn, ...
                   'gui_OutputFcn',  @Separator_OutputFcn, ...
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


% --- Executes just before Finish is made visible.
function Separator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Seperator(see VARARGIN)

% Choose default command line output for Separator
handles.output = hObject;

% Get the money amount
MoneyAmount = varargin{1};

% Get the case number: 1. Begin, 2. Start Over
CaseNumber = varargin{2};

switch CaseNumber
    case 1
        set(handles.TxtTitle, 'String', 'Begin');
    case 2
        set(handles.TxtTitle, 'String', 'Start Over');
end

% Display white noise
WhiteImage = ones(730, 1300);

WhiteNoise = imnoise(WhiteImage, 'gaussian',0,1);
imshow(WhiteNoise, 'Parent', handles.WhiteNoiseAxis);

% Decide what is the money amount.
switch MoneyAmount
    case 10
        % Display $10 bill
        DollarIm = imread('Dollar10.jpg');
        
    case 100
        % Display $100 bill
        DollarIm = imread('Dollar100.png');

    case 1000
        % Display $1000 bills
        DollarIm = imread('Dollar1000.png');
    otherwise
       % Display $10000 bills
        DollarIm = imread('Dollar10000.jpg');  
        
end
imshow(DollarIm, 'Parent', handles.DollarAxis);

% Play white noise audio
NoiseAudio = 0.2*rand(8192*2,1);
sound(NoiseAudio, 8192*2);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Finish wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Separator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Pause a little bit and delete the window
pause(0.8);
delete(hObject);
