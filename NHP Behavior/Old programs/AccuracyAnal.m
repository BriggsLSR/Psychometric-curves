%New code from 9/26/18 to analize accuracy per session for Betty, Olive,
%and Ethel

name = 'Enter Number of sessions to analyze';
prompt = {'Number of Sessions'};
numlines = 1;
defaultparams = {'1'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});
A2 = []; AW = []; ctch = []; 

for r = 1:numRep
    RTmat = []; a = []; b=[]; c=[]; d=[];
    [datafile,path] = uigetfile('/Users/fbriggs/Documents/Documents-Farransmacbook/MATLAB/matlabfiles/LFPanalysis/Davis LFP data');
    load(datafile);
    blocktrials = str2num(data.results{2,2});
    if length(data.RTmat(:,1)) >= (blocktrials * 2)
    %Gather total trial data from Betty/Olive
%     percentcorrect = str2num(data.results{14,2});
%     totalcorrect = str2num(data.results{19,2}) + str2num(data.results{20,2});
%     totalcomplete = round(100 * (totalcorrect / percentcorrect));

    % Gather total trial data from Ethel
    totalcomplete = length(data.contrastchangets);
    
    RTmat = data.RTmat;
    a = find(RTmat(:,1) < 0.1); %use cutoff of < 0.21 for lever or button, but 0.1 for eye movement
    RTmat(a,:) = [];
    % Commented loop is for Betty/Olive data
%     for s = 1:length(RTmat(:,1))
%         if RTmat(s,3) == RTmat(s,4) && RTmat(s,3) == 0
%             A2 = cat(1,A2,RTmat(s,1));
%         elseif RTmat(s,3) == RTmat(s,4) && RTmat(s,3) == 1
%             AW = cat(1,AW,RTmat(s,1));
%         elseif RTmat(s,3) ~= RTmat(s,4)
%             ctch = cat(1,ctch,RTmat(s,1));
%         end
%     end
    
    % Loop for Ethel data:
    for s = 1:length(RTmat(:,1))
        if RTmat(s,4) == 0 && RTmat(s,3) == 1
            A2 = cat(1,A2,RTmat(s,1));
        elseif RTmat(s,4) == 0 && RTmat(s,3) == 2
            AW = cat(1,AW,RTmat(s,1));
        elseif RTmat(s,4) == 1
            ctch = cat(1,ctch,RTmat(s,1));
        end
    end
    
    %Adaptation for Ethel
    b = find(data.RTmat(:,3)==1 & data.RTmat(:,4)==0);
    c = find(data.RTmat(:,3)==2 & data.RTmat(:,4)==0);
    d = find(data.RTmat(:,4)==1);

    percentcatch(r) = 100 * (length(ctch) / ((str2num(data.results{3,2})/75) * totalcomplete));
    
    reps = floor((totalcomplete-length(d))/blocktrials);
    addval = rem((totalcomplete-length(d)),blocktrials);
    if rem(reps,2) > 0
        percentA2(r) = 100 * (length(b)) / (((reps / 2) + 1) * blocktrials);
        percentAW(r) = 100 * (length(c)) / (((reps / 2) * blocktrials) + addval);
    else
        percentA2(r) = 100 * (length(b)) / (((reps / 2) * blocktrials) + addval);
        percentAW(r) = 100 * (length(c)) / ((reps / 2) * blocktrials);
    end
    
    if percentA2(r) > 100
        percentA2(r) = 100;
    end
    if percentAW(r) > 100
        percentAW(r) = 100;
    end
    
       figure(1)
       subplot(1,2,1), plot([mean(A2) mean(AW) mean(ctch)])
       hold on
       subplot(1,2,2), plot([percentA2(r) percentAW(r) percentcatch(r)])
       hold on
       
       if isempty(ctch) ~= 1
       RTstats(r,1) = ranksum(cat(1,A2,AW),ctch);
       else RTstats(r,1) = 0;
       end
       if percentcatch(r) < mean([percentA2(r) percentAW(r)]) - (2 * std([percentA2(r) percentAW(r)]))
           RTstats(r,2) = 1;
       else RTstats(r,2) = 0;
       end
    end
    clear channels data filelist
end
       
 % contrasts = 50 + units;
% for r = 1:length(contrasts)
%     good(r) = length(find(allRTmat(:,5) == contrasts(r)));
%     miss(r) = length(find(allMissmat(:,5) == contrasts(r)));
%     accuracy(r) = good(r) / (good(r) + miss(r));
%     mnRT(r) = mean(allRTmat(find(allRTmat(:,5) == contrasts(r)),1));
%     sterrRT(r) = std(allRTmat(find(allRTmat(:,5) == contrasts(r)),1)) / sqrt(4);
% end
% accuracy(1:5) = 0 - (1 - accuracy(1:5));
% scatter(units,accuracy)
% figure
% scatter(RTmat(:,5),RTmat(:,1))
% 
% unitsOri = [-50 -40 -30 -20 -15 15 20 30 40 50];
% for r = 1:length(unitsOri)
%     mnRT(r) = mean(RTmat(find(RTmat(:,5) == unitsOri(r)),1));
%     sterrRT(r) = std(RTmat(find(RTmat(:,5) == unitsOri(r)),1)) / sqrt(12);
% end           
            
            
            
            