function varargout = design_fft2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
		'gui_Singleton',  gui_Singleton, ...
		'gui_OpeningFcn', @untitled_OpeningFcn, ...    
		'gui_OutputFcn',  @untitled_OutputFcn, ... 
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
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = untitled_OutputFcn(hObject, eventdata, handles)  
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)  %显示原图

[filename, pathname]=uigetfile({'*.jpg;*.tif;*.bmp;*.gif' },'File Selector');
image=imread(strcat(pathname,filename));
I=image;
I=double(I);
save image.mat I;
axes(handles.axes1);
imshow(image);  

function pushbutton2_Callback(hObject, eventdata, handles)  %自编fft图像

load image.mat
image=I;
image1=image(:,:,1);
image2=image(:,:,2);
image3=image(:,:,3);
[r,c]=size(image1);

%补零
t=log2(r);
t1=floor(t);%t1为小于等于t的最大整数 
t2=ceil(t); %t2为大于等于t的最小整数
if t1~=t2      %t1不等于t2
image1(2^t2,c)=0;
image2(2^t2,c)=0;
image3(2^t2,c)=0;
end
[r1,c1]=size(image1);
t=log2(c1);
t3=floor(t);
t4=ceil(t);
if t3~=t4
image1(r1,2^t4)=0;
image2(r1,2^t4)=0;
image3(r1,2^t4)=0;
end

%自编fft计算
image1s=transform_fft2(image1);
image2s=transform_fft2(image2);
image3s=transform_fft2(image3);

image1a=uint8(image1s);
image2a=uint8(image2s);
image3a=uint8(image3s);
 
imagergb(:,:,1)=image1a;
imagergb(:,:,2)=image2a;
imagergb(:,:,3)=image3a;

save imagefftzibian.mat imagergb;

axes(handles.axes2);
imshow(imagergb);
figure(1);
imshow(imagergb);

 array1=transform_ifft2(image1s);
 array2=transform_ifft2(image2s);
 array3=transform_ifft2(image3s);
 
 %matlab为图像提供了特殊的数据类型uint8(8位无符号整数），以此方式存储的图像称作8位图像。
 array1=uint8(array1);
 array2=uint8(array2);
 array3=uint8(array3);
 
 %截取原图片长度和宽度
 array1=array1(1:r,1:c);
 array2=array2(1:r,1:c);
 array3=array3(1:r,1:c);
 
 arrayrgb(:,:,1)=array1;
 arrayrgb(:,:,2)=array2;
 arrayrgb(:,:,3)=array3;
 
 save imageifftzibian.mat arrayrgb;
 
 axes(handles.axes3);
 imshow(arrayrgb,[]);
 figure(3);
imshow(arrayrgb);   

function pushbutton3_Callback(hObject, eventdata, handles)  %系统fft图像

load image.mat
image=I;

     image1=image(:,:,1);
     image2=image(:,:,2);
     image3=image(:,:,3);
     [r,c]=size(image1);
     
t=log2(r);
t1=floor(t);%t1为小于等于t的最大整数 
t2=ceil(t); %t2为大于等于t的最小整数
if t1~=t2      %t1不等于t2
image1(2^t2,c)=0;
image2(2^t2,c)=0;
image3(2^t2,c)=0;
end
[r1,c1]=size(image1);
t=log2(c1);
t3=floor(t);
t4=ceil(t);
if t3~=t4
image1(r1,2^t4)=0;
image2(r1,2^t4)=0;
image3(r1,2^t4)=0;
end

image1=fft2(image1);
image2=fft2(image2);
image3=fft2(image3);
    
image1a=uint8(image1);
image2a=uint8(image2);
image3a=uint8(image3);
 
imagergb2(:,:,1)=image1a;
imagergb2(:,:,2)=image2a;
imagergb2(:,:,3)=image3a;

save imagefftxitong.mat imagergb2;

axes(handles.axes4);
imshow(imagergb2);
figure(2);
imshow(imagergb2);

image1=ifft2(image1);
image1=uint8(image1);

image2=ifft2(image2);
image2=uint8(image2);

image3=ifft2(image3);
image3=uint8(image3);
 
image1=image1(1:r,1:c);
image2=image2(1:r,1:c);
image3=image3(1:r,1:c);
 
imagergb1(:,:,1)=image1;
imagergb1(:,:,2)=image2;
imagergb1(:,:,3)=image3;
 
save imageifftxitong.mat imagergb1;

axes(handles.axes5);
imshow(imagergb1);
figure(4);
imshow(imagergb1);
return

function pushbutton4_Callback(hObject, eventdata, handles)  %关闭
clc; 
close all; 
close(gcf);

function pushbutton5_Callback(hObject, eventdata, handles)  %灰度图

load image.mat
image=I;
image=uint8(image);
if ndims(image)==3
image=rgb2gray(image);
end
axes(handles.axes6);
imshow(image);
figure(5);
imshow(image);

function array1=transform_fft(array)    %对N位一维数组进行FFT

N=length(array);
M=log2(N);
WN=zeros(1,N,'double');
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

function array=transform_fft2(array)    %对二维数组进行FFT
array=double(array);
[r1,c1]=size(array);
for j=1:r1          %对每一行进行FFT
array(j,:)=transform_fft(array(j,:));
end
for j=1:c1
array(:,j)=transform_fft((array(:,j)));
end

function array=transform_ifft2(array)   %对二维数组进行IFFT
array=conj(array);
[r1,c1]=size(array);
for i=1:c1
array(i,:)=transform_fft(array(i,:));
end
for i=1:c1
array(:,i)=transform_fft(array(:,i));
end
array=conj(array);
array=array/(r1*c1);

function pushbutton15_Callback(hObject, eventdata, handles) %音频处理
open('yinpin.fig');
