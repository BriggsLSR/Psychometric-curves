%Code revised on 10/14/19 to analize accuracy per session for Betty, Olive,
%and Ethel; note for Ethel files, use single-unit attention structures to
%get Missmat variables

name = 'Enter Number of sessions to analyze';
prompt = {'Number of Sessions','DavisData=1 or EthelData=2?'};
numlines = 1;
defaultparams = {'1','2'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});
datatype = str2double(params{2});
A2RT = []; AWRT = []; ctchRT = [];

for r = 1:numRep
    RTmat = []; a = []; b=[]; c=[]; d=[]; A2=[]; AW=[]; ctch=[]; miss2=[]; missW=[];
    [datafile,path] = uigetfile('/Users/fbriggs/Documents/Documents-Farransmacbook/MATLAB/matlabfiles/LFPanalysis/Davis LFP data');
    load(datafile);
    blocktrials = str2num(data.results{2,2});
    RTmat = data.RTmat;
    if length(data.RTmat(:,1)) >= (blocktrials * 2)
        if datatype == 1  %Gather total trial data from Betty/Olive
            percentcorrect = str2num(data.results{14,2});
            totalcorrect = str2num(data.results{19,2}) + str2num(data.results{20,2});
            totalcomplete = round(100 * (totalcorrect / percentcorrect));
            
            a = find(RTmat(:,1) < 0.21); %use cutoff of < 0.21 for lever or button, but 0.1 for eye movement
            RTmat(a,:) = [];
            b = find(RTmat(:,3) == RTmat(:,4) & RTmat(:,3) == 0);
            A2 = RTmat(b,1);
            c = find(RTmat(:,3) == RTmat(:,4) & RTmat(:,4) == 1);
            AW = RTmat(c,1);
            misses = totalcomplete - totalcorrect;
            prtcatch = str2num(data.results{3,2});
            missC = ceil(misses * (prtcatch / 100));
            miss2 = ceil((misses - missC) / 2);
            missW = misses - missC - miss2;
            percentA2(r) = length(b) / (length(b) + length(miss2)) * 100;
            percentAW(r) = length(c) / (length(c) + length(missW)) * 100;
            
            if prtcatch == 0
                percentcatch(r) = NaN;
            else
                d = find(RTmat(:,3) ~= RTmat(:,4));
                ctch = RTmat(d,1);
                percentcatch(r) = length(d) / (length(d) + length(missC)) * 100;
            end
            
        elseif datatype == 2  % Gather total trial data from Ethel
            Missmat = data.Missmat;
            a = find(RTmat(:,1) < 0.1); %use cutoff of < 0.21 for lever or button, but 0.1 for eye movement
            RTmat(a,:) = [];
            totalcomplete = length(RTmat(:,1)) + length(Missmat(:,1));
            b = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
            A2 = RTmat(b,1);
            c = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
            AW = RTmat(c,1);
            miss2 = find(Missmat(:,3) == 1 & Missmat(:,4) == 0);
            missW = find(Missmat(:,3) == 2 & Missmat(:,4) == 0);
            percentA2(r) = length(b) / (length(b) + length(miss2)) * 100;
            percentAW(r) = length(c) / (length(c) + length(missW)) * 100;
            
            if str2num(data.results{3,2}) == 0
                percentcatch(r) = NaN;
            else
                d = find(RTmat(:,4) == 1);
                ctch = RTmat(d,1);
                missC = find(Missmat(:,4) == 1);
                percentcatch(r) = length(d) / (length(d) + length(missC)) * 100;
            end
        end
        
        if length(d) > 0
            figure(1)
            subplot(1,2,1), plot([mean(A2) mean(AW) mean(ctch)])
            hold on
            subplot(1,2,2), plot([percentA2(r) percentAW(r) percentcatch(r)])
            hold on
            
            RTstats(r,1) = ranksum(cat(1,A2,AW),ctch);
            
            if percentcatch(r) < mean([percentA2(r) percentAW(r)]) - (2 * std([percentA2(r) percentAW(r)]))
                RTstats(r,2) = 1;
            else RTstats(r,2) = 0;
            end
        end
        A2(:,2) = datatype;
        AW(:,2) = datatype;
        ctch(:,2) = datatype;
        A2RT = cat(1,A2RT,A2);
        AWRT = cat(1,AWRT,AW);
        ctchRT = cat(1,ctchRT,ctch);
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



