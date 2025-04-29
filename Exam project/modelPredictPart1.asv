function [label, score, hasPnemoniaTest] = modelPredictPart1(TestFolder, Mdl)

filePatternTest = fullfile(TestFolder, '*.png');
theFiles = dir(filePatternTest);

image_Array = cell(1, numel(theFiles));
hasPnemoniaTest = zeros(1,numel(theFiles))';

% Read each image
for k = 1:numel(theFiles)

    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    image_Array{k} = imread(fullFileName);

    if (contains(baseFileName,"positive"))
        % fprintf(1, 'Now reading %s\n', fullFileName);
        hasPnemoniaTest(k) = 1;
    else
        hasPnemoniaTest(k) = 0;
    end

end

ALL_ARRAY = zeros(length(image_Array{1})^2,length(image_Array));

% creates cells with 1-column vectors
for k = 1:numel(image_Array)

    image_Array{k} = reshape(image_Array{k},[],1);
    ALL_ARRAY(:,k) = image_Array{k};

end

[label, score] = predict(Mdl, ALL_ARRAY');

end