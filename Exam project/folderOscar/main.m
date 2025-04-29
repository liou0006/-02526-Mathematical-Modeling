
TrainFolder = "C:\Users\oscar\OneDrive - Danmarks Tekniske Universitet\Skrivebord\Bachelor\Train";
TestFolder = "C:\Users\oscar\OneDrive - Danmarks Tekniske Universitet\Skrivebord\Bachelor\Test";

 [Mdl, fitinfo] = fit(TrainFolder);
 [label, score, hasPnemoniaTrain] = modelPredict(TestFolder, Mdl);

clear testing
testing(:,1) = label;
testing(:,2) = hasPnemoniaTrain;

for k = 1:numel(hasPnemoniaTrain)
    if testing(k,1) == testing(k,2)
        testing(k,3) = 1;
    else
        testing(k,3) = 0;
    end
end

disp(sum(testing(:,3)));
disp((sum(testing(:,3))/numel(hasPnemoniaTrain))*100);
