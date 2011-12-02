% Moshe Lindner
function varargout = game_of_life(varargin)
% GAME_OF_LIFE M-file for game_of_life.fig
%      GAME_OF_LIFE, by itself, creates a new GAME_OF_LIFE or raises the existing
%      singleton*.
%
%      H = GAME_OF_LIFE returns the handle to a new GAME_OF_LIFE or the handle to
%      the existing singleton*.
%
%      GAME_OF_LIFE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAME_OF_LIFE.M with the given input arguments.
%
%      GAME_OF_LIFE('Property','Value',...) creates a new GAME_OF_LIFE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before game_of_life_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to game_of_life_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help game_of_life

% Last Modified by GUIDE v2.5 24-Feb-2010 18:52:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @game_of_life_OpeningFcn, ...
    'gui_OutputFcn',  @game_of_life_OutputFcn, ...
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


% --- Executes just before game_of_life is made visible.
function game_of_life_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to game_of_life (see VARARGIN)

% Choose default command line output for game_of_life
set(gcf,'name','Conway''s Game Of Life');
handles.output = hObject;
handles.iter_num=100;
handles.iter_step=1;
handles.N=30;
handles.vis_grid=zeros(30);
handles.vis_grid(1:14,9:22)=turtle;
handles.reset_grid=handles.vis_grid;
handles.vid=0;
% Update handles structure
guidata(hObject, handles);
plot_grid(handles);
% UIWAIT makes game_of_life wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = game_of_life_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function load_mat_Callback(hObject, eventdata, handles)
% hObject    handle to load_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Load');
if strcmpi('mat',FileName(end-2:end))
    try
        a=importdata([PathName,FileName]);
        size_a=size(a);
        if (length(size(a))~=2) | (size_a(1)~=size_a(2))
            errordlg('The matrix is not of the proper dimensions.','Error');
        elseif size_a(1)<5
            errordlg('The matrix is too small.','Error');
        elseif size_a(1)>500
            errordlg('The matrix is too big.','Error');
        elseif a~=logical(a)
            errordlg('Not all values in the matrix are ''0'' or ''1''. ','Error');
        else
            handles.vis_grid=a;
            set(handles.N_size,'value',size_a(1));
            set(handles.grid_size_N,'string',num2str(size_a(1)));
            handles.N=size_a(1);
            guidata(hObject, handles);
            plot_grid(handles);
        end
    catch
        errordlg('The file cannot be loaded','Error');
    end % try-catch
else % if f_type
    errordlg('The program can only load MATLAB mat-files.','Error');
end %if f_type
% --------------------------------------------------------------------
function save_mat_Callback(hObject, eventdata, handles)
% hObject    handle to save_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.mat','Save');
a=handles.vis_grid;
save([PathName,FileName], 'a') ;
% --------------------------------------------------------------------
function save_pic_Callback(hObject, eventdata, handles)
% hObject    handle to save_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
types={'*.jpg';'*.tif';'*.bmp';'*.png'};
[FileName,PathName,file_type] = uiputfile(types,'Save As Image');
frm=getframe(handles.axes1);
[im,map] = frame2im(frm);
imwrite(im,[PathName,FileName],types{file_type}(3:5));
% --------------------------------------------------------------------
function save_video_Callback(hObject, eventdata, handles)
% hObject    handle to save_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.avi','Save As Video');
handles.vid_name=[PathName,FileName];
handles.vid=1;
guidata(hObject, handles);
% --------------------------------------------------------------------
function close_fig_Callback(hObject, eventdata, handles)
% hObject    handle to close_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function user_manual_Callback(hObject, eventdata, handles)
% hObject    handle to user_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('\game_of_life_manual.htm')
% --------------------------------------------------------------------
function help_about_Callback(hObject, eventdata, handles)
% hObject    handle to help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about={'Conway''s Game Of Life is a cellular automaton with the rule B3/S23:';...
    '';...
    '    1. Any live cell with fewer than two live neighbors dies, as if caused by under-population.';...
    '    2. Any live cell with more than three live neighbors dies, as if by overcrowding.';...
    '    3. Any live cell with two or three live neighbors lives on to the next generation.';...
    '    4. Any dead cell with exactly three live neighbors becomes a live cell.';...
    '';...
    'The game is a zero-player game, and its evolution determine only by the initial state.';...
    '';...
    'This program written using MATLAB version R2009a.';...
    '';...
    'Moshe Lindner, February 2010 (c)';...
    };

about_msg=msgbox('','About');
set(about_msg,'position',[345, 417, 330,150]);
ah = get( about_msg, 'CurrentAxes' );
ch = get( ah, 'Children' );
set(ch,'string',about) 

% --- Executes on slider movement.
function N_size_Callback(hObject, eventdata, handles)
% hObject    handle to N_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=round(get(hObject,'Value') );
if n>handles.N
    handles.vis_grid(n,n)=0;
elseif n<handles.N
    handles.vis_grid(n+1:end,:)=[];
    handles.vis_grid(:,n+1:end)=[];
end
handles.N= n;
set(handles.grid_size_N,'string',num2str(handles.N));
guidata(hObject, handles);
plot_grid(handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function N_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in grid_lines.
function grid_lines_Callback(hObject, eventdata, handles)
% hObject    handle to grid_lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grid_lines
if get(hObject,'Value')==1
    axis on
else
    axis off
end
guidata(hObject, handles);

% --- Executes on button press in decrease_iterations.
function decrease_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to decrease_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iter_num=handles.iter_num -  handles.iter_step;
if handles.iter_num<1
    handles.iter_num=1;
end
set(handles.iterations_str,'string',num2str(handles.iter_num));
guidata(hObject, handles);

% --- Executes on button press in increase_iterations.
function increase_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to increase_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iter_num=handles.iter_num +  handles.iter_step;
set(handles.iterations_str,'string',num2str(handles.iter_num));
guidata(hObject, handles);

% --- Executes on button press in inf_loop.
function inf_loop_Callback(hObject, eventdata, handles)
% hObject    handle to inf_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of inf_loop
switch get(hObject,'Value')
    case 1
        handles.iter_num=inf;
        button_enable(handles,'off','INF');
    case 0
        button_enable(handles,'on','INF');
        handles.iter_num=str2num(get(handles.iterations_str,'string'));
end;
guidata(hObject, handles);

% --- Executes when selected object is changed in iterations_num.
function iterations_num_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in iterations_num
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'units'
        handles.iter_step=1;
    case 'tens'
        handles.iter_step=10;
    case 'hundreds'
        handles.iter_step=100;
end
guidata(hObject, handles);

function grid_size_N_Callback(hObject, eventdata, handles)
% hObject    handle to grid_size_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grid_size_N as text
%        str2double(get(hObject,'String')) returns contents of grid_size_N as a double
if (str2num(get(hObject,'string'))>=5)&(str2num(get(hObject,'string'))<=500)
    n=round(str2num(get(hObject,'string')));
    if n>handles.N
        handles.vis_grid(n,n)=0;
    elseif n<handles.N
        handles.vis_grid(n+1:end,:)=[];
        handles.vis_grid(:,n+1:end)=[];
    end
    handles.N= n;
    set(handles.N_size,'value',round(str2num(get(hObject,'string'))));
else
    errordlg('Input must be number between 5 and 500','Wrong Input');
end
set(handles.grid_size_N,'string',num2str(handles.N));
guidata(hObject, handles);
plot_grid(handles)

function iterations_str_Callback(hObject, eventdata, handles)
% hObject    handle to iterations_str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations_str as text
%        str2double(get(hObject,'String')) returns contents of iterations_str as a double
if (str2num(get(hObject,'string'))>=1)
    handles.iter_num=round(str2num(get(hObject,'string')));
else
    errordlg('Input must be number larger than 1','Wrong Input');
end
set(handles.iterations_str,'string',num2str(handles.iter_num));
guidata(hObject, handles);

% --- Executes on button press in start_stop.
function start_stop_Callback(hObject, eventdata, handles)
% hObject    handle to start_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of start_stop
vid='';
if get(hObject,'Value')==1
    if handles.vid==1
        handles.vid=0;
        vid=questdlg({'The animation will be saved to a video file:';handles.vid_name},'Video','OK','Cancel','OK');
        if strcmp(vid,'OK')
            aviobj = avifile(handles.vid_name,'compression','Cinepak','fps',get(handles.speed_slider,'value'));
            set(handles.vid_str,'visible','on');
        end
    end
    set(hObject,'string','Stop');
end
handles.calc_grid=zeros(handles.N+4);
handles.calc_grid(3:end-2,3:end-2)=handles.vis_grid;
handles.reset_grid=handles.vis_grid;
button_enable(handles,'off','START_STOP')
i=1;
previous=handles.vis_grid;
while 1% the use in "while" instead of "for" is because 'handles.iter_num' may equal infinity
    handles=calc_game(handles);
    previous=handles.vis_grid;
    handles.vis_grid=handles.calc_grid(3:end-2,3:end-2);
    plot_grid(handles);
    title(['Iteration #',num2str(i)]);     
    pause(1/get(handles.speed_slider,'value'))    
    if (get(hObject,'Value')==0) | (i>=handles.iter_num) | (previous==handles.vis_grid)
        if (previous==handles.vis_grid)
            h=warndlg('Running has stopped  because the grid is in steady state.','Steady State');
            waitfor(h);
        end
        break
    end
    guidata(hObject, handles);
    if strcmp(vid,'OK')
        frame = getframe(handles.axes1);
        aviobj = addframe(aviobj,frame);
    end
    i=i+1;
end
plot_grid(handles);
title('');
if strcmp(vid,'OK')
    aviobj = close(aviobj);
    set(handles.vid_str,'visible','off');
end
button_enable(handles,'on','START_STOP')
if  get(handles.inf_loop,'value')==1
    button_enable(handles,'off','INF');
end
set(hObject,'string','Start','value',0);
guidata(hObject, handles);

% --- Executes on slider movement.
function speed_slider_Callback(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
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
        handles.vis_grid=rand(handles.N)>d;
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
        if isempty(s)|(s<2)|(s>handles.N)
            h=errordlg(['Input must be a number between 2-',num2str(handles.N)],'Error');
            waitfor(h);
        else
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid(1+round((handles.N-s)*.5):end-round((handles.N-s)*.5),1+round((handles.N-s)*.5))=1;
            handles.vis_grid(1+round((handles.N-s)*.5):end-round((handles.N-s)*.5),end-round((handles.N-s)*.5))=1;
            handles.vis_grid(1+round((handles.N-s)*.5),1+round((handles.N-s)*.5):end-round((handles.N-s)*.5))=1;
            handles.vis_grid(end-round((handles.N-s)*.5),1+round((handles.N-s)*.5):end-round((handles.N-s)*.5))=1;
        end
    case 'Full Square'
        s=round(str2num(cell2mat(inputdlg('Enter side size','Square'))));
        if isempty(s)|(s<2)|(s>handles.N)
            h=errordlg(['Input must be a number between 2-',num2str(handles.N)],'Error');
            waitfor(h);
        else
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid(1+round((handles.N-s)*.5):end-round((handles.N-s)*.5),1+round((handles.N-s)*.5):end-round((handles.N-s)*.5))=1;
        end
    case 'Empty Circle'
        s=round(str2num(cell2mat(inputdlg('Enter diameter size','Circle'))));
        if isempty(s)|(s<2)|(s>handles.N)
            h=errordlg(['Input must be a number between 2-',num2str(handles.N)],'Error');
            waitfor(h);
        else
            [x,y]=meshgrid(linspace(-handles.N/2,handles.N/2,handles.N));
            a=sqrt(x.^2+y.^2);
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid( (a<=s/2) & (a>(s/2 -1)) )=1;
        end                
    case 'Full Circle'
        s=round(str2num(cell2mat(inputdlg('Enter diameter size','Circle'))));
        if isempty(s)|(s<2)|(s>handles.N)
            h=errordlg(['Input must be a number between 2-',num2str(handles.N)],'Error');
            waitfor(h);
        else
            [x,y]=meshgrid(linspace(-handles.N/2,handles.N/2,handles.N));
            a=sqrt(x.^2+y.^2);
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid(a<=(1+s/2))=1;
        end        
    case 'Diagonal'
        handles.vis_grid=zeros(handles.N);
        handles.vis_grid(1:4:end,1:4:end)=1;
        handles.vis_grid(2:4:end,2:4:end)=1;
        handles.vis_grid(3:4:end,3:4:end)=1;
        handles.vis_grid(4:4:end,4:4:end)=1;
    case 'Chess board'
        handles.vis_grid=zeros(handles.N);
        handles.vis_grid(1:2:end,1:2:end)=1;
        handles.vis_grid(2:2:end,2:2:end)=1;
    case '+ shape'
        handles.vis_grid=zeros(handles.N);
        handles.vis_grid(:,round(handles.N./2))=1;
        handles.vis_grid(round(handles.N./2),:)=1;
    case '# shape'
        handles.vis_grid=zeros(handles.N);
        handles.vis_grid(:,[ceil(handles.N./3),ceil(2*handles.N./3)])=1;
        handles.vis_grid([ceil(handles.N./3),ceil(2*handles.N./3)],:)=1;
    case 'X shape'
        handles.vis_grid=eye(handles.N);
        handles.vis_grid=(handles.vis_grid+handles.vis_grid(:,end:-1:1))>0;
end
if pattrn
    handles=creat_pattern(handles);
end
guidata(hObject, handles);
plot_grid(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in draw_button.
function draw_button_Callback(hObject, eventdata, handles)
% hObject    handle to draw_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reset_grid=handles.vis_grid;
set(handles.draw_mode,'visible','on')
button_enable(handles,'off','DRAW');
while 1
    x=1;
    [y,x]=ginput(1);
    if ~isempty(x)
        x=round(x);
        y=round(y);
        if (x>0)&&(x<handles.N+1)&&(y>0)&&(y<handles.N+1)
            handles.vis_grid(x,y)=~(handles.vis_grid(x,y));
            guidata(hObject, handles);
            plot_grid(handles)
        end
    else
        break
    end
end %while
set(handles.draw_mode,'visible','off')
button_enable(handles,'on','DRAW');
if  get(handles.inf_loop,'value')==1
    button_enable(handles,'off','INF');
end
% Hint: get(hObject,'Value') returns toggle state of draw_button

% --- Executes on button press in clear_grid.
function clear_grid_Callback(hObject, eventdata, handles)
% hObject    handle to clear_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reset_grid=handles.vis_grid;
handles.vis_grid=zeros(size(handles.vis_grid));
guidata(hObject, handles);
plot_grid(handles)

% --- Executes on button press in inverse_grid.
function inverse_grid_Callback(hObject, eventdata, handles)
% hObject    handle to inverse_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid=~handles.vis_grid;
guidata(hObject, handles);
plot_grid(handles)

% --- Executes on button press in reset_gr.
function reset_gr_Callback(hObject, eventdata, handles)
% hObject    handle to reset_gr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if size(handles.vis_grid)~=size(handles.reset_grid)
    set(handles.N_size,'value',size(handles.reset_grid,1));
    set(handles.grid_size_N,'string',num2str(size(handles.reset_grid,1)));
    handles.N=size(handles.reset_grid,1);
end
handles.vis_grid=handles.reset_grid;
guidata(hObject, handles);
plot_grid(handles)

% --- Executes on button press in flip_hor.
function flip_hor_Callback(hObject, eventdata, handles)
% hObject    handle to flip_hor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid=handles.vis_grid(:,end:-1:1);
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in flip_ver.
function flip_ver_Callback(hObject, eventdata, handles)
% hObject    handle to flip_ver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid=handles.vis_grid(end:-1:1,:);
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in trsps.
function trsps_Callback(hObject, eventdata, handles)
% hObject    handle to trsps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid=handles.vis_grid';
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in move_up.
function move_up_Callback(hObject, eventdata, handles)
% hObject    handle to move_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid(1:end-1,:)=handles.vis_grid(2:end,:);
handles.vis_grid(end,:)=0;
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in move_down.
function move_down_Callback(hObject, eventdata, handles)
% hObject    handle to move_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid(2:end,:)=handles.vis_grid(1:end-1,:);
handles.vis_grid(1,:)=0;
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in move_left.
function move_left_Callback(hObject, eventdata, handles)
% hObject    handle to move_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid(:,1:end-1)=handles.vis_grid(:,2:end);
handles.vis_grid(:,end)=0;
guidata(hObject, handles);
plot_grid(handles);

% --- Executes on button press in move_right.
function move_right_Callback(hObject, eventdata, handles)
% hObject    handle to move_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vis_grid(:,2:end)=handles.vis_grid(:,1:end-1);
handles.vis_grid(:,1)=0;
guidata(hObject, handles);
plot_grid(handles);


function [handles]=calc_game(handles)
sum_grid=zeros(handles.N+4);
bounded_grid=zeros(handles.N+6);
bounded_grid(2:end-1,2:end-1)=handles.calc_grid;
for k=-1:1
    for l=-1:1
        if ~((k==0)&(l==0))
            sum_grid=sum_grid+bounded_grid(2+k:end-1+k,2+l:end-1+l);
        end %if
    end % for l
end %for k
next_grid=zeros(handles.N+4);
next_grid((sum_grid==2)&(handles.calc_grid==1))=1;
next_grid(sum_grid==3)=1;
handles.calc_grid=next_grid;

function []=plot_grid(handles)
N=handles.N;
axes(handles.axes1);
imagesc(-handles.vis_grid)
if all(handles.vis_grid)
    colormap ([0 0 0])
else
    colormap gray(2)
end
set(gca,'xtick',[1:N] -.5 ,'ytick',[1:N]-.5,'yticklabel',[],'xticklabel',[],'xcolor',[.7 .7 .7],'ycolor',[.7 .7 .7],'GridLineStyle','-');
grid on
if get(handles.grid_lines,'value')==1
    axis on
else
    axis off
end

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
if p_l>handles.N
    pat_name=cellstr(get(handles.popupmenu1,'String'));
    h=warndlg({'The grid size will be enlarged';['in order to fit to "',pat_name{get(handles.popupmenu1,'value')},'".']},'Grid size');
    waitfor(h);
    handles.N=p_l;
    set(handles.N_size,'value',handles.N);
    set(handles.grid_size_N,'string',num2str(handles.N));
    handles.vis_grid=handles.pattern;
elseif (p_l<=handles.N)&(p_l>(.5*handles.N))
    a=floor(1+.5*(handles.N-p_l));
    handles.vis_grid=zeros(handles.N);
    handles.vis_grid( a:a+p_l-1 , a:a+p_l-1 )=handles.pattern;
else
    lst_str={' one, in the corner',' one, in the center',' high period covered, same direction',' high period covered, random direction',' low period covered, same direction',' low period covered, random direction'};
    [quest_lst,]=listdlg('ListString',lst_str,'ListSize',[230 85],'PromptString','How do you wish to organize the pattern?','SelectionMode','Single');
    quest=lst_str{quest_lst};
    switch quest
        case ' one, in the corner'
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid( 1:p_l,1:p_l )=handles.pattern;
        case ' one, in the center'
            a=floor(1+.5*(handles.N-p_l));
            handles.vis_grid=zeros(handles.N);
            handles.vis_grid( a:a+p_l-1 , a:a+p_l-1 )=handles.pattern;
        case ' high period covered, same direction'
            handles.vis_grid=zeros(handles.N);
            for k=0:floor(handles.N/p_l)-1
                for l=0:floor(handles.N/p_l)-1
                    handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=handles.pattern;
                end %l
            end %k
        case ' high period covered, random direction'
            handles.vis_grid=zeros(handles.N);
            for k=0:floor(handles.N/p_l)-1
                for l=0:floor(handles.N/p_l)-1
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
            handles.vis_grid=zeros(handles.N);
            for k=0:floor(handles.N/p_l)-1
                for l=0:floor(handles.N/p_l)-1
                    if ((k/2)==floor(k/2))&&((l/2)==floor(l/2))
                        handles.vis_grid(1+k*p_l:(1+k)*p_l,1+l*p_l:(1+l)*p_l)=handles.pattern;
                    end %if
                end %l
            end %k
        case ' low period covered, random direction'
            handles.vis_grid=zeros(handles.N);
            handles.pattern(2*handles.N,2*handles.N)=0;
            for k=0:floor(handles.N/p_l)-1
                for l=0:floor(handles.N/p_l)-1
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

function []=button_enable(handles,status,situation)
f_inf=['set(handles.increase_iterations,''enable'',status);',...
    'set(handles.decrease_iterations,''enable'',status);',...
    'set(handles.iterations_str,''enable'',status);',...
    'set(handles.units,''enable'',status);',...
    'set(handles.hundreds,''enable'',status);',...
    'set(handles.tens,''enable'',status);'];
f_other=['set(handles.popupmenu1,''enable'',status);',...
    'set(handles.reset_gr,''enable'',status);',...
    'set(handles.inverse_grid,''enable'',status);',...
    'set(handles.clear_grid,''enable'',status);',...
    'set(handles.draw_button,''enable'',status);',...
    'set(handles.file,''enable'',status);',...
    'set(handles.grid_size_N,''enable'',status);',...
    'set(handles.N_size,''enable'',status);',...
    'set(handles.N_size,''enable'',status);',...
    'set(handles.inf_loop,''enable'',status);'...
    'set(handles.move_up,''enable'',status);'...
    'set(handles.move_down,''enable'',status);'...
    'set(handles.move_left,''enable'',status);'...
    'set(handles.move_right,''enable'',status);'...
    'set(handles.flip_hor,''enable'',status);'...
    'set(handles.flip_ver,''enable'',status);'...
    'set(handles.trsps,''enable'',status);'];
switch situation
    case 'INF'
        eval(f_inf);
    case 'DRAW'
        set(handles.speed_slider,'enable',status);
        set(handles.start_stop,'enable',status);
        eval(f_other);
        eval(f_inf);
    case 'START_STOP'
        eval(f_other);
        eval(f_inf);
end
