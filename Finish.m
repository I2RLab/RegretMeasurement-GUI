function varargout = Finish(varargin)
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

% Last Modified by GUIDE v2.5 28-Nov-2017 15:11:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Finish_OpeningFcn, ...
                   'gui_OutputFcn',  @Finish_OutputFcn, ...
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
function Finish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Finish (see VARARGIN)

% Choose default command line output for Finish
handles.output = hObject;

WhatToShow = varargin{1};
ModuleNum  = varargin{2};


switch WhatToShow
    case 1
        MainText = ['Congrats! You have finished module ',...
                     num2str(ModuleNum)];
        ButtonLabel = 'Next';        
    case 2
        MainText = 'Well done! You have finished all the modules.';
        ButtonLabel = 'Finish';           
        
end

set(handles.Txt, 'String', MainText);
set(handles.pushbutton1, 'String', ButtonLabel);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Finish wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Finish_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
