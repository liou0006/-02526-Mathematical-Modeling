
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";


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
image_array_filtered = cell(1,numel(theFiles));

kernel = fspecial("gaussian",4,.5);

% Read each image
for k = 1:numel(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    image_Array{k} = imread(fullFileName);
    image_array_filtered{k} = imfilter(image_Array{k},kernel)

end
for k = 1:numel(image_array_filtered)
    image_array_filtered{k} = reshape(image_array_filtered{k},[],1)
end
