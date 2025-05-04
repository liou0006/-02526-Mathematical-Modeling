%%
% Specify the folder where the files live.
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";

lambda = linspace(0, 1, 200); % determine lambda
[Mdl, fitinfo, ALL_ARRAY] = fitPart1(TrainFolder,lambda); % create the model
[Label, Score, hasPnemoniaTest] = modelPredictPart1(TestFolder, Mdl); % test the model on test folder

% create matrix to compare the prediction and actual result
testing = zeros(size(Label,1), size(Label,2), 3);
testing(:,:,1) = Label;
testing(:,:,2) = repmat(hasPnemoniaTest, 1, size(Label,2));
% Evaluate 
testing(:,:,3) = testing(:,:,1) == testing(:,:,2);

correct = sum(testing(:,:,3), 1); % determines how many the model got right
percent = (correct) / size(testing,1); % what percent the model got right

Beta = Mdl.Beta;
betaim = reshape(Beta,224,224,length(lambda));
betaim = abs(betaim);

titleOfBeta = "Abs Value of learned weights image";

h1 = figure;
imshow(betaim(:, :, 1), []);
colormap(gca);          
colorbar;
title(titleOfBeta);
saveas(gca,titleOfBeta,'png')

% clear filePatternTest filePatternTrain fullFileNameTest fullFileNameTrain baseFileNameTest baseFileNameTrain TestFolder TrainFolder
