function writeToTable(resultTable, PartNumber)

resultTableForXlsx(PartNumber,1) = "Part" + PartNumber;
resultTableForXlsx(PartNumber,2) = sum(resultTable(:,3));
resultTableForXlsx(PartNumber,3) = sum(resultTable(:,3))/size(resultTable, 1)*100;

writematrix(resultTableForXlsx,'Table For Results',FileType='spreadsheet');

end