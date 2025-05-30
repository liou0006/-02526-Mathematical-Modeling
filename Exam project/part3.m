% TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
% TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";
% %

TrainFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Train";
TestFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Test";


if ~isfolder(TrainFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', TrainFolder);
    uiwait(warndlg(errorMessage));
    TrainFolder = uigetdir(); % Ask for a new one.
    if TrainFolder == 0
        return;
    end
end

% Get all PNG files from the folder
extracted_Trained = fullfile(TrainFolder, '*.png');
theFiles = dir(extracted_Trained);                                     

filePatternTest = fullfile(TestFolder, '*.png'); % Change to whatever pattern you need.
theFilesTest = dir(filePatternTest);

if isempty(theFiles)
    error('No PNG files found in the selected folder.');
end

image_cells_filtered = cell(1, numel(theFiles));
hasPnemoniaTrain = zeros(numel(theFiles), 1);
kernel = fspecial("gaussian", 4, 0.5);

% Read and filter images
for k = 1:numel(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    rawImage = imread(fullFileName);
    image_cells_filtered{k} = imfilter(rawImage, kernel);

    if contains(baseFileName, "positive")
        hasPnemoniaTrain(k) = 1;
    else
        hasPnemoniaTrain(k) = 0;
    end

    baseFileNameTest = theFilesTest(k).name;
    fullFileNameTest = fullfile(theFilesTest(k).folder,baseFileNameTest);
    imageArrayTest = imread(fullFileNameTest);
    imageArrayTest = reshape(imageArrayTest,1,[]);
    ArrayTest(:,k) = imageArrayTest;
    if (contains(fullFileNameTest,"positive"))
        hasPnemoniaTest(:,k) = 1;
    else
        hasPnemoniaTest(:,k) = 0;
    end

end

% Feature extraction using histogram of gradients
numBins = 18;
patchSize = 32;
numPatches = (224 / patchSize)^2;
featureLength = numPatches * numBins;
ALL_ARRAY = zeros(featureLength, numel(image_cells_filtered));

histTest = zeros(featureLength, numel(image_cells_filtered));

for k = 1:numel(image_cells_filtered)
    featureVector = computeOrientationHistogram(image_cells_filtered{k}, patchSize, numBins);
    ALL_ARRAY(:, k) = featureVector';
    histTest(:,k) = featureVector';
end

% Train Linear Classifier
[Mdl, fitinfo] = fitclinear(ALL_ARRAY', hasPnemoniaTrain', ...
    "ObservationsIn", "rows", ...
    "Regularization", "ridge", ...
    "Lambda", "auto");

% Predict on Training Data
[label, score] = predict(Mdl, histTest');
testing(:,1) = label;
testing(:,2) = hasPnemoniaTrain;

% Evaluate
for k = 1:numel(theFiles)
    testing(k,3) = double(testing(k,1) == testing(k,2));
end

disp(sum(testing(:,3)));
disp((sum(testing(:,3)) / numel(theFiles)) * 100);

writeToTable(testing,2);



% Create a function to calculate 

function featureVector = computeOrientationHistogram(image, patchSize, numBins)
    % Find magnitude and direction
    [M, theta] = imgradient(image);

    % Make sure that direction is between 0 and 180 deg.
    theta(theta < 0) = theta(theta < 0) + 180;  

    % Set up bin edges according to what was specified in the assignment
    % (numBins = 18)... 
    binEdges = linspace(0, 180, numBins + 1);
    featureVector = [];

    for row = 1:patchSize:size(image,1)
        for col = 1:patchSize:size(image,2)
            rowEnd = min(row + patchSize - 1, size(image,1));
            colEnd = min(col + patchSize - 1, size(image,2));
            patchTheta = theta(row:rowEnd, col:colEnd);
            patchMag = M(row:rowEnd, col:colEnd);

            histVals = zeros(1, numBins);
            for bin = 1:numBins
                mask = (patchTheta >= binEdges(bin)) & (patchTheta < binEdges(bin + 1));
                histVals(bin) = sum(patchMag(mask));
            end

            % Normalize
            if norm(histVals) > 0
                histVals = histVals / norm(histVals);
            end

            featureVector = [featureVector, histVals];
        end
    end
end
