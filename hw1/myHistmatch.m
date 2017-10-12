clear all

lina = imread('LENA.png');
eightam = imread('EightAM.png');
[m,n] = size(lina);
[a,b] = size(eightam);
lina_hist = zeros(1,256);
eightam_hist = zeros(1,256);
match = zeros(1,256);
target = zeros(a,b);

% get lina histogram
for i = 1:m
    for j = 1:n
        lina_hist(lina(i,j) + 1) = lina_hist(lina(i,j) + 1) + 1;
    end
end
figure
bar(0:255,lina_hist,'b')

% get eightam histogram
for i = 1:a
    for j = 1:b
        eightam_hist(eightam(i,j) + 1) = eightam_hist(eightam(i,j) + 1) + 1;
    end
end
figure
bar(0:255,eightam_hist,'b')

% calculate the cdf
lina_cdf = cumsum(lina_hist) / numel(lina);
eightam_cdf = cumsum(eightam_hist) / numel(eightam);

% get the match function
for index = 1:256
    [temp, idx] = min(abs(eightam_cdf(index) - lina_cdf));
    match(index) = idx - 1;
end

% use match function
for i = 1:a
    for j= 1:b
        target(i,j) = match(eightam(i,j)+1);
    end
end

% show result
target = uint8(target);
figure
imshow(target)

target_hist = zeros(1,256);
for i = 1:a
    for j = 1:b
        target_hist(target(i,j) + 1) = target_hist(eightam(i,j) + 1) + 1;
    end
end
figure
bar(0:255,target_hist,'b')