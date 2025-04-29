
function [Mdl, fitinfo] = fit(TrainFolder)

filePatternTest = fullfile(TrainFolder, '*.png');
theFiles = dir(filePatternTest);

image_Array = cell(1, numel(theFiles));
image_cells_filtered = cell(1,numel(theFiles));
hasPnemoniaTrain = zeros(1,numel(theFiles))';

% Read each image
for k = 1:numel(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    image_Array{k} = imread(fullFileName);

    [M, theta] = imgradient(image_Array{k});

    image_cells_filtered{k} = M;

    % figure('Name', 'mat2gray')
    % imshow(mat2gray(M))

    if (contains(baseFileName,"positive"))
        % fprintf(1, 'Now reading %s\n', fullFileName);
        hasPnemoniaTrain(k) = 1;
    else
        hasPnemoniaTrain(k) = 0;
    end

end

ALL_ARRAY = zeros(length(image_cells_filtered{1})^2,length(image_cells_filtered));

% creates cells with 1-column vectors
for k = 1:numel(image_cells_filtered)

    image_cells_filtered{k} = reshape(image_cells_filtered{k},[],1);
    ALL_ARRAY(:,k) = image_cells_filtered{k};

end

[Mdl,fitinfo] = fitclinear(ALL_ARRAY', hasPnemoniaTrain , "ObservationsIn","rows","Regularization",'ridge', 'Lambda','auto');

end
