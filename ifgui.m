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

% Last Modified by GUIDE v2.5 05-Feb-2012 21:33:02

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


% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu

%%
list=cellstr(get(hObject,'String'));
pattrn=0;
switch list{get(hObject,'value')}
    case 'Random'
        qst=questdlg('What density do you want?','Random','Low','Mid','High','Low');
        switch qst
            case 'Low'
                d=.75;
            case 'Mid'
                d=.5;
            case 'High'
                d=.25;
        end %switch qst
        handles.vis_grid=rand(handles.M)>d;
    case 'Blinker'
        handles.pattern=blinker;
        pattrn=1;
    case 'Toad'
        handles.pattern=toad;
        pattrn=1;
    case 'Beacon'
        handles.pattern=beacon;
        pattrn=1;
    case 'Pulsar'
        handles.pattern=pulsar;
        pattrn=1;
    case 'Lindner''s Oscillator'  %I don't familiar with this oscillator, so I called it by my name... :) 
        handles.pattern=lindners;
        pattrn=1;        
    case 'Glider'
        handles.pattern=glider;
        pattrn=1;
    case 'Lightweight Spaceship'
        handles.pattern=LWSS;
        pattrn=1;
    case 'Coe Ship'
        handles.pattern=coe_ship;
        pattrn=1;
    case 'The Turtle'
        handles.pattern=turtle;
        pattrn=1;
    case 'The Schick Engine'
        handles.pattern=schick;
        pattrn=1;
    case 'Holzwart Ship'
        handles.pattern=holzwart;
        pattrn=1;
    case 'The Weekender'
        handles.pattern=weekender;
        pattrn=1;        
    case 'Hickerson 13491'
        handles.pattern=hickerson13491;
        pattrn=1; 
    case 'Hickerson 13881'
        handles.pattern=hickerson13881;
        pattrn=1;         
    case 'Glider 17361'
        handles.pattern(25:-1:1,25:-1:1)=glider17361;
        pattrn=1;        
    case 'The Spider'
        handles.pattern=spider;
        pattrn=1;
    case 'Glider Gun'
        handles.pattern=zeros(38);
        handles.pattern(16:26,:)=glider_gun;
        pattrn=1;
    case 'Gun Fight 1'
        handles.pattern=zeros(58);
        a=glider_gun;
        handles.pattern(5:15,1:38)=a;
        handles.pattern(44:54,21:58)=a(end:-1:1,end:-1:1);
        pattrn=1;
    case 'Gun Fight 2'
        handles.pattern=zeros(58);
        a=glider_gun;
        handles.pattern(8:18,1:38)=a;
        handles.pattern(41:51,21:58)=a(end:-1:1,end:-1:1);
        pattrn=1;
    case 'Gun Fight 3'
        handles.pattern=zeros(58);
        a=glider_gun;
        handles.pattern(12:22,1:38)=a;
        handles.pattern(37:47,21:58)=a(end:-1:1,end:-1:1);
        pattrn=1;
    case 'Empty Square'
        s=round(str2num(cell2mat(inputdlg('Enter side size','Square'))));
        if isempty(s)|(s<2)|(s>handles.M)
            h=errordlg(['Input must be a number between 2-',num2str(handles.M)],'Error');
            waitfor(h);
        else
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid(1+round((handles.M-s)*.5):end-round((handles.M-s)*.5),1+round((handles.M-s)*.5))=1;
            handles.vis_grid(1+round((handles.M-s)*.5):end-round((handles.M-s)*.5),end-round((handles.M-s)*.5))=1;
            handles.vis_grid(1+round((handles.M-s)*.5),1+round((handles.M-s)*.5):end-round((handles.M-s)*.5))=1;
            handles.vis_grid(end-round((handles.M-s)*.5),1+round((handles.M-s)*.5):end-round((handles.M-s)*.5))=1;
        end
    case 'Full Square'
        s=round(str2num(cell2mat(inputdlg('Enter side size','Square'))));
        if isempty(s)|(s<2)|(s>handles.M)
            h=errordlg(['Input must be a number between 2-',num2str(handles.M)],'Error');
            waitfor(h);
        else
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid(1+round((handles.M-s)*.5):end-round((handles.M-s)*.5),1+round((handles.M-s)*.5):end-round((handles.M-s)*.5))=1;
        end
    case 'Empty Circle'
        s=round(str2num(cell2mat(inputdlg('Enter diameter size','Circle'))));
        if isempty(s)|(s<2)|(s>handles.M)
            h=errordlg(['Input must be a number between 2-',num2str(handles.M)],'Error');
            waitfor(h);
        else
            [x,y]=meshgrid(linspace(-handles.M/2,handles.M/2,handles.M));
            a=sqrt(x.^2+y.^2);
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid( (a<=s/2) & (a>(s/2 -1)) )=1;
        end                
    case 'Full Circle'
        s=round(str2num(cell2mat(inputdlg('Enter diameter size','Circle'))));
        if isempty(s)|(s<2)|(s>handles.M)
            h=errordlg(['Input must be a number between 2-',num2str(handles.M)],'Error');
            waitfor(h);
        else
            [x,y]=meshgrid(linspace(-handles.M/2,handles.M/2,handles.M));
            a=sqrt(x.^2+y.^2);
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid(a<=(1+s/2))=1;
        end        
    case 'Diagonal'
        handles.vis_grid=zeros(handles.M);
        handles.vis_grid(1:4:end,1:4:end)=1;
        handles.vis_grid(2:4:end,2:4:end)=1;
        handles.vis_grid(3:4:end,3:4:end)=1;
        handles.vis_grid(4:4:end,4:4:end)=1;
    case 'Chess board'
        handles.vis_grid=zeros(handles.M);
        handles.vis_grid(1:2:end,1:2:end)=1;
        handles.vis_grid(2:2:end,2:2:end)=1;
    case '+ shape'
        handles.vis_grid=zeros(handles.M);
        handles.vis_grid(:,round(handles.M./2))=1;
        handles.vis_grid(round(handles.M./2),:)=1;
    case '# shape'
        handles.vis_grid=zeros(handles.M);
        handles.vis_grid(:,[ceil(handles.M./3),ceil(2*handles.M./3)])=1;
        handles.vis_grid([ceil(handles.M./3),ceil(2*handles.M./3)],:)=1;
    case 'X shape'
        handles.vis_grid=eye(handles.M);
        handles.vis_grid=(handles.vis_grid+handles.vis_grid(:,end:-1:1))>0;
end
if pattrn
    handles=creat_pattern(handles);
end
guidata(hObject, handles);
plot_grid(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function [handles] = calc_game(handles)
sum_grid=zeros(handles.M+4);
bounded_grid=zeros(handles.M+6);
bounded_grid(2:end-1,2:end-1)=handles.calc_grid;
for k=-1:1
    for l=-1:1
        if ~((k==0)&(l==0))
            sum_grid=sum_grid+bounded_grid(2+k:end-1+k,2+l:end-1+l);
        end %if
    end % for l
end %for k
next_grid=zeros(handles.M+4);
next_grid((sum_grid==2)&(handles.calc_grid==1))=1;
next_grid(sum_grid==3)=1;
handles.calc_grid=next_grid;


function [a]=blinker();
a=zeros(5);
a(3,2:4)=1;

function [a]=toad();
a=zeros(6);
a(3,2:4)=1;
a(4,3:5)=1;

function [a]= beacon();
a=zeros(6);
a(2:3,2:3)=1;
a(4:5,4:5)=1;

function [a]= pulsar();
a=zeros(17);
a([5:7,11:13],[3,8,10,15])=1;
a([3,8,10,15],[5:7,11:13])=1;

function [a]=glider();
a=zeros(5);
a(2,3)=1;
a(3,4)=1;
a(4,2:4)=1;

function [a]=LWSS();
a=zeros(7);
a(2,3:4)=1;
a(3,2:5)=1;
a(4,[2:3,5:6])=1;
a(5,4:5)=1;

function [a]=coe_ship();
a=zeros(12);
a(10,6:11)=1;
a(9,[4:5,11])=1;
a(8,[2:3,5,11])=1;
a(7,[6,10])=1;
a(6,8)=1;
a(5,[8:9])=1;
a(4,[7:10])=1;
a(3,[7:8,10:11])=1;
a(2,[9:10])=1;

function [a]=turtle();
a=zeros(14);
a([2,11,12],1+[2:3,10:11])=1;
a(3,1+[3:10])=1;
a(5:6, 1+[3,10])=1;
a([7,12],1+[5,8])=1;
a(8,1+[3:4,6:7,9:10])=1;
a(9,1+[4:5,8:9])=1;
a(10,1+[2,4,9,11])=1;
a(13,1+[6:7])=1;

function [a]=schick();
a=zeros(17);
a([13:16],3+[2,10])=1;
a([16,12],3+[3,9])=1;
a([16,8],3+[4,8])=1;
a([3:9,12,15],3+[5,7])=1;
a([2,5:7,9:10],3+6)=1;

function [a]=holzwart();
a=zeros(13);
a([2,12],1+[5,7:8])=1;
a([3,11],1+[3,9])=1;
a([4,10],1+[6:7,9:10])=1;
a([5,9],1+[2:5,7:9])=1;
a([6,8],1+8)=1;

function [a]= glider_gun();
a=zeros(11,38);
a([6:7],[2:3])=1;
a([4:5],[36:37])=1;
a([6:8],[12,18])=1;
a([5,9],[13,17])=1;
a([4,10],[14:15])=1;
a([7],[16,19])=1;
a([4:6],[22:23])=1;
a([3,7],[24])=1;
a([2:3,7:8],[26])=1;

function [a]=weekender()
a=zeros(18);
a(5:7,[7,12])=1;
a(8,5:14)=1;
a(9,[4,6,13,15])=1;
a(10,[8,11])=1;
a(11,[3:4,9:10,15:16])=1;
a([12,14],[2:4,15:17])=1;
a(13,[2,4,15,17])=1;

function [a]=hickerson13491();
a=zeros(17);
a(2+4,2)=1;
a(2+[2:4,7:9],3)=1;
a(2+7,4)=1;
a(2+[6,10:11],5)=1;
a(2+[2:4,6:8,11],6)=1;
a(2+[2:7,9:11],7)=1;
a(2+[3:5],8)=1;
a(:,[17:-1:10])=a(:,1:8);

function [a]=hickerson13881();
a=zeros(18);
a(7,[15:16])=1;
a(8,[3,4,8,12,17])=1;
a(9,[2,9:10,13:16])=1;
a(10,[3:5,7:8,10,12:13])=1;
a(11,[7,9:10])=1;

function [a]=glider17361();
a=zeros(25);
a(2,[12:13])=1;
a(3,[11,14])=1;
a(4,[11,13])=1;
a(5,11)=1;
a(6,[12:13,15])=1;
a(7,[15:16,18])=1;
a(8,[13,16,19,21])=1;
a(9,[15:16,18:19,22])=1;
a(10,[13,17:19,22])=1;
a(11,[13,18])=1;
a(12,[15,19])=1;
a(13,16)=1;
a(14,[15,18:22])=1;
a(15,22)=1;
a(16,[20,23:24])=1;
a(18,[20:22])=1;
a=a+a';

function [a]=spider();
a=zeros(29);
a([3:4],[3:4])=1;
a([3,5:8],6)=1;
a(6,2)=1;
a(7,[2:4,8:10])=1;
a(8,[5,8,10,12:13])=1;
a(9,11)=1;
a([2,3,5],7)=1;
a(6,8)=1;
a([4:6],14)=1;
a(:,29:-1:16)=a(:,1:14);

function [a]=lindners();
a=zeros(18);
a(9,[2:4,7:12,15:17])=1;
a([8,10],[4,7,12,15])=1;

function [handles]=creat_pattern(handles);
p_l=length(handles.pattern);
if p_l > handles.M
    pat_name=cellstr(get(handles.popupmenu1,'String'));
    h=warndlg({'The grid size will be enlarged';['in order to fit to "',pat_name{get(handles.popupmenu1,'value')},'".']},'Grid size');
    waitfor(h);
    handles.M=p_l;
    set(handles.M_size,'value',handles.M);
    set(handles.sizeedit,'string',num2str(handles.M));
    handles.vis_grid=handles.pattern;
elseif (p_l<=handles.M)&(p_l>(.5*handles.M))
    a=floor(1+.5*(handles.M - p_l));
    handles.vis_grid=zeros(handles.M);
    handles.vis_grid( a:a+p_l-1 , a:a+p_l-1 )=handles.pattern;
else
    lst_str={' one, in the corner',' one, in the center',' high period covered, same direction',' high period covered, random direction',' low period covered, same direction',' low period covered, random direction'};
    [quest_lst,]=listdlg('ListString',lst_str,'ListSize',[230 85],'PromptString','How do you wish to organize the pattern?','SelectionMode','Single');
    quest=lst_str{quest_lst};
    switch quest
        case ' one, in the corner'
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid( 1:p_l,1:p_l )=handles.pattern;
        case ' one, in the center'
            a=floor(1+.5*(handles.M-p_l));
            handles.vis_grid=zeros(handles.M);
            handles.vis_grid( a:a+p_l-1 , a:a+p_l-1 )=handles.pattern;
        case ' high period covered, same direction'
            handles.vis_grid=zeros(handles.M);
            for k=0:floor(handles.M/p_l)-1
                for l=0:floor(handles.M/p_l)-1
                    handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=handles.pattern;
                end %l
            end %k
        case ' high period covered, random direction'
            handles.vis_grid=zeros(handles.M);
            for k=0:floor(handles.M/p_l)-1
                for l=0:floor(handles.M/p_l)-1
                    if rand>.5
                        o1=1:p_l;
                    else
                        o1=p_l:-1:1;
                    end %if rand
                    if rand>.5
                        o2=1:p_l;
                    else
                        o2=p_l:-1:1;
                    end %if rand
                    if rand>.5
                        pt=handles.pattern;
                    else
                        pt=handles.pattern';
                    end %if rand
                    handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=pt(o1,o2);
                end %l
            end %k
        case ' low period covered, same direction'
            handles.vis_grid=zeros(handles.M);
            for k=0:floor(handles.M/p_l)-1
                for l=0:floor(handles.M/p_l)-1
                    if ((k/2)==floor(k/2))&&((l/2)==floor(l/2))
                        handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=handles.pattern;
                    end %if
                end %l
            end %k
        case ' low period covered, random direction'
            handles.vis_grid=zeros(handles.M);
            handles.pattern(2*handles.M,2*handles.M)=0;
            for k=0:floor(handles.M/p_l)-1
                for l=0:floor(handles.M/p_l)-1
                    if ((k/2)==floor(k/2))&&((l/2)==floor(l/2))
                        if rand>.5
                            o1=1:p_l;
                        else
                            o1=p_l:-1:1;
                        end %if rand
                        if rand>.5
                            o2=1:p_l;
                        else
                            o2=p_l:-1:1;
                        end %if rand
                        if rand>.5
                            pt=handles.pattern;
                        else
                            pt=handles.pattern';
                        end %if rand
                        handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=pt(o1,o2);
                    end %if ((k/2)==floor(k/2))&((l/2)==floor(l/2))
                end %l
            end %k
    end %switch
end %if