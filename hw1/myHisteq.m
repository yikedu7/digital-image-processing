clear all

img = imread('river.JPG');
[m,n] = size(img);
target = zeros(m,n);
histogram = zeros(1,256);
tmap = zeros(1,256);

% get histogram
for i = 1:m
    for j = 1:n
        histogram(img(i,j) + 1) = histogram(img(i,j) + 1) + 1;
    end
end

% Histogram equalization
for i = 1:256
    temp = 0;
    for j = 1:i
        temp = temp + histogram(j);
    end
    tmap(i) = floor(temp*255/(m*n));
end
for i = 1:m
    for j= 1:n
        target(i,j) = tmap(img(i,j)+1);
    end
end

% show result
target = uint8(target);
figure
imshow(target)
title('use my histeq()')

% show result using histeq()
test = histeq(img);
figure
imshow(test)
title('use matlab histeq()')
