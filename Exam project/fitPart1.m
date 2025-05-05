function [Mdl, fitinfo] = fitPart1(TrainFolder,lambda)

filePatternTest = fullfile(TrainFolder, '*.png');
theFiles = dir(filePatternTest);

image_Array = cell(1, numel(theFiles));
hasPnemoniaTrain = zeros(1,numel(theFiles))';

% Read each image
for k = 1:numel(theFiles)

    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    image_Array{k} = imread(fullFileName);

    if (contains(baseFileName,"positive"))
        % fprintf(1, 'Now reading %s\n', fullFileName);
        hasPnemoniaTrain(k) = 1;
    else
        hasPnemoniaTrain(k) = 0;
    end

end

ALL_ARRAY = zeros(length(image_Array{1})^2,length(image_Array));

% creates cells with 1-column vectors
for k = 1:numel(image_Array)

    image_Array{k} = reshape(image_Array{k},[],1);
    ALL_ARRAY(:,k) = image_Array{k};

end

[Mdl,fitinfo] = fitclinear(ALL_ARRAY', hasPnemoniaTrain , ...
    "ObservationsIn","rows", ...
    "Regularization",'ridge', ...
    "Learner","logistic",...
    'Lambda',lambda);

end