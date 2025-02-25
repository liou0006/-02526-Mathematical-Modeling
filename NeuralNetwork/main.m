
T = readtable("Libian_desert_data.csv");

rotatedImage = rotate_image(T,45);

bias =  10;  % Change Bias here
biasedimage = apply_bias(rotatedImage,bias);  % applying bias

foldedimage = apply_activation(biasedimage,'ab');
% foldedimage(1,:) = -foldedimage(1,:);
% 
% saveas(foldedimage)
% 
% writematrix(new_data, 'transformed_data.csv');
% 
% scatter(X,Y,is,'filled');