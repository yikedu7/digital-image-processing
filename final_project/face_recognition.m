clear all;
close all;
clc;

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

%substrate the mean of each row
Am = mean(train_img,2);
for i = 1:40
    train_img(:,i) = double(train_img(:,i)) - Am;
end

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

%get eigenface using Kaiser's rule
% L= train_img' * train_img;
% [V,D]=eig(L); 
% L_eig_vec = [];
% for i = 1 : size(V,2) 
%     if( D(i,i) > 1 )
%         L_eig_vec = [L_eig_vec V(:,i)];
%     end
% end
% disp(size(L_eig_vec, 2));
% eigenfaces = train_img * L_eig_vec;

%projected vector
pro_img = [];
for i = 1:40
    temp = eigenfaces' * train_img(:,i);
    pro_img = [pro_img temp];
end

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
