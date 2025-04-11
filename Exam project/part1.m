
clear; clc;
% Specify the folder where the files live.
TrainFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Train";
TestFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Test";

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(TrainFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', TrainFolder);
    uiwait(warndlg(errorMessage));
    TrainFolder = uigetdir(); % Ask for a new one.
    if TrainFolder == 0
        % User clicked Cancel
        return;
    end
end

% Get a list of all files in the folder with the desired file name pattern.
filePatternTrain = fullfile(TrainFolder, '*.png'); % Change to whatever pattern you need.
theFilesTrain = dir(filePatternTrain);
% for k = 1 : length(theFiles)

% Get a list of all files in the folder with the desired file name pattern.
filePatternTest = fullfile(TestFolder, '*.png'); % Change to whatever pattern you need.
theFilesTest = dir(filePatternTest);



fileSize = 200;
% fileSize = length(theFilesTrain);

ArrayTrain = zeros(224*224,fileSize);
ArrayTest = zeros(224*224,fileSize);
hasPnemoniaTrain = zeros(1,fileSize);
hasPnemoniaTest = zeros(1,fileSize);
resultTable = zeros(fileSize,5);


for k = 1 : fileSize
    baseFileNameTrain = theFilesTrain(k).name;
    fullFileNameTrain = fullfile(theFilesTrain(k).folder, baseFileNameTrain);

    imageArrayTrain = imread(fullFileNameTrain);

    imageArrayTrain = reshape(imageArrayTrain,[],1);

    ArrayTrain(:,k) = imageArrayTrain;

    if (contains(fullFileNameTrain,"positive"))
        hasPnemoniaTrain(:,k) = 1;
    else
        hasPnemoniaTrain(:,k) = 0;
    end


    baseFileNameTest = theFilesTest(k).name;
    fullFileNameTest = fullfile(theFilesTest(k).folder,baseFileNameTest);

    imageArrayTest = imread(fullFileNameTest);

    imageArrayTest = reshape(imageArrayTest,[],1);

    ArrayTest(:,k) = imageArrayTest;

    if (contains(fullFileNameTest,"positive"))
        hasPnemoniaTest(:,k) = 1;
    else
        hasPnemoniaTest(:,k) = 0;
    end

    % imshow(imageArray);  % Display image.
    % drawnow; % Force display to update immediately.

end

Mdl = fitclinear(ArrayTrain(1:fileSize,:),hasPnemoniaTrain,"ObservationsIn","columns", "Regularization","ridge","Lambda",1.5, "Bias", 0,"Learner","logistic");
[Label, Score] = predict(Mdl,ArrayTest(1:fileSize,:));
hasPnemoniaTest = hasPnemoniaTest';


resultTable(:,1) = Label;
resultTable(:,2) = hasPnemoniaTest;
resultTable(:,4) = Score(:,1);
resultTable(:,5) = Score(:,2);

for k = 1:fileSize
    if resultTable(k,1) == resultTable(k,2)
        resultTable(k,3) = 1;
    else
        resultTable(k,3) = 0;
    end
end

disp(sum(resultTable(:,3)));
disp((sum(resultTable(:,3))/fileSize)*100);

clear filePatternTest filePatternTrain fullFileNameTest fullFileNameTrain baseFileNameTest baseFileNameTrain TestFolder TrainFolder
