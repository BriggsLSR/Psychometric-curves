%calculate abort rate for Ethel data
%for attention structures:
for r = 1:31
    [datafile,path] = uigetfile('C:\Users\WinCycle\Documents\MATLAB\datafiles\');
load(datafile);

abortE(r) = round(100*(length(data(1).abortsts) / length(data(1).fixstartts)));

clear channels data filelist
end

