function varargout = kalman(varargin)
% KALMAN MATLAB code for kalman.fig
%      KALMAN, by itself, creates a new KALMAN or raises the existing
%      singleton*.
%
%      H = KALMAN returns the handle to a new KALMAN or the handle to
%      the existing singleton*.
%
%      KALMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KALMAN.M with the given input arguments.
%
%      KALMAN('Property','Value',...) creates a new KALMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kalman_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kalman_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kalman

% Last Modified by GUIDE v2.5 23-Dec-2019 15:41:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kalman_OpeningFcn, ...
                   'gui_OutputFcn',  @kalman_OutputFcn, ...
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

function initialize()
clear;
clear global;

global Q R;
Q = [1,0,0;0,1,0;0,0,1];
R = [1,0,0;0,1,0;0,0,1];

% --- Executes just before kalman is made visible.
function kalman_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kalman (see VARARGIN)

% Choose default command line output for kalman
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize();

% UIWAIT makes kalman wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kalman_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function draw_accel(ax,ay,az,t,handles)
axes(handles.axes1);
plot(t,ax,'r');
hold on
plot(t,ay,'b');
hold on
plot(t,az,'g');
xlabel('毫秒/ms');
ylabel('加速度m/s^2');
legend('+X方向','+Y方向','+Z方向');
title('九轴传感器');

function draw_degree(gx,gy,gz,t,handles)
axes(handles.axes1);
plot(t,gx,'r');
hold on
plot(t,gy,'b');
hold on
plot(t,gz,'g');
xlabel('毫秒/ms');
ylabel('角度/degree');
legend('+X方向','+Y方向','+Z方向');
title('九轴传感器');

function kalman_filter()
global ax ay az gx gy gz t;
global ax_after ay_after az_after gx_after gy_after gz_after t_after;
ax_after = ax;
ay_after = ay;
az_after = az;
gx_after = gx;
gy_after = gy;
gz_after = gz;
t_after = t;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%open file
[filename,pathname,ispressed] = uigetfile('*.mat;*.xlsx;*.csv','选择数据文件');
if(~ispressed)
    return;
end
fpath=[pathname filename];
[a,b,suffix] = fileparts(fpath);

%set data global
global ax ay az gx gy gz t;

if(string(suffix) == ".mat")
    %.mat
    load(fpath);
elseif(string(suffix) == ".csv" || string(suffix) == ".xlsx")  
    %.xlsx or .csv 
    ax = xlsread(fpath,'ax');
    ay = xlsread(fpath,'ay');
    az = xlsread(fpath,'az');
    gx = xlsread(fpath,'gx');
    gy = xlsread(fpath,'gy');
    gz = xlsread(fpath,'gz');
    t = xlsread(fpath,'t');
end

handles.pushbutton9.String = "保存数据";
%kalman function
kalman_filter();
drawgraph(handles);

function savedata(ax,ay,az,gx,gy,gz,t,fpath,suffix)
if(suffix == ".mat")
    save(fpath,'ax','ay','az','gx','gy','gz','t');
else
    xlswrite(fpath,ax,'ax');
    xlswrite(fpath,ay,'ay');
    xlswrite(fpath,az,'az');
    xlswrite(fpath,gx,'gx');
    xlswrite(fpath,gy,'gy');
    xlswrite(fpath,gz,'gz');
    xlswrite(fpath,t,'t');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ax ay az gx gy gz t;
global ax_after ay_after az_after gx_after gy_after gz_after t_after;

directory = uigetdir;
if(~directory)
    return;
end

list = get(handles.popupmenu3,'String');
index = get(handles.popupmenu3,'Value');
suffix = list{index};
time = datevec(datestr(now));
filename_sample = ['范例数据' '_' num2str(time(1)) num2str(time(2),'%02d') num2str(time(3),'%02d') '_' num2str(time(4),'%02d') num2str(time(5),'%02d') suffix];
filename_after = ['实验数据(卡尔曼滤波修正后)' '_' num2str(time(1)) num2str(time(2),'%02d') num2str(time(3),'%02d') '_' num2str(time(4),'%02d') num2str(time(5),'%02d') suffix];
filename_before = ['原始数据' '_' num2str(time(1)) num2str(time(2),'%02d') num2str(time(3),'%02d') '_' num2str(time(4),'%02d') num2str(time(5),'%02d') suffix];
fpath_sample = [directory '/' filename_sample];
fpath_after = [directory '/' filename_after];
fpath_before = [directory '/' filename_after];
sample_data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

if(length(handles.pushbutton9.String)==9)
    if(handles.pushbutton9.String == 'excel数据格式')
        [ax_temp,ay_temp,az_temp,gx_temp,gy_temp,gz_temp] = deal(sample_data);
        t_temp = (0:length(sample_data)-1);
        savedata(ax_temp,ay_temp,az_temp,gx_temp,gy_temp,gz_temp,t_temp,fpath_sample,suffix);
    end
end

if(length(handles.pushbutton9.String)==4)
    if(handles.pushbutton9.String == '保存数据')
        savedata(ax_after,ay_after,az_after,gx_after,gy_after,gz_after,t_after,fpath_after,suffix);
        %savedata(ax,ay,az,gx,gy,gz,t,fpath_before,suffix);
    end
end

function drawgraph(handles)

list_2 = get(handles.popupmenu2,'String');
index_2 = get(handles.popupmenu2,'Value');
type_2 = list_2{index_2};

list_5 = get(handles.popupmenu5,'String');
index_5 = get(handles.popupmenu5,'Value');
type_5 = list_5{index_5};

global ax ay az gx gy gz t;
global ax_after ay_after az_after gx_after gy_after gz_after t_after;
if(isempty(ax)&&isempty(ay)&&isempty(az)&&isempty(gx)&&isempty(gy)&&isempty(gz)&&isempty(t))
    return;
end
delete(allchild(handles.axes1));

if(type_5=="卡尔曼滤波后")
    ax_temp = ax_after;ay_temp = ay_after;az_temp = az_after;gx_temp = gx_after;gy_temp = gy_after;gz_temp = gz_after;t_temp = t_after;
elseif(type_5=="原始数据")
    ax_temp = ax;ay_temp = ay;az_temp = az;gx_temp = gx;gy_temp = gy;gz_temp = gz;t_temp = t;
end

if(type_2 == "加速度")
    %show data
    draw_accel(ax_temp,ay_temp,az_temp,t_temp,handles);
elseif(type_2 == "速度")
    
elseif(type_2 == "位移")
   
elseif(type_2 == "角度")
    %show data
    draw_degree(gx_temp,gy_temp,gz_temp,t_temp,handles);
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
drawgraph(handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize();

%just for Matrix of 3x3
function [Matrix] = str2mx(str)
str = deblank(str);
S = regexp(str, ';', 'split');
[a1,a,b] = sscanf(string(S{1,1}(1)),'[%f %f %f');
[a2,c,d] = sscanf(string(S{1,1}(2)),'%f %f %f');
[a3,e,f] = sscanf(string(S{1,1}(3)),'%f %f %f]');

Matrix = reshape([a1(1,1) a2(1,1) a3(1,1) a1(2,1) a2(2,1) a3(2,1) a1(3,1) a2(3,1) a3(3,1)],3,3);


%just for Matrix of 3x3
function [str] = mx2str(Matrix)
a1 = Matrix(1,:);
a2 = Matrix(2,:);
a3 = Matrix(3,:);
a_str = [string(a1) string(a2) string(a3)];
str = ['[' char(a_str(1)) ' ' char(a_str(2)) ' ' char(a_str(3)) ';' char(a_str(4)) ' ' char(a_str(5)) ' ' char(a_str(6)) ';' char(a_str(7)) ' ' char(a_str(8)) ' ' char(a_str(9)) ';' ']'];


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles x   structure with handles and user data (see GUIDATA)
% open('setting.fig');

global Q R;

options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

input = inputdlg({'输入3x3的Q矩阵','输入3x3的R矩阵'},'参数',1,{mx2str(Q),mx2str(R)},options);
if(isempty(input))
    return;
elseif(input(1,1)==""||input(2,1)=="")
    return;
end

Q = str2mx(input(1,1));
R = str2mx(input(2,1));


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%open the webstie by default browser
url = "https://github.com/JamesHoi/Kalman";
web(url,'-browser')


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Q R;
Q = [1,0,0;0,1,0;0,0,1];
R = [1,0,0;0,1,0;0,0,1];

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
drawgraph(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
