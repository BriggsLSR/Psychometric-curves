%Reacton time and accuracy analysis

name = 'Enter number of files to analyze';
prompt = {'Number of files'};
numlines = 1;
defaultparams = {'2'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});

for i = 1:numRep
    Attn2 = []; AttnW = []; catchAttn2 = []; catchAttnW = []; a = []; b = []; c = []; d = []; f = []; a1 = []; b1 = []; c1 = []; d1 = [];
    misses = []; miss2 = []; missW = []; missC2 = []; missCW = []; cut = [];

[datafile,path] = uigetfile('C:\Users\Farran Briggs\Documents\MATLAB\datafiles');
load(datafile);

name2 = 'when was this file recorded?';
prompt2 = {'1 = pre 11/14; 2 = post 11/14','1 = con; 2 = ori'};
defaultparams2 = {'2','1'};
params2 = inputdlg(prompt2,name2,numlines,defaultparams2);
newfile = str2double(params2{1});
OriCon = str2double(params2{2});

switch newfile
    case 1
        misses = Missmat;
    case 2
        if OriCon == 1
        StartParam = str2num(GratingParams{13,2});
        levels = units + StartParam;
        elseif OriCon == 2
            levels = units;
        end
        
        for x = 1:(length(Missmat(:,1)) - 1)
            if Missmat(x,5) == Missmat(x+1,5)
                cut(x) = 1;
            else cut(x) = 0;
            end
        end
        f = find(cut == 1);
        misses = Missmat;
        misses(f,:) = [];
end

a1 = find(misses(:,3) == 1);
miss2 = misses(a1,:);
b1 = find(misses(:,3) == 2);
missW = misses(b1,:);
c1 = find(miss2(:,4) == 1);
missC2 = miss2(c1,:);
d1 = find(missW(:,4) == 1);
missCW = missW(d1,:);
miss2(c1,:) = [];
missW(d1,:) = [];


a = find(RTmat(:,3) == 1);
Attn2 = RTmat(a,:);
b = find(RTmat(:,3) == 2);
AttnW = RTmat(b,:);
c = find(Attn2(:,4) == 1);
catchAttn2 = Attn2(c,:);
d = find(AttnW(:,4) == 1);
catchAttnW = AttnW(d,:);
Attn2(c,:) = [];
AttnW(d,:) = [];

AveRTmat(i,1) = nanmean(Attn2(:,1));
AveRTmat(i,2) = nanmean(AttnW(:,1));
AveRTmat(i,3) = nanmean(catchAttn2(:,1));
AveRTmat(i,4) = nanmean(catchAttnW(:,1));


scatter(Attn2(:,2),Attn2(:,1),'.r')
hold on
scatter(AttnW(:,2),AttnW(:,1),'.g')
hold on
scatter(catchAttn2(:,2),catchAttn2(:,1),'.k')
hold on
scatter(catchAttnW(:,2),catchAttnW(:,1),'.k')

Accurmat(i,1) = length(Attn2(:,1)) / (length(Attn2(:,1)) + length(miss2(:,1)));
Accurmat(i,2) = length(AttnW(:,1)) / (length(AttnW(:,1)) + length(missW(:,1)));
Accurmat(i,3) = length(catchAttn2(:,1)) / (length(catchAttn2(:,1)) + length(missC2(:,1)));
Accurmat(i,4) = length(catchAttnW(:,1)) / (length(catchAttnW(:,1)) + length(missCW(:,1)));


if newfile == 2
    for x = 1:length(levels)
        if length(find(RTmat(:,5) == levels(x))) > 0
            correct(i,x) = length(find(RTmat(:,5) == levels(x))) / (length(find(misses(:,5) == levels(x))) + length(find(RTmat(:,5) == levels(x))));
        else correct(i,x) = 0;
        end
    end
end
clear RTmat Missmat
end

popMeanRTMat = nanmean(AveRTmat,1);
stdMeanRTMat = nanstd(AveRTmat,0,1) ./sqrt(numRep - 1);
popMeanAccMat = nanmean(Accurmat,1);
stdMeanAccMat = nanstd(Accurmat,0,1) ./sqrt(numRep - 1);

figure
subplot(1,2,1), errorbar(popMeanRTMat,stdMeanRTMat)
hold on
subplot(1,2,1), bar(popMeanRTMat)
hold on
subplot(1,2,2), errorbar(popMeanAccMat,stdMeanAccMat)
hold on
subplot(1,2,2), bar(popMeanAccMat)

% correct(find(correct == 0)) = 0.5;
% correct(:,1:(length(levels)/2)) = 1 - correct(:,1:(length(levels)/2));
% 
% figure
% for z = 1:length(correct(:,1))
%     plot(units,correct(z,:))
%     hold on
% end