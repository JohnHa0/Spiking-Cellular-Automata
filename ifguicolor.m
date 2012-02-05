function varargout = ifgui(varargin)
% IFGUI MATLAB code for ifgui.fig
%      IFGUI, by itself, creates a new IFGUI or raises the existing
%      singleton*.
%
%      H = IFGUI returns the handle to a new IFGUI or the handle to
%      the existing singleton*.
%
%      IFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IFGUI.M with the given input arguments.
%
%      IFGUI('Property','Value',...) creates a new IFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ifgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ifgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ifgui

% Last Modified by GUIDE v2.5 05-Feb-2012 11:55:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ifgui_OpeningFcn, ...
                   'gui_OutputFcn',  @ifgui_OutputFcn, ...
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


function ifgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ifgui (see VARARGIN)

% Choose default command line output for ifgui
handles.output = hObject;

%% initialization
handles.M = 100;                            %size of grid
handles.vis_grid = zeros(100);
handles.Weight = 14;                        %weight. The rate is 0.02388
handles.Range = 1;
handles.Tau = 10;

handles.theta = -55;                        %firing threshold
handles.dt = 0.1;                           %integration time step


% Update handles structure
guidata(hObject, handles);
plot_grid(handles);

% UIWAIT makes ifgui wait for user response (see UIRESUME)
% uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = ifgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startbutton

%%

   n = [handles.M 1: handles.M - 1];
   e = [2: handles.M 1];
   s = [2: handles.M 1];
   w = [handles.M 1: handles.M - 1];
   
   %here has a bug when stop and then start again
   X = (handles.vis_grid ~= 0) .* (-55) + (handles.vis_grid == 0) .* (-65);
   % set the unfired neuron to -65
   
   spike = handles.vis_grid;
   El = -65 .* ones(handles.M, handles.M);
   guidata(hObject, handles);

while get(hObject, 'Value')
    
      set(hObject, 'String', 'STOP');
       
      % how many of eight neighbors are fired.
      spike = spike(n,:) + spike(s,:) + spike(:,e) + spike(:,w) + ...
         spike(n,e) + spike(n,w) + spike(s,e) + spike(s,w);
      
      % the fire neuron will generat 80mV current.
      % the NO. of neurons can be stable when the current value is around 150
      
      
      RI_ext = spike .* (12 * handles.Weight);
   
      X = X - ((handles.dt/handles.Tau) .* ones(handles.M, handles.M)) .* ((X - El) - RI_ext);   % if equation
      
      temp1 = X > -55;
      
      X = ~temp1 .* X + temp1 .* -65; % reset 
      
      spike = temp1;    % reset the spike NO. so that spike can indicate which neuron is fired
      
      handles.vis_grid = spike;
      
      plot_grid(handles);
      guidata(hObject, handles);
  
  if (get(hObject, 'Value') == 0) | (handles.vis_grid == 0)
      set(hObject, 'String', 'START');
      break;
  end
end

plot_grid(handles);
guidata(hObject, handles);


% --- Executes on button press in clearutton.
function clearutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%

handles.vis_grid = zeros(handles.M, handles.M);
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in drawbutton.
function drawbutton_Callback(hObject, eventdata, handles)
% hObject    handle to drawbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%

while 1
    set(handles.drawtext, 'Visible', 'on');
    x = 1;
    [y,x] = ginput(1);
    if ~isempty(x)
        x = round(x);
        y = round(y);
        if (x>0)&&(x<handles.M+1)&&(y>0)&&(y<handles.M+1)
            handles.vis_grid(x,y) = ~(handles.vis_grid(x,y));
            guidata(hObject, handles);
            plot_grid(handles);
        end
    else
        set(handles.drawtext, 'Visible', 'off');
        break
    end
end %while


% --- Executes on button press in exitbutton.
function exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
delete(handles.figure);

function weightedit_Callback(hObject, eventdata, handles)
% hObject    handle to weightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weightedit as text
%        str2double(get(hObject,'String')) returns contents of weightedit as a double


% --- Executes during object creation, after setting all properties.
function weightedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeedit as text
%        str2double(get(hObject,'String')) returns contents of sizeedit as a double


% --- Executes during object creation, after setting all properties.
function sizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rangeedit_Callback(hObject, eventdata, handles)
% hObject    handle to rangeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rangeedit as text
%        str2double(get(hObject,'String')) returns contents of rangeedit as a double


% --- Executes during object creation, after setting all properties.
function rangeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tauedit_Callback(hObject, eventdata, handles)
% hObject    handle to tauedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tauedit as text
%        str2double(get(hObject,'String')) returns contents of tauedit as a double


% --- Executes during object creation, after setting all properties.
function tauedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function weightslider_Callback(hObject, eventdata, handles)
% hObject    handle to weightslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%%
handles.Weight = round(get(hObject, 'Value'));

set(handles.weightedit, 'String', num2str(handles.Weight));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function weightslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sizeslider_Callback(hObject, eventdata, handles)
% hObject    handle to sizeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%%

m = round(get(hObject,'Value'));

if m > handles.M
    handles.vis_grid(m, m) = 0;
elseif m < handles.M
    handles.vis_grid(m + 1: end,:) = [];
    handles.vis_grid(: , m + 1: end) = [];
end

handles.M = m;
set(handles.sizeedit, 'String', num2str(handles.M));
guidata(hObject, handles);
plot_grid(handles);


% --- Executes during object creation, after setting all properties.
function sizeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function rangeslider_Callback(hObject, eventdata, handles)
% hObject    handle to rangeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%%
handles.Range = round(get(hObject, 'Value'));

set(handles.rangeedit, 'String', num2str(handles.Range));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rangeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tauslider_Callback(hObject, eventdata, handles)
% hObject    handle to tauslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%%
handles.Tau = round(get(hObject, 'Value'));

set(handles.tauedit, 'String', num2str(handles.Tau));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tauslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in linebutton.
function linebutton_Callback(hObject, eventdata, handles)
% hObject    handle to linebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linebutton

if get(hObject,'Value') == 1
    axis on;
else
    axis off;
end
guidata(hObject, handles);


%%plot grid ////////////////////need to be fixed
function []=plot_grid(handles)
M = handles.M;
axes(handles.axes1);
imagesc(-handles.vis_grid);

if all(handles.vis_grid)
    colormap ([0 0 0]);
else
    colormap gray(2);
end
set(gca,'xtick',[1:M] -.5 ,'ytick',[1:M]-.5,'yticklabel',[],'xticklabel',[],'xcolor',[.7 .7 .7],'ycolor',[.7 .7 .7],'GridLineStyle','-');
grid on;
if get(handles.linebutton,'Value') == 1
    axis on;
else
    axis off;
end
