
function [Mdl, fitinfo, mu, sigma] = fitPart2(TrainFolder, lambda, learner)

hasPnemoniaTrain = extract_posneg(TrainFolder);
extracted_photos = extract_photos_from_folder(TrainFolder);
[ext_mag_gradient, ~] = cellfun(@(img) imgradient(img), ...
    extracted_photos, UniformOutput=false);
ALL_ARRAY = extracted_photos2ALL_ARRAY(ext_mag_gradient);


% create normalized ALL_ARRAY
mu = mean(ALL_ARRAY, 2);     % Mean for each feature (row-wise)
sigma = std(ALL_ARRAY, 0, 2); % Std dev for each feature
sigma(sigma == 0) = 1;       % Prevent division by zero

% normalized ARRAY
ALL_ARRAY_norm = (ALL_ARRAY - mu) ./ sigma;

[Mdl,fitinfo] = fitclinear(ALL_ARRAY_norm', hasPnemoniaTrain , ...
    "ObservationsIn","rows", ...
    "Regularization",'ridge', ...
    "Lambda", lambda, ...
    "Learner", learner); 

end


% turns the Testfolder to a (elements in photo x num of photos matrix)
function ALL_ARRAY = folder2ALL_ARRAY(TestFolder) 
extracted_photos = extract_photos_from_folder(TestFolder);
flattened = cellfun(@(img) (reshape(img, 1,[] )'), extracted_photos, UniformOutput=false);
ALL_ARRAY = double(cat(2, flattened{:}));
end

% turns the extracted_photos to a (elements in photo x num of photos matrix)
function ALL_ARRAY = extracted_photos2ALL_ARRAY(extracted_photos)
flattened = cellfun(@(img) (reshape(img, 1,[] )'), extracted_photos, UniformOutput=false);
ALL_ARRAY = double(cat(2, flattened{:}));
end

% extracted_photos takes the folder path and spits out the raw image data
% returns a cell with number of photos by 1. 
% each cell is the photos pixels
function extracted_photos = extract_photos_from_folder(folderpath)
Testing_photos = dir(fullfile(folderpath,'*.png'));
Testing_photos_name = {Testing_photos.name}';
test_pre_rawimage = fullfile({Testing_photos.folder}', Testing_photos_name);
extracted_photos = cellfun(@imread, test_pre_rawimage, 'UniformOutput', false);
end

% extracted_photos takes the folder path and spits out a matrix of 1 or 0
% matrix is number of photos by 1
function extracted_posneg = extract_posneg(folderpath)
Testing_photos = dir(fullfile(folderpath,'*.png'));
Testing_photos_name = {Testing_photos.name}';
extracted_posneg = contains(Testing_photos_name, "positive");
end
