clear; clc; close all;

% Load data
T = readtable("C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\NeuralNetwork\Libian_desert_data.csv");

rotatelist = [90, -35, 0, 0, 0, 0, 0, 0]; % Rotation angles
biaslist = [0, -120, -300, 0, 0, 0, 0, 0]; % Bias values
activationList = [1, 1, 0, 1, 1, 0, 0, 0]; % Activation function flags

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
    title(sprintf('Folded Image (Step %d)', i));
    xlabel('X');
    ylabel('Y');
    axis equal;
    hold off;

    % ---- Plot Biased Image ----
    subplot(1, 2, 2); % Right plot
    hold on;
    scatter(biasedimage.Var1, biasedimage.Var2, 1, biasedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
    xline(0, 'r', 'LineWidth', 1.5);
    title(sprintf('Biased Image (Step %d)', i));
    xlabel('X');
    ylabel('Y');
    axis equal;
    hold off;

    % ---- UI Button to Pause Execution ----
    controlFig = figure('Name', 'Continue?', 'NumberTitle', 'off', 'Position', [600, 400, 150, 100]);
    btn = uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
        'Position', [20 20 100 40], ...
        'Callback', 'uiresume(gcbf)');

    uiwait(controlFig); % Wait for button click
    close(controlFig); % Close button figure
end
