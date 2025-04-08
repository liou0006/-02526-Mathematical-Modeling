
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


fileSize = 200;
% A = cell(224*224,3);
ArrayTrain = zeros(224*224,fileSize);
ArrayTest = zeros(224*224,fileSize);
hasPnemoniaTrain = zeros(1,fileSize);
hasPnemoniaTest = zeros(1,fileSize);
masterchief1 = zeros(fileSize,3);

% Get a list of all files in the folder with the desired file name pattern.
c% for k = 1 : length(theFiles)

% Get a list of all files in the folder with the desired file name pattern.
filePatternTest = fullfile(TestFolder, '*.png'); % Change to whatever pattern you need.
theFilesTest = dir(filePatternTest);


for k = 1 : fileSize
    baseFileNameTrain = theFilesTrain(k).name;
    fullFileNameTrain = fullfile(theFilesTrain(k).folder, baseFileNameTrain);

    imageArrayTrain = imread(fullFileNameTrain);

    imageArrayTrain = reshape(imageArrayTrain,[],1);

    ArrayTrain(:,k) = imageArrayTrain;


    if (contains(fullFileNameTrain,"positive"))
        % fprintf(1, 'Now reading %s\n', fullFileName);
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
        % fprintf(1, 'Now reading %s\n', fullFileName);
        hasPnemoniaTest(:,k) = 1;
    else
        hasPnemoniaTest(:,k) = 0;
    end


    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()

    % imshow(imageArray);  % Display image.
    % drawnow; % Force display to update immediately.


end


Mdl = fitclinear(ArrayTrain(1:fileSize,:),hasPnemoniaTrain,"Regularization","ridge","Lambda",1.5, "Bias", 0);
[Label, Score] = predict(Mdl,ArrayTest(1:fileSize,:));

hasPnemoniaTest = hasPnemoniaTest';

masterchief1(:,1) = Label;
masterchief1(:,2) = hasPnemoniaTest;

for k = 1:fileSize
    if masterchief1(k,1) == masterchief1(k,2)
        masterchief1(k,3) = 1;
    else
        masterchief1(k,3) = 0;
    end
end

disp(sum(masterchief1(:,3)));
disp((sum(masterchief1(:,3))/fileSize)*100);
