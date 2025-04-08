clear; clc; close all
filename = "channel_data.txt";
T = readtable(filename);
T.Properties.VariableNames = {'Latitude', 'Longtitude', 'Height'};


h = 111.43 * 1000; % units in meter
l = 95.24 * 1000; % units in meter
newX = (T.Latitude - T.Latitude(1)) .* l;
newY = (T.Longtitude - T.Longtitude(1) ).*h;

newT = [newX newY T.Height];
distance = (newT(:,1).^2 + newT(:,2).^2).^(1/2);

vektor= 0:250:max(distance);

vq = interp1(distance,T.Height,vektor,'linear');

figure("Name",'Channel data interpolated');
scatter(vektor,vq, 50,vq, 'filled', 'MarkerFaceAlpha', 0.8);
title('Scatter plot of Channel Data')
xlabel('Distance (m)');
ylabel('Height (m)');

arr = [vektor', vq'];
a2t = array2table(arr);
writetable(a2t,'Interpolated.txt')


%%


figure("Name",'Channel data 3D');
scatter3(newT(:,1),newT(:,2),newT(:,3), 50,newT(:,3), 'filled', 'MarkerFaceAlpha', 0.8);
title('Scatter plot of Channel Data')
xlabel('Latitude');
ylabel('Longtitude');

figure("Name",'Channel data 2D');
scatter(newT(:,1),newT(:,2), 50,newT(:,3), 'filled', 'MarkerFaceAlpha', 0.8);
title('Scatter plot of Channel Data')
xlabel('Latitude');
ylabel('Longtitude');

figure("Name",'Channel data 2D heighy');
scatter(distance,newT(:,3), 50,newT(:,3), 'filled', 'MarkerFaceAlpha', 0.8);
title('Scatter plot of Channel Data')
xlabel('Distance');
ylabel('Height');

%%

figure("Name",'Channel data not converted');
scatter3(T.Latitude, T.Longtitude,-T.Height, 50, T.Height, 'filled', 'MarkerFaceAlpha', 0.8);
title('Scatter plot of Channel Data')
xlabel('Latitude');
ylabel('Longtitude');


% højdegrad : 111,43 km
% længdegrad : 95,24 km


