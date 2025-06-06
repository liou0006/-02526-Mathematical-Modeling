
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";

% extracting data from folders
train_hasPne = extract_posneg(TrainFolder);
train_raw_image = extract_photos_from_folder(TrainFolder);

test_hasPne = extract_posneg(TestFolder);
test_raw_image = extract_photos_from_folder(TestFolder);


% Feature extraction using histogram of gradients
numBins = 18;
patchSize = 32;
numPatches = (224 / patchSize)^2;
featureLength = numPatches * numBins;

% Creating the usable array for the model 
train_ARRAY_cell = cellfun(@(img) (computeOrientationHistogram(img, patchSize, numBins))', ...
    train_raw_image, UniformOutput=false);
train_ALL_ARRAY = cell2mat(train_ARRAY_cell');

[test_ARRAY_cell] = cellfun(@(img) (computeOrientationHistogram(img, patchSize, numBins))', ...
    test_raw_image, UniformOutput=false);
test_ALL_ARRAY = cell2mat(test_ARRAY_cell');



I = 10; % how many samples you want

over_max_percent_part3 = [];
over_max_lambda_part3 = [];
for k = 1:I
% Train Linear Classifier
lambda = logspace(-2,1,500);
[Mdl, fitinfo] = fitclinear(train_ALL_ARRAY', train_hasPne, ...
    "ObservationsIn", "rows", ...
    "Regularization", "ridge", ...
    "Lambda", lambda, ...
    "Learner","logistic");

% Predict on Training Data
[Label, score] = predict(Mdl, test_ALL_ARRAY');

% Create matrix to compare the prediction and actual result
testing = zeros(size(Label,1), size(Label,2), 3);
testing(:,:,1) = Label;
testing(:,:,2) = repmat(test_hasPne, 1, size(Label,2));
% Evaluate 
testing(:,:,3) = testing(:,:,1) == testing(:,:,2);
correct = sum(testing(:,:,3), 1); % determines how many the model got right
percent = (correct) / size(testing,1); % what percent the model got right

% locate which lambda achieves the best model
[max_percent, max_id] = max(percent);
max_lambda = lambda(max_id);
over_max_percent_part3{k} = max_percent;
over_max_lambda_part3{k} = max_lambda;

end

avg_percent_part3 = mean(cell2mat(over_max_percent_part3))
avg_lambda_part3 = mean(cell2mat(over_max_lambda_part3))

% display beta
Beta = Mdl.Beta;
betaim = reshape(Beta, numBins, numPatches, length(lambda));
spatial_weight_map = mean(betaim , 1);            % Size: [1 × 49]
spatial_map_2D = reshape(spatial_weight_map, 224 / patchSize, 224 / patchSize, length(lambda)); % Size: [7 × 7]

normalized_map = spatial_map_2D(:,:,max_id) / max(abs(spatial_map_2D(:)));
imagesc(normalized_map);
colorbar;
title("Patch-wise β Magnitude");


%%%%%%%%%% turns the extracted_photos to a (elements in photo x num of photos matrix)
function ALL_ARRAY = extracted_photos2ALL_ARRAY(extracted_photos)
flattened = cellfun(@(img) (reshape(img, 1,[] )'), extracted_photos, UniformOutput=false);
ALL_ARRAY = double(cat(2, flattened{:}));
end

%%%%%%%%%% extracted_photos takes the folder path and spits out the raw image data
%%%%%%%%%% returns a cell with number of photos by 1. 
%%%%%%%%%% each cell is the photos pixels
function extracted_photos = extract_photos_from_folder(folderpath)
Testing_photos = dir(fullfile(folderpath,'*.png'));
Testing_photos_name = {Testing_photos.name}';
test_pre_rawimage = fullfile({Testing_photos.folder}', Testing_photos_name);
extracted_photos = cellfun(@imread, test_pre_rawimage, 'UniformOutput', false);
end

%%%%%%%%%% extracted_photos takes the folder path and spits out a matrix of 1 or 0
%%%%%%%%%% matrix is number of photos by 1
function extracted_posneg = extract_posneg(folderpath)
Testing_photos = dir(fullfile(folderpath,'*.png'));
Testing_photos_name = {Testing_photos.name}';
extracted_posneg = contains(Testing_photos_name, "positive");
end


%%%%%%%%%% Create a function to calculate
function [featureVector,histVals] = computeOrientationHistogram(image, patchSize, numBins)
% Find magnitude and direction
[M, theta] = imgradient(image);

% Make sure that direction is between 0 and 180 deg.
% theta(theta < 0) = theta(theta < 0) + 180;

% Set up bin edges according to what was specified in the assignment
% (numBins = 18)...
binEdges = linspace(-180, 180, numBins + 1);
featureVector = [];

for row = 1:patchSize:size(image,1)
    for col = 1:patchSize:size(image,2)
        %rowEnd = min(row + patchSize - 1, size(image,1));
        %colEnd = min(col + patchSize - 1, size(image,2));
        rowEnd = (row + patchSize - 1);
        colEnd = (col + patchSize - 1);

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

