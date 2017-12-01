### 1. Butterworth Filter

> 给定图像‘barb.png’，利用一阶Butterworth低通滤波器进行频域滤波，当 D0=10,20,40,80时，给出相应滤波图像，并分别以频域和空域的观点解释有关滤波结果。 

#### (一)读取原图片并输出

```matlab
I=imread('\..\img\barb.png');
subplot(1,5,1);
imshow(I);
title('SOURCE');
```

#### (二)快速傅里叶变换

```matlab
I=double(I);
F=fftshift(fft2(I));
```

根据题目提示，使用matlab函数`fft2()`进行快速傅里叶变换，需要补充说明的是：1.由于 matlab 不支持图像的无符号整形运算，所以在傅里叶变化前需要先将数据类型转换为 double 型；2.进行傅里叶变换后需要相应的进行中心化处理，才能进一步处理图像。

#### (三)一阶 Butterworth 滤波器

```matlab
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
    R=uint8(real(ifft2(result)));
    subplot(1,5,k+2);
    imshow(R);
    title(['D0=',num2str(d0)]);
end
```

这部分是滤波器的实现主体。

首先，需要设置或计算一些算法必须的参数。M，N 为图像大小；nn为 Butterworth 滤波的阶数，由于我们使用一阶滤波器所以设置为1；m，n 用于计算距离d；以及先要设置好 result 矩阵的大小，否则 matlab 会报警告。

下一部分，我使用 k 作为循环参数循环产生不同的D0值，进行4次 Butterworth 滤波并输出4次处理结果。循环内部则是每次的 Butterworth 滤波实现，基本思路就是先计算出滤波器的传递函数(套公式)，然后使用滤波器处理原图像则可得到效果图像。

该算法产生的图像效果如下：

![butterworthFilter](img\butterworthFilter.png)

### 2. Homomorphic Filter

> 采用同态滤波来增强图像‘office.jpg’细节:
>
> （1）参数选择：参考rH=2, rL=0.25.C=1。 
> （2）自己尝试不同的D0以得到好的结果。
> （3）如将滤波器替换为一阶Butterworth高通滤波器，比较滤波结果。 

#### (一)读取原图片并输出

```matlab
I=imread('\..\img\office.jpg');
subplot(1,3,1);
imshow(I);
title('SOURCE');
```

#### (二)快速傅里叶变换

```matlab
I=double(rgb2gray(I));
[M,N]=size(I);
I1=log(I+1);
F=fft2(I1);
```

同样的还是用matlab函数`fft2()`进行快速傅里叶变换。其中log(I+1)是为了满足真数大于0的条件，避免计算错误。

#### (三)同态滤波

```matlab
rH=2;
rL=0.25;
C=1;
d0=400;
```

首先，设置好一些必要的参数。d0之所以设置为400是因为我在多次调整d0的大小并对比后觉得在400左右能到达较好的滤波效果。其他的参数是根据题目要求设定的。

```matlab
[v,u]=meshgrid(1:N,1:M);
u=u-floor(M/2);
v=v-floor(N/2);
D=u.^2+v.^2;
H=1-exp(-C*(D./d0^2));
H=(rH-rL)*H+rL;
```

同样的，套公式计算出滤波器函数H。

```matlab
H=ifftshift(H);
result=real(ifft2(F.*H));
R=exp(result)-1;
```

对滤波器函数进行反中心化处理并应用处理后的函数对原图像进行同态滤波，得到结果后，由于之前进行过取对数操作，所以要做exp()。

```matlab
MAX=max(max(R));
MIN=min(min(R));
range=MAX-MIN;
R=uint8(255*(R-MIN)/range);
```

为了让结果图像适合人眼观察需要对数据做一定的映射，这里我按照题目中提示的方法通过计算出数据范围来进行数据映射。

#### (四)使用 Butterworth Filter 进行滤波并对比

这里的算法与第一题一致，就不做重复叙述。得到的最终效果如下图：

![homomorphicFilter](img\homomorphicFilter.png)