%Notes: side=6 or direction = 0 is left, side=0 or direction=180 is right

%input number of files to analyze
name = 'Enter number of sessions';
prompt = {'# sessions'};
numlines = 1;
defaultparams = {'8'};
params = inputdlg(prompt,name,numlines,defaultparams);
numsessions = str2double(params{1});
PsychCurveValsL=[];PsychCurveValsR=[];

for i = 1:numsessions
    clear PDS
    [datafile,path] = uigetfile('*.*','C:\Users\Farran Briggs\Documents\MATLAB\matlabfiles\Analysis Code');
    PDS = importdata(datafile);

    StimulusParams(i).numDots = PDS.data{1,1}.stimulus.nrDots;   %% This assumes all trials have same basic stimulus params!!
    StimulusParams(i).dotSize = PDS.data{1,1}.stimulus.dotSize;
    StimulusParams(i).dotDens = PDS.data{1,1}.stimulus.dotDensity;
    StimulusParams(i).dotSpeed = PDS.data{1,1}.stimulus.dotSpeed;
    StimulusParams(i).dotLife = PDS.data{1,1}.stimulus.dotLifetime;
    StimulusParams(i).stimSiz = PDS.data{1,1}.stimulus.radius;
    StimulusParams(i).Ypos = PDS.data{1,1}.stimulus.centerY;
    StimulusParams(i).Xpos = PDS.data{1,1}.stimulus.centerX;
    StimulusParams(i).stimDur = PDS.data{1,1}.stimulus.durStim;
    StimulusParams(i).ITT = PDS.data{1,1}.stimulus.duration.ITI;

    coherenceMat=[]; numCohs=[]; LNumRightWrong=[]; RNumRightWrong=[];

    for iTrial = 1:length(PDS.data)-1
        coherenceMat(1,iTrial) = PDS.data{1,iTrial}.stimulus.dotCoherence;
        coherenceMat(2,iTrial) = PDS.data{1,iTrial}.stimulus.direction;
        if isfield(PDS.data{1,iTrial}.pldaps, 'goodtrial')
        coherenceMat(3,iTrial) = PDS.data{1,iTrial}.pldaps.goodtrial;
        else coherenceMat(3,iTrial) = 0;
        end
        %coherenceMat(5,iTrial) = PDS.data{1,iTrial}.side; This is redundant with direction
    end
    
    numCohs = unique(coherenceMat(1,:));
    StimulusParams(i).Cohs = numCohs;
    LNumRightWrong(:,1) = numCohs;
    RNumRightWrong(:,1) = numCohs;
    for r = 1:numCohs
        lefts=[]; CohsL=[]; rights=[]; CohsR=[];
        
        lefts = find(coherenceMat(1,:) == numCohs(r) & coherenceMat(2,:) == 0);
        CohsL = coherenceMat(:,lefts);
        LNumRightWrong(r,2) = length(find(CohsL(3,:) == 1));
        LNumRightWrong(r,3) = length(find(CohsL(3,:) == 0));
        LNumRightWrong(r,4) = LNumRightWrong(r,2) / (LNumRightWrong(r,2) + LNumRightWrong(r,3)); 
        
        rights = find(coherenceMat(1,:) == numCohs(r) & coherenceMat(2,:) == 180);
        CohsR = coherenceMat(:,rights);
        RNumRightWrong(r,2) = length(find(CohsR(3,:) == 1));
        RNumRightWrong(r,3) = length(find(CohsR(3,:) == 0));
        RNumRightWrong(r,4) = RNumRightWrong(r,2) / (RNumRightWrong(r,2) + RNumRightWrong(r,3));
    end

    PsychCurveValsL = cat(1,PsychCurveValsL,LNumRightWrong);
    PsychCurveValsR = cat(1,PsychCurveValsR,RNumRightWrong);
end

xaxis = [-1*flip(unique(PsychCurveValsL(:,1))) unique(PsychCurveValsR(:,1))];

Cohs = unique([PsychCurveValsL(:,1);PsychCurveValsR(:,1)]);
CorrL = PsychCurveValsL;
CorrL(:,2:3) = [];
CorrL = sort(CorrL,1);
for s = 1:length(Cohs)
    tempL=[];
tempL = find(CorrL(:,1) == Cohs(s));
tempyL(s) = mean(CorrL(tempL,2));
errL(s) = std(CorrL(tempL,2))/sqrt(length(tempL)-1);
end
CorrR = PsychCurveValsR;
CorrR(:,2:3) = [];
CorrR = sort(CorrR,1);
for s = 1:length(Cohs)
    tempR=[];
tempR = find(CorrR(:,1) == Cohs(s));
tempyR(s) = mean(CorrR(tempR,2));
errR(s) = std(CorrR(tempR,2))/sqrt(length(tempR)-1);
end

yvals = [flip(tempyL) tempyR];
scatter(-1*CorrL(:,1),CorrL(:,2),'k')
hold on
scatter(CorrR(:,1),CorrR(:,2),'y')
hold on
errorbar(xaxis,yvals,[errR errL],'g')
hold on
fity = fit((xaxis+2)',yvals','weibull');
fityvals = feval(fity,[1:0.1:3]);
fityvals = fityvals+0.2; %not sure why we need this correction??
hold on
plot([-1:0.1:1],fityvals,'m')

    

