clear; clc; close all;

% Load data
original = readtable("Libian_desert_data.csv");
T = original;
rotatelist = [90, -16, 0 , 0  , 0, -30, -30 , 0 , 1,  0, 0 , 52,0,50, 60,  0,  0  ,0,-15,0  ,-40,-40,-10,-60,0,20  ,10 , 10,0]; % Rotation angles
biaslist = [20, -60,  -15,-10, -10, -40, -20,-15, -20,-7,-3, 8,-55,-20,160,-48,-24,0,-64,-45,-60,-50,-22,30,-10,-25,0,-10,-12]; % Bias values
activationList = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]; % Activation function flags
length(rotatelist);
length(biaslist);
length(activationList);
% Create a single figure for subplots
fig = figure('Name', 'Neural Network Visualization', 'NumberTitle', 'off');
set(fig, 'Position', [100, 100, 1200, 500]); % Set figure size

for i = 1:numel(biaslist)

    % Apply transformations
    bias = biaslist(i);
    rotation = rotatelist(i);
    
    rotatedImage = rotate_image(T, rotation);
    biasedimage = apply_bias(rotatedImage, bias);
    
    if activationList(i) == 1
        foldedimage = apply_activation(biasedimage, 'abs');
    else
        foldedimage = biasedimage;
    end

    T = foldedimage;

    % Find mirrored elements
    gg = foldedimage.Var1 - biasedimage.Var1;
    m_index = find(gg > 0);
    array_fold = foldedimage(m_index, :);

    % Clear previous plots but keep figure open
    clf(fig);

    % ---- Plot Folded Image ----
    subplot(1, 2, 1); % Left plot
    hold on;
    scatter(foldedimage.Var1, foldedimage.Var2, 1, foldedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
    scatter(array_fold.Var1, array_fold.Var2, 1, array_fold.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
    xline(0, 'r', 'LineWidth', 1.5);
    title(sprintf('Folded Image %d', i));
    xlabel('X');
    ylabel('Y');
    axis equal;
    hold off;

    % ---- Plot Biased Image ----
    subplot(1, 2, 2); % Right plot
    hold on;
    scatter(biasedimage.Var1, biasedimage.Var2, 1, biasedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
    xline(0, 'r', 'LineWidth', 1.5);
    title(sprintf('Biased Image %d', i));
    xlabel('X');
    ylabel('Y');
    axis equal;
    hold off;
    % 
    % % ---- UI Button to Pause Execution ----
    % controlFig = figure('Name', 'Continue?', 'NumberTitle', 'off', 'Position', [600, 400, 150, 100]);
    % btn = uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
    %     'Position', [20 20 100 40], ...
    %     'Callback', 'uiresume(gcbf)');
    % 
    % uiwait(controlFig); % Wait for button click
    % close(controlFig); % Close button figure
end


%%%%%%%%%% Final Rotation and Translation to find the error
rotatedImage = rotate_image(T, -70);
biasedimage = apply_bias(rotatedImage, 0);


% Find errors on the plot

biased = biasedimage;
condition = (biased.Var1 > 0 & biased.Var3 == 0) | (biased.Var1 < 0 & biased.Var3 == 1);

biased.Var3(condition) = 0.5;
% Count the number of errors
errorcount = sum(condition);
count = size(biased, 1);
percenterror = errorcount/count;

figure(); % Error plot
hold on;
title('Error Plot');
scatter(biased.Var1, biased.Var2,1, biased.Var3, 'filled', 'MarkerFaceAlpha', 0.5);
xline(0, 'r', 'LineWidth', 1);
title(sprintf('Final Image'));
xlabel('X');
ylabel('Y');
axis equal;
hold off;

