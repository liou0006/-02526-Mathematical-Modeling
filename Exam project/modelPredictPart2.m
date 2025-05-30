function [label, score, hasPnemoniaTest] = modelPredictPart2(TestFolder, Mdl, mu, sigma)

hasPnemoniaTest = extract_posneg(TestFolder);
extracted_photos = extract_photos_from_folder(TestFolder);
[ext_mag_gradient, ~] = cellfun(@(img) imgradient(img), ...
    extracted_photos, UniformOutput=false);
ALL_ARRAY = extracted_photos2ALL_ARRAY(ext_mag_gradient);

% create normalized ALL_ARRAY
ALL_ARRAY_test_norm = (ALL_ARRAY - mu) ./ sigma;

[label, score] = predict(Mdl, ALL_ARRAY_test_norm');

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