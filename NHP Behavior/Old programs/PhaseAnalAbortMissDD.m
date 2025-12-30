name = 'Enter Number of sessions';
prompt = {'Number of Sessions'};
numlines = 1;
defaultparams = {'1'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});
phaseMissall = []; phaseAbortall = []; gratonM = []; gratonA = [];

for i = 1:numRep
    [datafile,path] = uigetfile('C:\Users\Farran Briggs\Documents\MATLAB\workspaces\');
    load(datafile);
    
    trigs = []; a = []; Missmat = []; Abortmat = []; b = []; c = []; d = [];
    trigs = textread(char(filelist(1,1)));
    b = find(trigs(:,4) < 0);
    trigs(b,:) = [];
    Missmat = trigs(find(trigs(:,7) < trigs(:,8)),:);
    Abortmat = trigs(find(trigs(:,5) < 0),:);
    Abortmat(:,[1:3 5:7]) = []; %Abortmat(:,1) = grating onset; Abortmat(:,2) = response time
    Missmat(:,[1:3 5 6 8]) = [];
    Missmat(:,2) = Missmat(:,2) - 0.5; %Missmat(:,1) = grating onset; Missmat(:,2) = contrast change
    c = find((Missmat(:,2) - Missmat(:,1)) < 1);
    Missmat(c,:) = [];
    
    TF = str2double(data.gratingparams{8,2});
    smplfrq = data.adfreq;
    Missmat = round(Missmat .* smplfrq);
    Abortmat = round(Abortmat .* smplfrq);
    gratdur = 1;
    trllgth = gratdur * smplfrq / 2;
    gratontimeAbort = Abortmat(:,2) - Abortmat(:,1);
    gratontimeMiss = Missmat(:,2) - Missmat(:,1);
    a = find(gratontimeAbort > 2900);
    gratontimeAbort(a) = [];
    Abortmat(a,:) = [];
    d = find(gratontimeMiss > 2900);
    gratontimeMiss(d) = [];
    Missmat(d,:) = [];
    lg = trllgth+1;
    Ham = hamming(lg);
    grattsAbort = (Abortmat(:,1) + gratontimeAbort - rem(gratontimeAbort,smplfrq/TF)) - trllgth;
    grattsMiss = (Missmat(:,1) + gratontimeMiss - rem(gratontimeMiss,smplfrq/TF)) - trllgth;
    numtrialsM = length(grattsMiss);
    numtrialsA = length(grattsAbort);
    
    trlLFPsM = []; HmLFPsM = []; fftLFPM = []; phsLFPM = []; phaseMiss = []; ztrlLFPsM = [];
    trlLFPsA = []; HmLFPsA = []; fftLFPA = []; phsLFPA = []; phaseAbort = []; ztrlLFPsA = [];
    for u = 1:numtrialsM
        trlLFPsM(:,u) = data.V1LFP(grattsMiss(u):(grattsMiss(u)+trllgth),:);
    end
    for u = 1:numtrialsA
        trlLFPsA(:,u) = data.V1LFP(grattsAbort(u):(grattsAbort(u)+trllgth),:);
    end
    
    for u = 1:numtrialsM %detrend
        trlLFPsM(:,u) = detrend(trlLFPsM(:,u));
    end
    for u = 1:numtrialsA
        trlLFPsA(:,u) = detrend(trlLFPsA(:,u));
    end
    YV1 = [];
    YV1 = trlLFPsM(:);
    YV1 = YV1 - repmat(mean(YV1),[numtrialsM*(trllgth+1) 1]);
    YV1 = YV1 ./(std(YV1)*ones(numtrialsM*(trllgth+1),1));
    ztrlLFPsM = reshape(YV1,(trllgth+1),1,numtrialsM);
    YV1 = [];
    YV1 = trlLFPsA(:);
    YV1 = YV1 - repmat(mean(YV1),[numtrialsA*(trllgth+1) 1]);
    YV1 = YV1 ./(std(YV1)*ones(numtrialsA*(trllgth+1),1));
    ztrlLFPsA = reshape(YV1,(trllgth+1),1,numtrialsA);
    
    for u = 1:numtrialsM
        HmLFPsM(:,u) = ztrlLFPsM(:,u) .* Ham;
        fftLFPM(:,u) = fft(HmLFPsM(:,u));
        phsLFPM(:,u) = unwrap(angle(fftLFPM(:,u)));
    end
    for u = 1:numtrialsA
        HmLFPsA(:,u) = ztrlLFPsA(:,u) .* Ham;
        fftLFPA(:,u) = fft(HmLFPsA(:,u));
        phsLFPA(:,u) = unwrap(angle(fftLFPA(:,u)));
    end
    
    data.phaseMiss = phsLFPM;
    phaseMissall = cat(2,phaseMissall,phsLFPM);
    data.phaseAbort = phsLFPA;
    phaseAbortall = cat(2,phaseAbortall,phsLFPA);
    gratonM = cat(1,gratonM,gratontimeMiss);
    gratonA = cat(1,gratonA,gratontimeAbort);
    
    save([path datafile],'data','filelist','channels','-mat')
    clear channels data filelist
end

xaxis2 = (20:10:70);

for r = 1:length(phaseMissall(1,:))
    dectempM(r,:) = decimate(phaseMissall(20:70,r),10);
    fitobjectM = fit(xaxis2',dectempM(r,:)','poly1');
    msecleadlagMiss(r) = fitobjectM.p1 * 57.2958 * 2.7777778;
end

figure
scatter(msecleadlagMiss,gratonM);

for r = 1:length(phaseAbortall(1,:))
    dectempA(r,:) = decimate(phaseAbortall(20:70,r),10);
    fitobjectA = fit(xaxis2',dectempA(r,:)','poly1');
    msecleadlagAbort(r) = fitobjectA.p1 * 57.2958 * 2.7777778;
end

figure
scatter(msecleadlagAbort,gratonA);

edge = (-300:20:300);
figure
bar(edge,histc(msecleadlagMiss,edge),'k')
hold on
plot(ones(1,(max(histc(msecleadlagMiss,edge))+20))*mean(msecleadlagMiss),(0:1:(max(histc(msecleadlagMiss,edge))+19)),'--k')
hold on
bar(edge,histc(msecleadlagAbort,edge),'g')
hold on
plot(ones(1,(max(histc(msecleadlagAbort,edge))+20))*mean(msecleadlagAbort),(0:1:(max(histc(msecleadlagAbort,edge))+19)),'--g')

