clear all;
close all;
clc;

I=imread('\..\img\book_cover.jpg');
I=im2double(I);
figure(1);
imshow(I);
title('SOURCE');

%Part1
[M,N]=size(I);
F=fftshift(fft2(I));

a=0.1;
b=0.1;
T=1;
[u,v]=meshgrid((1:M)-M/2,(1:N)-N/2);
H=T./(pi*(u*a+v*b)).*sin(pi*(u*a+v*b)).*exp(-1i*pi*(u*a+v*b));
H(isnan(H)) = 1;

R=H.*F;
blurred=real(ifft2(ifftshift(R)));
blurred=blurred(1:M,1:N);

figure(2);
imshow(blurred);
title('BLURRED');

%Part2
mean=0;
var=500;
N=var/255^2*randn(M,N)+mean;
blurred_noisy=blurred+N;

figure(3);
imshow(blurred_noisy);
title('BLURRED NOISY');

%Part3
F_B=fftshift(fft2(blurred));
F_BN=fftshift(fft2(blurred_noisy));

inv=inverse(H);

F_B_inv=F_B.*inv;
F_BN_inv=F_BN.*inv;

blurred_inverse = ifft2(ifftshift(F_B_inv));
blurred_noisy_inverse = ifft2(ifftshift(F_BN_inv));

figure(4);
imshow(blurred_inverse);
title('BLURRED INVERSE');
figure(5);
imshow(blurred_noisy_inverse);
title('BLURRED NOISY INVERSE');

%Part4
for i=1:3
    para=[0.1,0.01,0.001];
    wie=wiener(H,para(i));
    F_BN_wie=F_BN.*wie;
    blurred_noisy_wiener = ifft2(ifftshift(F_BN_wie));
    
    figure(5+i);
    imshow(blurred_noisy_wiener);
    title(['WIENER parameter=',num2str(para(i))]);
end
