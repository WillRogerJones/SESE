function varargout = showerps(varargin)
% SHOWERPS M-file for showerps.fig
%      SHOWERPS, by itself, creates a new SHOWERPS or raises the existing
%      singleton*.
%
%      H = SHOWERPS returns the handle to a new SHOWERPS or the handle to
%      the existing singleton*.
%
%      SHOWERPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWERPS.M with the given input arguments.
%
%      SHOWERPS('Property','Value',...) creates a new SHOWERPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before showerps_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to showerps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help showerps

% Last Modified by GUIDE v2.5 25-Nov-2006 16:42:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @showerps_OpeningFcn, ...
    'gui_OutputFcn',  @showerps_OutputFcn, ...
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


% --- Executes just before showerps is made visible.
function showerps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to showerps (see VARARGIN)

% Choose default command line output for showerps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using showerps.


% UIWAIT makes showerps wait for user response (see UIRESUME)
% uiwait(handles.showerps);

%initialize the layer variable
global layer
layer = zeros(14,1);


% --- Outputs from this function are returned to the command line.
function varargout = showerps_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.showerps)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.showerps,'Name') '?'],...
    ['Close ' get(handles.showerps,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.showerps)


% --- Executes on selection change in SOA_menu.
function SOA_menu_Callback(hObject, eventdata, handles)
% hObject    handle to SOA_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SOA SOAnum
SOAnum = get(hObject,'Value');
string_list = get(hObject,'String');
SOA = string_list{SOAnum}; % Convert from cell array to string

% --- Executes during object creation, after setting all properties.
function SOA_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SOA_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global SOA SOAnum
SOA = '50ms';
SOAnum = 1;
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in numtargs_menu.
function numtargs_menu_Callback(hObject, eventdata, handles)
% hObject    handle to numtargs_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numtargs
numtargs = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function numtargs_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtargs_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global numtargs
numtargs = 1;
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Lag_menu.
function Lag_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Lag_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lag numtargs
lag = get(hObject,'Value');
%set to always be 1 for onetargets
if(numtargs == 1)
    lag = 1;
end

% --- Executes during object creation, after setting all properties.
function Lag_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lag_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global lag
lag = 1;
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in condition_menu.
function condition_menu_Callback(hObject, eventdata, handles)
% hObject    handle to condition_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global condition condstring
condition = get(hObject,'Value');
string_list = get(hObject,'String');
condstring = string_list{condition}; % Convert from cell array to string

% --- Executes during object creation, after setting all properties.
function condition_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condition_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global condition condstring
condition = 1;
condstring = 'Basic';
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in accu_menu.
function accu_menu_Callback(hObject, eventdata, handles)
% hObject    handle to accu_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global accu accustring
accu = get(hObject,'Value');
string_list = get(hObject,'String');
accustring = string_list{accu}; % Convert from cell array to string


% --- Executes during object creation, after setting all properties.
function accu_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accu_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global accu accustring
accu = 1;
accustring = 'T1 T2 / onetarg T1';
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in trace_menu.
function trace_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global trace tracestring
trace = get(hObject,'Value');
string_list = get(hObject,'String');
tracestring = string_list{trace}; % Convert from cell array to string

% --- Executes during object creation, after setting all properties.
function trace_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global trace tracestring
trace = 1;
tracestring = 'Membrane Potential';
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in input_box.
function input_box_Callback(hObject, eventdata, handles)
% hObject    handle to input_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(1) = get(hObject,'Value');

% --- Executes on button press in masking_box.
function masking_box_Callback(hObject, eventdata, handles)
% hObject    handle to masking_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(2) = get(hObject,'Value');


% --- Executes on button press in item_box.
function item_box_Callback(hObject, eventdata, handles)
% hObject    handle to item_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(3) = get(hObject,'Value');


% --- Executes on button press in TFL_box.
function TFL_box_Callback(hObject, eventdata, handles)
% hObject    handle to TFL_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(4) = get(hObject,'Value');


% --- Executes on button press in TFLoff_box.
function TFLoff_box_Callback(hObject, eventdata, handles)
% hObject    handle to TFLoff_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(5) = get(hObject,'Value');


% --- Executes on button press in bindgate_box.
function bindgate_box_Callback(hObject, eventdata, handles)
% hObject    handle to bindgate_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(6) = get(hObject,'Value');


% --- Executes on button press in bindtrace_box.
function bindtrace_box_Callback(hObject, eventdata, handles)
% hObject    handle to bindtrace_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(7) = get(hObject,'Value');


% --- Executes on button press in tokgate_box.
function tokgate_box_Callback(hObject, eventdata, handles)
% hObject    handle to tokgate_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(8) = get(hObject,'Value');


% --- Executes on button press in toktrace_box.
function toktrace_box_Callback(hObject, eventdata, handles)
% hObject    handle to toktrace_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(9) = get(hObject,'Value');


% --- Executes on button press in itemoff_box.
function itemoff_box_Callback(hObject, eventdata, handles)
% hObject    handle to itemoff_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(10) = get(hObject,'Value');


% --- Executes on button press in blasterin_box.
function blasterin_box_Callback(hObject, eventdata, handles)
% hObject    handle to blasterin_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(11) = get(hObject,'Value');


% --- Executes on button press in blasterinoff_box.
function blasterinoff_box_Callback(hObject, eventdata, handles)
% hObject    handle to blasterinoff_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(12) = get(hObject,'Value');


% --- Executes on button press in blasterout_box.
function blasterout_box_Callback(hObject, eventdata, handles)
% hObject    handle to blasterout_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(13) = get(hObject,'Value');


% --- Executes on button press in blasteroutoff_box.
function blasteroutoff_box_Callback(hObject, eventdata, handles)
% hObject    handle to blasteroutoff_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global layer
layer(14) = get(hObject,'Value');


% --- Executes on button press in plottrace_button.
function plottrace_button_Callback(hObject, eventdata, handles)
% hObject    handle to plottrace_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotarea);
cla;
ploterps(0)


% --- Executes on button press in addtrace_button.
function addtrace_button_Callback(hObject, eventdata, handles)
% hObject    handle to addtrace_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotarea);
ploterps(1)


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
[file,path] =  uiputfile({'*.xls';'*.txt'},'save ERP as');
save(file,'data','-ascii');


%this function takes the parameters from the gui and plots the
%corresponding data
function ploterps(add)
global SOA numtargs trace layer lag condstring condition accu accustring tracestring curlegend colorcount ml data

%get the layers to plot
layindex = [];
for (i = 1:length(layer))
    if(layer(i))
        layindex = [layindex i];
    end
end

data = 0;

%load the erp data file into workspace
if(numtargs == 1)
    lag = 1;
    filetoload  = ['STSTerp_1targ_' SOA '.mat'];
    %create string for legend
    plotstring = cellstr(sprintf('%s - %d target - %s condition \n %s trials - %s \n Layer(s) %s\n',SOA,numtargs,condstring,accustring,tracestring,num2str(layindex)));
else
    filetoload  = ['STSTerp_' SOA '.mat'];
    %create string for legend
    plotstring = sprintf('%s - %d targets - lag %d\n %s condition \n %s trials - %s \n Layer(s) %s\n',SOA,numtargs,lag,condstring,accustring,tracestring,num2str(layindex));
end

%check for version 7 matlab
ml = version;
ml = str2double(ml(1));

if(ml ~= 7)
    %get axes colors
    colors = get(gca,'colororder');
end

%add to plot?
if(add)
    if(ml == 7)
        hold all;
    else
        hold on;
        colorcount = colorcount + 1;
    end
    curlegend = [curlegend plotstring];
else
    hold off;
    if(ml ~= 7)
        colorcount = 1;
    end
    curlegend = plotstring;
end

%load the accuracy data
load(filetoload,'*Accu')

try
    data = [];
    %which condition?
    if(condition == 1) %Basic
        %load ERP data
        load(filetoload,'*_basic')
        %get trials to plot
        trials = [];
        for(t = 1:size(BasicAccu,1))
            if(BasicAccu(t,lag) == accu)
                trials = [trials t];
            end
        end
        
        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_basic(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_basic(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_basic(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_basic(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_basic(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_basic(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_basic(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_basic(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end

    elseif(condition == 2) %T1+1 blank
        %load ERP data
        load(filetoload,'*_T1blank');
        %get trials to plot
        trials = [];
        for(t = 1:size(BlankAccu,1))
            if(BlankAccu(t,lag) == accu)
                trials = [trials t];
            end
        end

        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_T1blank(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_T1blank(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_T1blank(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_T1blank(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_T1blank(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_T1blank(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_T1blank(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_T1blank(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end

    elseif(condition == 3) %T2+1 blank
        %do nothing

    elseif(condition == 4) %Easy
        %load ERP data
        load(filetoload,'*_easy');
        %get trials to plot
        trials = [];
        for(t = 1:size(EasyAccu,1))
            if(EasyAccu(t,lag) == accu)
                trials = [trials t];
            end
        end

        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_easy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_easy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_easy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_easy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_easy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_easy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_easy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_easy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end

    elseif(condition == 5) %Hard
        %load ERP data
        load(filetoload,'*_hard');
        %get trials to plot
        trials = [];
        for(t = 1:size(HardAccu,1))
            if(HardAccu(t,lag) == accu)
                trials = [trials t];
            end
        end

        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_hard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_hard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_hard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_hard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_hard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_hard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_hard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_hard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end

    elseif(condition == 6) %Blanked Easy
        %load ERP data
        load(filetoload,'*_blankeasy');
        %get trials to plot
        trials = [];
        for(t = 1:size(BlankEasyAccu,1))
            if(BlankEasyAccu(t,lag) == accu)
                trials = [trials t];
            end
        end

        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_blankeasy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_blankeasy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_blankeasy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_blankeasy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_blankeasy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_blankeasy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_blankeasy(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_blankeasy(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end

    elseif(condition == 7) %Blanked Hard
        %load ERP data
        load(filetoload,'*_blankhard');
        %get trials to plot
        trials = [];
        for(t = 1:size(BlankHardAccu,1))
            if(BlankHardAccu(t,lag) == accu)
                trials = [trials t];
            end
        end

        if(trace == 1) %membrane potential(trial,lag,timesteps,layer)
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = MembPotBat_blankhard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = MembPotBat_blankhard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 2) %plot presynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = PresynapBat_blankhard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = PresynapBat_blankhard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 3) %plot excitatory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = ExPostsynBat_blankhard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = ExPostsynBat_blankhard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end

        elseif(trace == 4) %plot inhibitory postsynaptic activation
            %sum over multiple layers
            if(length(layindex) > 1)
                for(t = 1:length(trials))
                    for (i = 1 : length(layindex))
                        data(t,i,:) = InhibPostsynBat_blankhard(trials(t),lag,:,layindex(i));
                    end
                end
                data = squeeze(mean(data,1));
                data = sum(data);
            else %or plot just one layer
                for(t = 1:length(trials))
                    data = InhibPostsynBat_blankhard(trials(t),lag,:,layindex(1));
                end
                data = squeeze(mean(data,1));
            end
        end
    end

    %if multiple layers
    if(length(layindex) > 1)
        data = data';
    end
    
    numtrials = length(trials)
    %now plot the data
    if(ml == 7)
        plot(data);
    else
        plot(data,'Color',colors(colorcount,:));
    end
    legend(curlegend);
    xlabel('Multiply timesteps by 5 for milliseconds - + 80ms retina delay');
catch
    'data not available'
end

