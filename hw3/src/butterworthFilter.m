clear all;
I=imread('\..\img\barb.png');
subplot(1,5,1);
imshow(I);
title('SOURCE');

I=double(I);
F=fftshift(fft2(I));

[M,N]=size(F);
nn=1;
m=floor(M/2);
n=floor(N/2);
result=zeros(M,N);
result=double(result);

for k=0:3
    d0=10*2^k;
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
    subplot(1,5,k+2);
    imshow(R);
    title(['D0=',num2str(d0)]);
end
