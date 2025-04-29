function [label, score, hasPnemoniaTrain] = modelPredict(TrainFolder, Mdl)

if ~isfolder(TrainFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', TrainFolder);
    uiwait(warndlg(errorMessage));
    TrainFolder = uigetdir(); % Ask for a new one.
    if TrainFolder == 0
        % User clicked Cancel
        return;
    end
end

% Get all PNG files from the folder
extracted_Trained = fullfile(TrainFolder, '*.png');
theFiles = dir(extracted_Trained);

% Check if there are any PNG files
if isempty(theFiles)
    error('No PNG files found in the selected folder.');
end

% Initialize a cell array to hold the images
image_Array = cell(1, numel(theFiles));
image_cells_filtered = cell(1,numel(theFiles));
hasPnemoniaTrain = zeros(1,numel(theFiles))';

kernel = fspecial("gaussian",4,.5);

% Read each image
for k = 1:numel(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    image_Array{k} = imread(fullFileName);
    %image_cells_filtered{k} = imfilter(image_Array{k},kernel);
    
    [M, theta] = imgradient(image_Array{k});

    image_cells_filtered{k} = M;
%     
%     figure('Name', 'mat2gray')
%     imshow(mat2gray(M))
   
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
    ALL_ARRAY(:,k) = image_cells_filtered{k} ;
end

[label, score] = predict(Mdl, ALL_ARRAY');

end 
