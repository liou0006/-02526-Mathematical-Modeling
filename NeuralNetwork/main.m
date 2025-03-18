clear; clc; close all;
global stopExecution numIterations;
stopExecution = false;
numIterations = 1;

% Load data
T = readtable("Libian_desert_data.csv");
rotatelist =     [90,   35,     0,      30,     -10,        0,      -10,    -45]; % Rotation angles
biaslist =       [0,    120,    -80,    -45,    -250,       -80,    -55,    0]; % Bias values
activationList = [0,    1,      1,      1,      1,          1,      1,      1]; % Activation function flags

prompt = 'How many iterations do you want to run? (Enter 0 for infinite): ';
maxIterations = input(prompt);

if maxIterations == 0
    % interpret "0 for infinite" as "go until the end"
    maxIterations = numel(biaslist); 
    numIterations = maxIterations;  % So we actually use the prompt

end

fig = figure('Name', 'Neural Network Visualization', 'NumberTitle', 'off');
set(fig, 'Position', [100, 100, 1200, 500]); % Set figure size

iterationCount = 0;
t0 = tic;

while iterationCount < numel(biaslist)
    if stopExecution
        disp('Execution stopped by user.');
        close all; % Close all figures before exiting
        break;
    end

    for step = 1:numIterations
        iterationCount = iterationCount + 1;
        if iterationCount > numel(biaslist)
            disp('Reached end of iterations.');
            break;
        end

        bias = biaslist(iterationCount);
        rotation = rotatelist(iterationCount);

        rotatedImage = rotate_image(T, rotation);
        biasedimage = apply_bias(rotatedImage, bias);

        if activationList(iterationCount) == 1
            foldedimage = apply_activation(biasedimage, 'relu');
        else
            foldedimage = biasedimage;
        end

        T = foldedimage;

        % Mirrored elements
        gg = foldedimage.Var1 - biasedimage.Var1;
        m_index = find(gg > 0);
        array_fold = foldedimage(m_index, :);

        clf(fig); % Clear figure for updating

        subplot(1, 2, 1);
        hold on;
        scatter(foldedimage.Var1, foldedimage.Var2, 1, foldedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
        scatter(array_fold.Var1, array_fold.Var2, 1, array_fold.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
        xline(0, 'r', 'LineWidth', 1.5);
        title(sprintf('Folded Image %d', iterationCount));
        xlabel('X');
        ylabel('Y');
        axis equal;
        hold off;

        subplot(1, 2, 2);
        hold on;
        scatter(biasedimage.Var1, biasedimage.Var2, 1, biasedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
        xline(0, 'r', 'LineWidth', 1.5);
        title(sprintf('Biased Image %d', iterationCount));
        xlabel('X');
        ylabel('Y');
        axis equal;
        hold off;

        drawnow;

        % Pause before next figure
        while toc(t0) < 0.2
            drawnow;        % process any UI events
            if stopExecution
                break;
            end
        end

        if step == 3
            saveas(fig,'NeuralNetwork Layer 3','png');
        end
    end

    if stopExecution
        disp('Breaking the while-loop due to user stop.');
        break;
    end


if iterationCount < numel(biaslist) && ~stopExecution
    controlFig = figure('Name', 'Control Iterations', ...
        'NumberTitle', 'off', 'Position', [600, 400, 300, 120]);

    % "Continue (1 Step)" button
    uicontrol('Style', 'pushbutton', 'String', 'Continue (1 Step)', ...
        'Position', [20 60 120 40], ...
        'Callback', @(~,~) set_num_iterations(1));

    % "Run desired steps" button
    uicontrol('Style', 'pushbutton', 'String', sprintf('Run %d Steps', maxIterations), ...
        'Position', [160 60 120 40], ...
        'Callback', @(~,~) set_num_iterations(maxIterations));

    % "Stop Execution" button
    uicontrol('Style', 'pushbutton', 'String', 'Stop Execution', ...
        'Position', [20 10 120 40], ...
        'Callback', @(~,~) stop_execution());

    % "Run to End" button
    remaining = numel(biaslist) - iterationCount;
    uicontrol('Style', 'pushbutton', 'String', 'Run to End', ...
        'Position', [160 10 120 40], ...
        'Callback', @(~,~) set_num_iterations(remaining));

    uiwait(controlFig); % Pause execution until a button is clicked
    close(controlFig);  % Close button figure
end

end


% Error plot function
errorPlot(T, -100,55);


% Function to Stop Execution
function stop_execution()
global stopExecution;
stopExecution = true; % Set flag to stop execution
disp('User pressed Stop Execution. Stopping loop...');
uiresume(gcbf); % Resume execution so the loop checks stopExecution
end

function set_num_iterations(value)
% global numIterations;
numIterations = value; % Set the number of iterations to run automatically
disp(['Running ' num2str(numIterations) ' iterations before next pause.']);
uiresume(gcbf); % Resume execution
end

function errorPlot(T,rotation, bias)
%%%%%%%%%% Final Rotation and Translation to find the error
rotatedImage = rotate_image(T, rotation);
biasedimage = apply_bias(rotatedImage, bias);

biased = biasedimage;
condition = (biased.Var1 > 0 & biased.Var3 == 0) | (biased.Var1 < 0 & biased.Var3 == 1);

biased.Var3(condition) = 0.5;
errorcount = sum(condition);
count = size(biased, 1);
percenterror = errorcount/count*100;
disp('Error percent: ')
disp(percenterror);

writetable(biased,'LiouReluBiasedTable');

errorPlotfig = figure();
hold on;
title('Error Plot');
scatter(biased.Var1, biased.Var2,1, biased.Var3, 'filled', 'MarkerFaceAlpha', 0.5);
xline(0, 'r', 'LineWidth', 1);
title(sprintf('Final Image'));
xlabel('X');
ylabel('Y');
axis equal;
hold off;
saveas(errorPlotfig,'ErrorPlotLiouRelu','png')
end

