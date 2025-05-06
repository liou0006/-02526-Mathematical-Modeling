function [Mdl, fitinfo] = fitPart1(TrainFolder, lambda)
  persistent cachedTrainFolder ALL_TRAIN hasPnemoniaTrain
  if isempty(cachedTrainFolder) || ~strcmp(cachedTrainFolder, TrainFolder)
    % Load & vectorize only once per folder
    filePattern        = fullfile(TrainFolder, '*.png');
    theFiles           = dir(filePattern);
    DataSize           = numel(theFiles);
    tmp                = imread(fullfile(theFiles(1).folder,theFiles(1).name));
    imageSize          = numel(tmp(:));

    ALL_TRAIN          = zeros(DataSize, imageSize);
    hasPnemoniaTrain   = zeros(DataSize,1);
    for k = 1:DataSize
      baseFileName              = theFiles(k).name;
      fullFileName              = fullfile(theFiles(k).folder, baseFileName);
      I                         = imread(fullFileName);
      ALL_TRAIN(k,:)            = reshape(I,1,[]);
      hasPnemoniaTrain(k)       = contains(baseFileName, 'positive');
    end
    cachedTrainFolder = TrainFolder;
  end

  % Train model
  [Mdl, fitinfo] = fitclinear(ALL_TRAIN, hasPnemoniaTrain, ...
      'ObservationsIn','rows', ...
      'Regularization','ridge', ...
      'Learner','logistic', ...
      'Lambda', lambda);
end