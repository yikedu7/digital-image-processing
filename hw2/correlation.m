clear all

scene = imread('car.png');
[m,n] = size(scene);
template = imread('wheel.png');
[u,v] = size(template);
target = zeros(m-u+1,n-v+1);
template_vec = double(template(:));
template_norm = norm(template_vec);

for i = 1:m-u+1
    for j = 1:n-v+1
        scene_sub = scene(i:i+u-1,j:j+v-1);
        scene_vec = double(scene_sub(:));
        scene_norm = norm(scene_vec);
        target(i,j) = template_vec' * scene_vec / (template_norm * scene_norm);
    end
end

[iMax, jMax] = find(target==max(target(:)));
disp([iMax,jMax]);

figure
imshow(target)



