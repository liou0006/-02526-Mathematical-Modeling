clear; clc;
global stopExecution numIterations; % Global variables to control execution
stopExecution = false; % Default: continue execution
numIterations = 1; % Default: run one step at a time

% ---- User Input for Number of Iterations ----
prompt = 'How many iterations do you want to run? (Enter 0 for infinite): ';
maxIterations = input(prompt);

% Load data
T = readtable("C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\NeuralNetwork\Libian_desert_data.csv");

rotatelist =     [90,   35,     0,      30,     -10,        0,      -10, 0, 0]; % Rotation angles
biaslist =       [0,    120,    -80,    -45,    -250,       -80,    -55, 0,0]; % Bias values
activationList = [0,    1,      1,      1,      1,          1,      0, 0, 0]; % Activation function flags

fig = figure('Name', 'Neural Network Visualization', 'NumberTitle', 'off');
set(fig, 'Position', [100, 100, 1200, 500]); % Set figure size

iterationCount = 0; % Track the number of iterations

while iterationCount < numel(biaslist)
    % ✅ Check stopExecution flag before proceeding
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
        
        % Apply transformations
        bias = biaslist(iterationCount);
        rotation = rotatelist(iterationCount);

        rotatedImage = rotate_image(T, rotation);
        biasedimage = apply_bias(rotatedImage, bias);

        if activationList(iterationCount) == 1
            foldedimage = apply_activation(biasedimage, 'abs');
        else
            foldedimage = biasedimage;
        end

        T = foldedimage;

        % Find mirrored elements
        gg = foldedimage.Var1 - biasedimage.Var1;
        m_index = find(gg > 0);
        array_fold = foldedimage(m_index, :);

        clf(fig); % Clear figure for updating

        % ---- Plot Folded Image ----
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

        % ---- Plot Biased Image ----
        subplot(1, 2, 2);
        hold on;
        scatter(biasedimage.Var1, biasedimage.Var2, 1, biasedimage.Var3, 'filled', 'MarkerFaceAlpha', 0.1);
        xline(0, 'r', 'LineWidth', 1.5);
        title(sprintf('Biased Image %d', iterationCount));
        xlabel('X');
        ylabel('Y');
        axis equal;
        hold off;


    





        % ✅ If numIterations > 1, run automatically until done
        if step < numIterations
            pause(0.5); % Small delay for visualization
        end
    end

    % ✅ Show UI after running all iterations
    if iterationCount < numel(biaslist) && ~stopExecution
        controlFig = figure('Name', 'Control Iterations', 'NumberTitle', 'off', 'Position', [600, 400, 300, 120]);

        % "Continue (1 Step)" button
        uicontrol('Style', 'pushbutton', 'String', 'Continue (1 Step)', ...
            'Position', [20 60 120 40], ...
            'Callback', @(~,~) set_num_iterations(1));

        % "Run 5 Steps" button (Runs 5 more iterations)
        uicontrol('Style', 'pushbutton', 'String', 'Run 5 Steps', ...
            'Position', [160 60 120 40], ...
            'Callback', @(~,~) set_num_iterations(5));

        % "Stop Execution" button
        uicontrol('Style', 'pushbutton', 'String', 'Stop Execution', ...
            'Position', [90 10 120 40], ...
            'Callback', @(~,~) stop_execution());

        uiwait(controlFig); % Pause execution until a button is clicked
        close(controlFig); % Close button figure
    end

end

        % Find errors on the plot
biased = biasedimage;
condition = (biased.Var1 > 0 & biased.Var3 == 0) | (biased.Var1 < 0 & biased.Var3 == 1);

biased.Var3(condition) = 0.5;
% Count the number of errors
errorcount = sum(condition);
count = size(biased, 1);
percenterror = errorcount/count

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

% ✅ Function to Stop Execution
function stop_execution()
    global stopExecution;
    stopExecution = true; % Set flag to stop execution
    disp('User pressed Stop Execution. Stopping loop...');
    uiresume(gcbf); % Resume execution so the loop checks stopExecution
end

% ✅ Function to Set Number of Iterations
function set_num_iterations(value)
    global numIterations;
    numIterations = value; % Set the number of iterations to run automatically
    disp(['Running ' num2str(numIterations) ' iterations before next pause.']);
    uiresume(gcbf); % Resume execution
end
