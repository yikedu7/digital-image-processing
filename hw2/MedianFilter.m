clear all

car = imread('sport car.pgm');
[m,n] = size(car);
t1 = rand(m,n) * 255;
t2 = rand(m,n) * 255;
noise = zeros(m,n);
window = zeros(3,3);

for i = 1:m
    for j = 1:n
        if car(i,j) > t1(i,j)
            noise(i,j) = 255;
            continue;
        end
        if car(i,j) < t2(i,j)
            noise(i,j) = 0;
            continue;
        end
        noise(i,j) = car(i,j);
    end
end

handled = nlfilter(noise,[3 3],@matrixMedian);
handledByInbuild = medfilt2(noise,[3 3]);

figure
imshow(car)
figure
imshow(noise)
figure
imshow(handled)
figure
imshow(handledByInbuild)
