clear; clc; close all force; warning off;


%% %% File Name & Data manipulation

addpath('matlab functions');


pickedFiles = char(uipickfiles('FilterSpec','*.csv','Prompt','Select one or more .csv file(s)', 'NumFiles', []));
numFiles = size(pickedFiles,1);

for i=1:numFiles
    fn = strtrim(pickedFiles(i,:));
    [filepath,filename,fileExt] = fileparts(fn);
    opts = detectImportOptions(fn);
    %preview(pickedFiles(i,:),opts)
    
    Telemetry = readtable(fn,opts);
    sum = summary(Telemetry);
    labels = fieldnames(sum);
    
    M_telemetry = readmatrix(fn);
    [row,col] = size(M_telemetry);
    
    multiselect(labels,M_telemetry, filename);
    struct(i).name = filename;
    struct(i).labels = labels;
    struct(i).data = M_telemetry;
end