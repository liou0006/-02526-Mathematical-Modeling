%%
% Specify the folder where the files live.
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";

I = 10; % how many samples you want


over_max_percent_part1 = [];
over_max_lambda_part1 = [];
for k = 1:I

lambda = linspace(0, 10, 100); % determine lambda (can also use "logspace()")
learner = "logistic"; % specify learner type to "logistic" or "svm"
[Mdl, fitinfo, ALL_ARRAY] = fitPart1(TrainFolder, lambda, learner); % create the model
[Label, Score, hasPnemoniaTest] = modelPredictPart1(TestFolder, Mdl); % test the model on test folder

% create matrix to compare the prediction and actual result
testing = zeros(size(Label, 1), size(Label, 2), 3);
testing(:,:,1) = Label;
testing(:,:,2) = repmat(hasPnemoniaTest, 1, size(Label, 2));
% Evaluate 
testing(:,:,3) = testing(:,:,1) == testing(:,:,2);
correct = sum(testing(:,:,3), 1); % determines how many the model got right
percent = (correct) / size(testing,1); % what percent the model got right

[max_percent, max_id] = max(percent);
max_lambda = lambda(max_id);
over_max_percent_part1{k} = max_percent;
over_max_lambda_part1{k} = max_lambda;


end

avg_percent_part1 = mean(cell2mat(over_max_percent_part1))
avg_lambda_part1 = mean(cell2mat(over_max_lambda_part1))





% locate which lambda achieves the best model
[max_percent, max_id] = max(percent);
max_lambda = lambda(max_id);

% plot the data to graph the trend
plot_lambda_percent(lambda, percent);

% display beta
Beta = Mdl.Beta;
betaim = reshape(Beta, length(Beta)^.5, length(Beta)^.5, length(lambda));
betaim = abs(betaim);

titleOfBeta = "Abs Value of learned weights image Part 1";

h1 = figure;
% volumeViewer(betaim) % possible to view all of beta
imshow(betaim(:, :, max_id), []);
colormap(gca);          
colorbar;
title(titleOfBeta);
saveas(gca,titleOfBeta,'png')

% clear filePatternTest filePatternTrain fullFileNameTest fullFileNameTrain baseFileNameTest baseFileNameTrain TestFolder TrainFolder

function plot_lambda_percent(lambda, percent)
plot(lambda, percent) 
xlabel("Lambda value") 
ylabel("Proportion the model predicted correct") 
title("Proportion of Pnemonia cases correctly")
end 