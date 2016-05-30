clc
fclose('all');
SorcFilePont = fopen('ChbFillDyn.m','r');
CmndList = loadCmndListFromFile(SorcFilePont);
fclose('all');