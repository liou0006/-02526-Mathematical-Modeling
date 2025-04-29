

%%
% Specify the folder where the files live.
TrainFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Train";
TestFolder = "C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\Final Exam\Test";

[Mdl, Score] = fit(TrainFolder);
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

Beta = Mdl.Beta;
betaim = reshape(Beta,224,224);
betaim = abs(betaim);

h1 = figure;
imshow(betaim, []);            
colormap(gca);          
colorbar;
title('Absolute Value of Learned Weights image');
saveas(gca,'Absolute Value of Learned Weights image','png')



clear filePatternTest filePatternTrain fullFileNameTest fullFileNameTrain baseFileNameTest baseFileNameTrain TestFolder TrainFolder
