%This is a program to analyze reaction time data STARTING AFTER SEPT
%9TH!!!!!!!!!
%RTmat: column 1 = ReactionTime
%column2 = grating duration
%column 3 = trial type (attend 2 or attend away)
%column 4 = catch (0=no, 1 = yes)
name = 'Enter Number of Files to Analyze';
prompt = {'Number of Files'};
numlines = 1;
defaultparams = {'2'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});

for i = 1:numRep
    Attn2=[]; AttnW=[]; catchAttn2=[]; catchAttnW=[]; a=[]; b=[]; c=[]; d=[];

[datafile,path] = uigetfile('C:\Users\Farran Briggs\Documents\MATLAB\datafiles\');
load(datafile);

totalBlocks = str2double(Results(15,2));
blockTrials = str2double(Results(2,2));
totalTrials = str2double(Results(18,2));
totalA2 = str2double(Results(19,2));
totalAW = str2double(Results(20,2));
if rem(totalBlocks,2) > 0
    totalcorrectA2 = blockTrials * ((totalBlocks + 1) /2);
    totalcorrectAW = blockTrials * ((totalBlocks - 1) / 2);
else totalcorrectA2 = blockTrials * totalBlocks / 2;
    totalcorrectAW = blockTrials * totalBlocks/2;
end

prcntCrctmat(i,1) = totalcorrectA2 / totalA2 *100;
prcntCrctmat(i,2) = totalcorrectAW / totalAW * 100;
prcntCrctmat(i,3) = str2double(Results(17,2));

e = find(RTmat(:,1)<0.1);
RTmat(e,:)=[];
a = find(RTmat(:,3)==1);
Attn2 = RTmat(a,:);
b = find(RTmat(:,3)==2);
AttnW = RTmat(b,:);
c = find(Attn2(:,4) == 1);
catchAttn2 = Attn2(c,:);
d = find(AttnW(:,4) == 1);
catchAttnW = AttnW(d,:);
Attn2(c,:) = [];
AttnW(d,:) = [];

Avemat(i,1) = mean(Attn2(:,1));
Avemat(i,2) = mean(AttnW(:,1));
Avemat(i,3) = mean(catchAttn2(:,1));
Avemat(i,4) = mean(catchAttnW(:,1));

scatter(Attn2(:,2),Attn2(:,1),'.r')
hold on
scatter(AttnW(:,2),AttnW(:,1),'.g')
hold on
scatter(catchAttn2(:,2),catchAttn2(:,1),'.k')
hold on
scatter(catchAttnW(:,2),catchAttnW(:,1),'.k')
hold on

end
load AvematOld
Avemat = cat(1,AvematOld,Avemat);
popMeanMat=nanmean(Avemat,1);
stdMeanMat=nanstd(Avemat,0,1);
popMeanPrcntCrctMat = nanmean(prcntCrctmat,1);
stdMeanPrcntCrctMat = nanstd(prcntCrctmat,0,1);

figure
errorbar(popMeanMat,stdMeanMat)
hold on
bar(popMeanMat)

figure
errorbar(popMeanPrcntCrctMat,stdMeanPrcntCrctMat)
hold on
bar(popMeanPrcntCrctMat)

% Stats options
% [p,table,stats] = kruskalwallis(Avemat)
% multcompare(stats)