TrainFolder = "C:\Users\oscar\OneDrive - Danmarks Tekniske Universitet\Skrivebord\Bachelor\Train";
TestFolder = "C:\Users\oscar\OneDrive - Danmarks Tekniske Universitet\Skrivebord\Bachelor\Test";

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

if isempty(theFiles)
    error('No PNG files found in the selected folder.');
end

image_cells_filtered = cell(1, numel(theFiles));
hasPnemoniaTrain = zeros(numel(theFiles), 1);
kernel = fspecial("gaussian", 8, 0.5);

% Read and filter images
for k = 1:numel(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    rawImage = imread(fullFileName);
    image_cells_filtered{k} = imfilter(rawImage, kernel);

%     figure(1);
%     subplot(1,2,1);
%     imshow(rawImage, []);
%     title(sprintf('Original Image #%d', k));
% 
%     subplot(1,2,2);
%     imshow(image_cells_filtered{k}, []);
%     title(sprintf('Filtered Image #%d', k));


    if contains(baseFileName, "positive")
        hasPnemoniaTrain(k) = 1;
    else
        hasPnemoniaTrain(k) = 0;
    end
end

% Feature extraction using histogram of gradients
numBins = 18;
patchSize = 32;
numPatches = (224 / patchSize)^2;
featureLength = numPatches * numBins;
ALL_ARRAY = zeros(featureLength, numel(image_cells_filtered));

for k = 1:numel(image_cells_filtered)
    featureVector = computeOrientationHistogram(image_cells_filtered{k}, patchSize, numBins);
    ALL_ARRAY(:, k) = featureVector';
end

% Train Linear Classifier
[Mdl, fitinfo] = fitclinear(ALL_ARRAY', hasPnemoniaTrain, ...
    "ObservationsIn", "rows", ...
    "Regularization", "ridge", ...
    "Lambda", "auto");

% Predict on Training Data
[label, score] = predict(Mdl, ALL_ARRAY');
testing(:,1) = label;
testing(:,2) = hasPnemoniaTrain;

% Evaluate
for k = 1:numel(theFiles)
    testing(k,3) = double(testing(k,1) == testing(k,2));
end

disp(sum(testing(:,3)));
disp((sum(testing(:,3)) / numel(theFiles)) * 100);

% Create a function to calculate

function featureVector = computeOrientationHistogram(image, patchSize, numBins)
[Gx, Gy] = imgradientxy(image, 'sobel');

% Find magnitude and direction
[M, theta] = imgradient(image);

% Make sure that direction is between 0 and 180 deg.
theta(theta < 0) = theta(theta < 0) + 180;

% After computing Gx, Gy, M, theta
figure;

subplot(2,2,1);
imshow(image, []);
title('Filtered Input Image');

subplot(2,2,2);
imshow(mat2gray(M)); % Magnitude visualization
title('Gradient Magnitude');

subplot(2,2,3);
imshow(mat2gray(theta / 180)); % Orientation normalized to [0,1]
title('Gradient Orientation');

subplot(2,2,4);
quiver(Gx, Gy);
axis tight;
title('Gradient Vectors');

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
