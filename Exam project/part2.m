clear percent titleOfBeta testing  lambda ; close all;
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";


I = 10; % how many samples you want

over_max_percent_part2 = [];
over_max_lambda_part2 = [];
for k = 1:I

lambda = logspace(-2, 3, 100); % determine lambda (can also use "logspace()")
learner = "logistic"; % specify learner type   to "logistic" or "svm"
[Mdl, fitinfo, mu, sigma] = fitPart2(TrainFolder, lambda, learner); % create the model
[Label, Score, hasPnemoniaTest] = modelPredictPart2(TestFolder, Mdl, mu, sigma); % test the model on test folder

% create matrix to compare the prediction and actual result
testing = zeros(size(Label, 1), size(Label, 2), 3);
testing(:,:,1) = Label;
testing(:,:,2) = repmat(hasPnemoniaTest, 1, size(Label, 2));
% Evaluate 
testing(:,:,3) = testing(:,:,1) == testing(:,:,2);
correct = sum(testing(:,:,3), 1); % determines how many the model got right
percent = (correct) / size(testing,1); % what percent the model got right


% locate which lambda achieves the best model
[max_percent, max_id] = max(percent);
max_lambda = lambda(max_id);
over_max_percent_part2{k} = max_percent;
over_max_lambda_part2{k} = max_lambda;

end
% display average values 
avg_percent_part2 = mean(cell2mat(over_max_percent_part2))
avg_lambda_part2 = mean(cell2mat(over_max_lambda_part2))

% plot the data to graph the trend
plot_lambda_percent(lambda, percent);

% display beta
Beta = Mdl.Beta;
betaim = reshape(Beta, length(Beta)^.5, length(Beta)^.5, length(lambda));
betaim = abs(betaim);

titleOfBeta = "Display of the learned weights from gradient model";

h1 = figure();
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
title("Part 2: Proportion of Pnemonia cases predicted correctly")
end 

