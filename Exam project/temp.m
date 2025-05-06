TrainFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Train";
TestFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Test";


I = 10;                     % how many repeats
lambda = linspace(0,10,100);% vector of lambdas
learner = "logistic";       % or "svm"

% 1) Load & preprocess TRAIN data once
hasPnemoniaTrain = extract_posneg(TrainFolder);        % Nx1 logical
extracted_photos = extract_photos_from_folder(TrainFolder);
ALL_ARRAY_train = extracted_photos2ALL_ARRAY(extracted_photos);  
% ALL_ARRAY_train is [numFeatures x numSamples]

% 2) Fit all lambdas at once
[Mdl_all, fitinfo_all] = fitPart1(ALL_ARRAY_train, hasPnemoniaTrain, lambda, learner);

% Preallocate result arrays
over_max_percent_part1 = zeros(I,1);
over_max_lambda_part1  = zeros(I,1);

% 3) Load & preprocess TEST data once
hasPnemoniaTest = extract_posneg(TestFolder);
extracted_photosT = extract_photos_from_folder(TestFolder);
ALL_ARRAY_test = extracted_photos2ALL_ARRAY(extracted_photosT);

parfor k = 1:I   %#ok<PFIK>  % use parfor if you have the toolbox
    % 4) Score all models at once
    [LabelMat, ScoreMat] = modelPredictPart1(Mdl_all, ALL_ARRAY_test);
    % LabelMat is [numTest x numLambdas]
    
    % Compare to true labels
    correct_counts = sum(LabelMat == hasPnemoniaTest, 1);  
    percent = correct_counts ./ numel(hasPnemoniaTest);
    
    % Find best λ for this repeat
    [max_percent, id] = max(percent);
    over_max_percent_part1(k) = max_percent;
    over_max_lambda_part1(k)  = lambda(id);
end

avg_percent_part1 = mean(over_max_percent_part1);
avg_lambda_part1  = mean(over_max_lambda_part1);

% 5) Plot performance of the last run
plot_lambda_percent(lambda, percent);

% 6) Re‐train & visualize β for best λ
[max_p, bestId] = max(percent);
bestLambda = lambda(bestId);
[Mdl_best, fitinfo_best] = fitPart1(ALL_ARRAY_train, hasPnemoniaTrain, bestLambda, learner);
Beta = Mdl_best.Beta;
side = sqrt(numel(Beta));
betaim = abs(reshape(Beta, side, side));

figure;
imshow(betaim, []);
colormap(gca);
colorbar;
title("Abs Value of learned weights for the best lambda image Part 1");
saveas(gcf, "Abs_Value_of_learned_weights_for_the_best_lambda_image_Part_1.png");


function plot_lambda_percent(lambda, percent)
plot(lambda, percent)
xlabel("Lambda value")
ylabel("Proportion the model predicted correct")
title("Proportion of Pnemonia cases correctly")
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

