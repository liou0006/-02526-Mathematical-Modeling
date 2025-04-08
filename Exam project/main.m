
data = imread()



Mdl = fitclinear(data,Y);

[Label, Score] = predict(Mdl,data);