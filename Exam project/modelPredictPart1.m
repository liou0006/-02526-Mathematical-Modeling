function [label, score, hasPnemoniaTest] = modelPredictPart1(TestFolder, Mdl)
  persistent cachedTestFolder ALL_ARRAY hasPnemoniaTest_cached
  if isempty(cachedTestFolder) || ~strcmp(cachedTestFolder, TestFolder)
    % Load & vectorize only once per folder
    filePattern            = fullfile(TestFolder, '*.png');
    theFiles               = dir(filePattern);
    DataSize               = numel(theFiles);
    tmp                    = imread(fullfile(theFiles(1).folder,theFiles(1).name));
    imageSize              = numel(tmp(:));

    ALL_ARRAY              = zeros(DataSize, imageSize);
    hasPnemoniaTest_cached = zeros(DataSize,1);
    for k = 1:DataSize
      baseFileName                = theFiles(k).name;
      fullFileName                = fullfile(theFiles(k).folder, baseFileName);
      I                           = imread(fullFileName);
      ALL_ARRAY(k,:)              = reshape(I,1,[]);
      hasPnemoniaTest_cached(k)   = contains(baseFileName, 'positive');
    end
    cachedTestFolder = TestFolder;
  end

  [label, score] = predict(Mdl, ALL_ARRAY);
  hasPnemoniaTest = hasPnemoniaTest_cached;
end
