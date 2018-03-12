function varargout = yinpin(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @yinpin_OpeningFcn, ...
                   'gui_OutputFcn',  @yinpin_OutputFcn, ...
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
function yinpin_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = yinpin_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)  %原声
handles = guihandles(gcf);
[filename,pathname]=uigetfile({'*.wav'},'选择语音信号');
str=[pathname filename];
[y,Fs]=wavread(str);
y=y(:,1);

Y=y;
save y.mat Y;
FS=Fs;
save Fs.mat FS;

sound(y,Fs);
t=(0:length(y)-1)/Fs; %计算时间轴
axes(handles.axes1);
plot(t,y);xlabel('Time(s)');%在第一个窗口画波形
grid on;

function pushbutton2_Callback(hObject, eventdata, handles)  %系统FFT
handles = guihandles(gcf);
load y.mat;
y=Y;
load Fs.mat;
Fs=FS;

r=length(y);
m=log2(r);
m1=floor(m);%t1为小于等于t的最大整数 
m2=ceil(m); %t2为大于等于t的最小整数
if m1~=m2      %t1不等于t2
y(r:2^m2)=0;
end

r=length(y);
t=(0:r-1)/Fs; %计算时间轴

y=fft2(y);
y=fftshift(y);
y=abs(y);

sound(y,Fs);

axes(handles.axes2);
plot(t,y);xlabel('Time(s)');%在第一个窗口画波形
grid on;

function pushbutton3_Callback(hObject, eventdata, handles)  %系统IFFT
handles = guihandles(gcf);
load y.mat;
y=Y;
load Fs.mat;
Fs=FS;
r=length(y);

m=log2(r);
m1=floor(m);%t1为小于等于t的最大整数 
m2=ceil(m); %t2为大于等于t的最小整数
if m1~=m2      %t1不等于t2
y(r:2^m2)=0;
end

r=length(y);
y=fft2(y);
y1=ifft2(y);
t=(0:r-1)/Fs; %计算时间轴
sound(y1,Fs);
axes(handles.axes3);
plot(t,y1);xlabel('Time(s)');%在第一个窗口画波形
grid on;

function pushbutton4_Callback(hObject, eventdata, handles)  %自编FFT
handles = guihandles(gcf);
load y.mat;
y=Y;
load Fs.mat;
Fs=FS;
r=length(y);
m=log2(r);
m1=floor(m);%t1为小于等于t的最大整数 
m2=ceil(m); %t2为大于等于t的最小整数
if m1~=m2      %t1不等于t2
y(r:2^m2)=0;
end

r=length(y);
t=(0:r-1)/Fs; %计算时间轴

y=transform_fft(y);
y=fftshift(y);
y=abs(y);

sound(y,Fs);

axes(handles.axes4);
plot(t,y);xlabel('Time(s)');%在第一个窗口画波形
grid on;    

function pushbutton5_Callback(hObject, eventdata, handles)  %自编IFFT
handles = guihandles(gcf);
load y.mat;
y=Y;
load Fs.mat;
Fs=FS;
r=length(y);

m=log2(r);
m1=floor(m);%t1为小于等于t的最大整数 
m2=ceil(m); %t2为大于等于t的最小整数
if m1~=m2      %t1不等于t2
y(r:2^m2)=0;
end

r=length(y);
y=fft2(y);
y1=ifft2(y);
t=(0:r-1)/Fs; %计算时间轴
sound(y1,Fs);
axes(handles.axes5);
plot(t,y1);xlabel('Time(s)');%在第一个窗口画波形
grid on;

function array1=transform_fft(array)    %对N位一维数组进行FFT
array=double(array);
N=length(array);
M=log2(N);
for m=0:N/2-1;
    WN(m+1)=exp(-1i*2*pi/N)^m;
end
J=0;
for I=0:N-1
    if I<J
        T=array(I+1);
        array(I+1)=array(J+1);
        array(J+1)=T;
    end
    K=N/2;
    while J>=K
        J=J-K;
        K=K/2;
    end
    J=J+K;
end
    
for L=1:M
    B=2^(L-1);
    for R=0:B-1
        P=2^(M-L)*R;
        for K= R:2^L:N-2
            T=array(K+1)+array(K+B+1)*WN(P+1);
            array(K+B+1)=array(K+1)-array(K+B+1)*WN(P+1);
            array(K+1)=T;
        end
    end
end

array1=array;
return

function array=transform_ifft(array)   %对N位一维数组进行IFFT
N=length(array);
array=conj(array);
array1=transform_fft(array);
array2=conj(array1);
array3=array2/N;
array=array3;

function pushbutton6_Callback(hObject, eventdata, handles)  %退出
clc; 
close all; 
close(gcf);
