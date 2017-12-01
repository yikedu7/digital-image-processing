clear all;
I=imread('\..\img\office.jpg');
subplot(1,3,1);
imshow(I);
title('SOURCE');
I=double(rgb2gray(I));

%Homomorphic Filter
[M,N]=size(I);
I1=log(I+1);
F=fft2(I1);

rH=2;
rL=0.25;
C=1;
d0=400;

[v,u]=meshgrid(1:N,1:M);
u=u-floor(M/2);
v=v-floor(N/2);
D=u.^2+v.^2;
H=1-exp(-C*(D./d0^2));
H=(rH-rL)*H+rL;

H=ifftshift(H);
result=real(ifft2(F.*H));
R=exp(result)-1;
MAX=max(max(R));
MIN=min(min(R));
range=MAX-MIN;
R=uint8(255*(R-MIN)/range);

subplot(1,3,2);
imshow(R);
title('Homomorphic Filter');

%Butterworth Filter
I=double(I);
F=fftshift(fft2(I));

[M,N]=size(F);
nn=1;
m=floor(M/2);
n=floor(N/2);
result=zeros(M,N);
result=double(result);


d0=80;
for i=1:M
    for j=1:N
        d=sqrt((i-m)^2+(j-n)^2);
        h=1/(1+0.414*(d/d0)^(2*nn));
        result(i,j)=h*F(i,j);
    end
end
result=ifftshift(result);
disp(real(ifft2(result)));
R=uint8(real(ifft2(result)));
subplot(1,3,3);
imshow(R);
title('Butterworth Filter');

