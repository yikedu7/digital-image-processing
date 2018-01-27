# 算法表述

### 基于PCA的人脸识别

#### Step 1

读取训练图像。对于每个人的10张图像，选择前7张用来训练，后3张用于测试。将7张训练图像平均后作为一个特征图像再进行PCA特征抽取。将所有特征图像张成列向量，并合并为训练集矩阵。

```matlab
%get train image of each person and calculate the mean
cd('att_faces');
train_img = [];
for i = 1:40
    cd(['s' int2str(i)]);
    I = [];
    for j = 1:7
       img = imread([int2str(j) '.pgm']);
       [r,c] = size(img);
       temp = reshape(img, r*c, 1);
       I = [I temp];
    end
    Im = mean(I,2);
    train_img = [train_img Im];
    cd('..');
end
cd('..');
```

#### Step 2

求取所有训练集图像在各个维度上的均值（即对训练集矩阵各行求均值），并且对每个图像向量减去该值得到新的训练集矩阵：

```matlab
%substrate the mean of each row
Am = mean(train_img,2);
for i = 1:40
    train_img(:,i) = double(train_img(:,i)) - Am;
end
```

计算特征向量与特征值，进行PCA特征提取。首先将训练集矩阵与其自身的逆矩阵相乘得到矩阵L；使用matlab中的`eig()`函数计算得到特征向量与特征值；根据实验要求，设置特征维度为50，即提取出特征值较大的50个特征向量，合并为矩阵后与训练集矩阵相乘得到eigenfaces矩阵：

```matlab
%get eigenface
L= train_img' * train_img;
[V,D]=eig(L); 
L_eig_vec = [];
D = sum(D,1);
dim = 50;
for i = 1:dim 
    [maxD, max_index] = max(D);
    D(1,max_index) = 0;
    L_eig_vec = [L_eig_vec V(:,max_index)];
end
eigenfaces = train_img * L_eig_vec;
```

将eigenfaces矩阵的逆与40个训练图像向量相乘，得到映射后的向量集pro_img：

```matlab
%projected vector
pro_img = [];
for i = 1:40
    temp = eigenfaces' * train_img(:,i);
    pro_img = [pro_img temp];
end
```

#### Step 3

使用测试图像进行测试，并计算识别成功率。对测试图像也要进行与训练图像类似的处理：张成列向量，减去各个维度的均值，计算在特征矩阵上的映射向量；得到映射向量后，根据实验要求，使用二范数来计算其到40个人脸图像向量距离，取其中距离最小的向量，认定为同一人脸图像：

```matlab
cd('att_faces');
test_result = [];
for i = 1:40
    cd(['s' int2str(i)]);
    I = [];
    for j = 8:10
       dist = [];
       %get test image and extract its PCA features
       img = imread([int2str(j) '.pgm']);
       [r,c] = size(img);
       test = reshape(img, r*c, 1);
       test = double(test) - Am;
       pro_test_img = eigenfaces' * test;
       %calculate the minus of euclidian distance of all projected trained images
       for k = 1:40
           temp = (norm(pro_test_img - pro_img(:,k))) ^ 2;
           dist = [dist temp];
       end
       [min_dist, min_index] = min(dist);
       
       if min_index == i
           test_result = [test_result 1];
       else
           test_result = [test_result 0];
       end
       disp(['real index is:' int2str(i) '; test index is:' int2str(min_index)]);
    end
    cd('..');
end
cd('..');

%calculate the correction rate
rate = sum(test_result) / 120;
disp(['The correction rate is ' num2str(rate)]);
```

最终程序输出的部分结果如下：

```
real index is:1; test index is:1
real index is:1; test index is:1
real index is:1; test index is:1
real index is:2; test index is:2
real index is:2; test index is:2
real index is:2; test index is:2
real index is:3; test index is:3
real index is:3; test index is:4
real index is:3; test index is:3
real index is:4; test index is:4
real index is:4; test index is:4
real index is:4; test index is:4
real index is:5; test index is:5
real index is:5; test index is:40
real index is:5; test index is:18
...
...
The correction rate is 0.74167
```

识别成功率为74.167%，可见该PCA算法仍有一定的成功率提升空间。