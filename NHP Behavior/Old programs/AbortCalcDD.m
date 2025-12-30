% open each Davis data file and get number of all trials, then calculate
% proportion of aborted trials
for r = 1:6
trigs = [];
    
 [datafile,path] = uigetfile('C:\Users\Farran Briggs\Documents\MATLAB\datafiles\');
load(datafile);

trigs = textread(char(filelist(1,1)));
numtrials = length(trigs(:,1));
percentcorrect = str2num(data.results{14,2});
totalcorrect = str2num(data.results{19,2}) + str2num(data.results{20,2});
totalcomplete = round(100 * (totalcorrect / percentcorrect));
aborts(r) = (numtrials - totalcomplete) / numtrials * 100;
end

%calculating aborted trials from Ethel data:
%     abortE(r) = round(100*((length(data.gratstartts) - length(data.contrastchangets)) / (length(data.answerts) + length(data.missts))));
%    
%     clear channels data filelist
% end