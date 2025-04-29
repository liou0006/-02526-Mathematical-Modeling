
clear; clc; close all;

TrainFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Train";
TestFolder = "C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Exam project\data\Test";

[Mdl, Score] = fitPart1(TrainFolder);
[Label, Score, hasPnemoniaTest] = modelPredict(TestFolder, Mdl);

resultTable(:,1) = Label;
resultTable(:,2) = hasPnemoniaTest;
resultTable(:,4) = Score(:,1);
resultTable(:,5) = Score(:,2);

for k = 1:numel(hasPnemoniaTest)
    if resultTable(k,1) == resultTable(k,2)
        resultTable(k,3) = 1;
    else
        resultTable(k,3) = 0;
    end
end

fprintf('How many positive images:')
disp(sum(resultTable(:,3)));
fprintf('How many percentages of total image is true:')
disp((sum(resultTable(:,3))/numel(hasPnemoniaTest))*100);

PartNumber = 1;
writeToTable(resultTable, PartNumber);

Beta = Mdl.Beta;
betaim = reshape(Beta,224,224);
betaim = abs(betaim);

titleOfBeta = "Abs Value of learned weights image";

h1 = figure;
imshow(betaim, []);            
colormap(gca);          
colorbar;
title(titleOfBeta);
saveas(gca,titleOfBeta,'png')

clear filePatternTest filePatternTrain fullFileNameTest fullFileNameTrain baseFileNameTest baseFileNameTrain TestFolder TrainFolder
