
T = readtable("Libian_desert_data.csv");

rotation = 30; % change rotation amount here
rotatedImage = rotate_image(T,rotation);

bias =  00;  % Change Bias here
biasedimage = apply_bias(rotatedImage,bias);  % applying bias

foldedimage = apply_activation(biasedimage,'abs');

% foldedimage(1,:) = -foldedimage(1,:);
% 
% saveas(foldedimage)
% 
% writematrix(foldedimage, 'transformed_data.csv');
% 
scatter(foldedimage,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)