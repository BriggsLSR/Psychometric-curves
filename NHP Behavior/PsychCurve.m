%Get accuracy and RT data from discrimation trials and computer
%psychometric functions
% Edited for chandler data (lines 18, 98, 101) from data.gratingparam{13,2}
% to {11,2}
name1 = 'Animal and data type';  %input GUI allows user to specify if tuning metrics are worth calculating.
prompt1 = {'Monkey E, C, or J?','Task'};
numlines = 1;
defaultparams1 = {'J','Con'};
params1 = inputdlg(prompt1,name1,numlines,defaultparams1);
animal = params1{1};
task = params1{2};

[datalist,path] = uigetfile('Z:\Data\Awake\Chandler\MatlabDataStructures\PsychStructures');
load(datalist)
switch task
    case 'Ori'
        numRep = length(OriList);
    case 'Con'
        numRep = length(ConList);
    case 'Color'
        numRep = length(ColorList);
end

Acc2 = []; AccW=[];

for i = 1:numRep
    c=[]; d=[]; RTmat=[]; missts=[]; abortts=[]; inv2=[]; invW=[]; RT2=[]; RTW=[]; RTinv2=[]; RTinvW=[]; m=[]; Missmat=[]; Missinv=[]; xaxis=[];
    switch task
        case 'Ori'
            datafile = char(OriList{i});
        case 'Con'
            datafile = char(ConList{i});
        case 'Color'
            datafile = char(ColorList{i});
    end

    load(datafile);

    RTmat = data.RTmat;
    missts = data.missts;
    abortts = data.abortts;
    RTmat(:,6) = data.answerts;
    if isfield(data,'Missmat') == 1
        Missmat = data.Missmat;
        switch task
            case 'Ori'
                Missmat(:,5) = Missmat(:,5) - str2num(char(data.gratingparams{11,2}));
            case 'Con'
                Missmat(:,5) = Missmat(:,5) - str2num(char(data.gratingparams{11,2}));
                RTmat(:,5) = RTmat(:,5) - str2num(char(data.gratingparams{11,2}));
        end
        c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
        d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
        inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
        invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
        c1 = find(Missmat(:,3) == 1 & Missmat(:,4) == 0);
        d1 = find(Missmat(:,3) == 2 & Missmat(:,4) == 0);
        RT2 = RTmat(c,:);
        RTW = RTmat(d,:);
        RTinv2 = RTmat(inv2,:);
        RTinvW = RTmat(invW,:);
        Miss2 = Missmat(c1,:);
        MissW = Missmat(d1,:);
        Missinv = Missmat(find(Missmat(:,4) == 1),:);
        xaxis = unique(RTmat(:,5));
        for s = 1:length(xaxis)
            f2=[]; fW=[]; m2=[]; mW=[];
            f2 = find(RT2(:,5) == xaxis(s));
            m2 = find(Miss2(:,5) == xaxis(s));
            PsychFun2(s,i) = length(f2) / (length(f2) + length(m2));
            fW = find(RTW(:,5) == xaxis(s));
            mW = find(MissW(:,5) == xaxis(s));
            PsychFunW(s,i) = length(fW) / (length(fW) + length(mW));
        end
        AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + length(Missinv(:,1)));
        Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
        % else %%this is for Ethel data where there was no Missmat saved
        %     m = find(missts < RTmat(1,6));
        %     if isempty(m) ~= 1
        %         RTmat(1,7) = length(m);
        %     else RTmat(1,7) = 0;
        %     end
        %     for r = 2:length(RTmat(:,1))
        %         m=[];
        %         m = find(missts < RTmat(r,6) & missts > RTmat(r-1,6));
        %         if isempty(m) ~= 1
        %             RTmat(r,7) = length(m);
        %         else RTmat(r,7) = 0;
        %         end
        %     end
        %     c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
        %     d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
        %     inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
        %     invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
        %     RT2 = RTmat(c,:);
        %     RTW = RTmat(d,:);
        %     RTinv2 = RTmat(inv2,:);
        %     RTinvW = RTmat(invW,:);
        %     xaxis = unique(RTmat(:,5));
        %     for s = 1:length(xaxis)
        %         f2=[]; fW=[];
        %         f2 = find(RT2(:,5) == xaxis(s));
        %         PsychFun2(s,i) = length(f2) / (length(f2) + sum(RT2(f2,7)));
        %         fW = find(RTW(:,5) == xaxis(s));
        %         PsychFunW(s,i) = length(fW) / (length(fW) + sum(RTW(fW,7)));
        %     end
        %     AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + sum(RTinv2(:,7)) + sum(RTinvW(:,7)));
        %     Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
    end

    fixnans = isnan(PsychFun2(:,i));
    PsychFun2(fixnans,i) = 0.5;
    fixnans = [];
    fixnans = isnan(PsychFunW(:,i));
    PsychFunW(fixnans,i) = 0.5;
    PsychFun2((length(xaxis)/2 + 1):end,i) = 1 - PsychFun2((length(xaxis)/2 + 1):end,i);
    PsychFunW((length(xaxis)/2 + 1):end,i) = 1 - PsychFunW((length(xaxis)/2 + 1):end,i);

    % Generate plots for single days
    f=figure(1);
    f.Position = [480 258 360 320];
    switch animal
        case 'C'
            scatter(xaxis(1:5), PsychFun2(1:5,i));
            fit1 = sigm_fit(xaxis(1:5),PsychFun2(1:5,i));
        case 'J'
            scatter(xaxis, PsychFun2(:,i));
            fit1 = sigm_fit(xaxis,PsychFun2(:,i));
        case 'E'
            scatter(xaxis, PsychFun2(:,i));
            fit1 = sigm_fit(xaxis,PsychFun2(:,i));
    end

    %get input and exclude data points, then add to master list if good
    %curve
    name = 'Good Curves?';  %input GUI allows user to specify if tuning metrics are worth calculating.
    prompt = {'Good Curve? No = 0, Yes = 1','# to exclude'};
    defaultparams = {'1','0'};
    params = inputdlg(prompt,name,numlines,defaultparams);
    goodcurve = (str2double(params{1}));
    exclusions = (str2double(params{2}));

    if goodcurve > 0
        KeepSession2(i) = i;
        set(figure(1),'Visible','on'); %calls figure 1, both curves will be on same figure.
        if exclusions == 1
            [Xvals,Yvals] = ginput(1);
            tempX = knnsearch(xaxis,Xvals);
            PsychFun2(tempX,i) = NaN;
        elseif exclusions == 2
            [Xvals,Yvals] = ginput(2);
            tempX = knnsearch(xaxis,Xvals);
            PsychFun2(tempX,i) = NaN;
        elseif exclusions == 3
            [Xvals,Yvals] = ginput(3);
            tempX = knnsearch(xaxis,Xvals);
            PsychFun2(tempX,i) = NaN;
        elseif exclusions == 4
            [Xvals,Yvals] = ginput(4);
            tempX = knnsearch(xaxis,Xvals);
            PsychFun2(tempX,i) = NaN;
        elseif exclusions == 5
            [Xvals,Yvals] = ginput(5);
            tempX = knnsearch(xaxis,Xvals);
            PsychFun2(tempX,i) = NaN;
        end
        switch animal
            case 'C'
                Acc2 = cat(2,Acc2,PsychFun2(1:5,i)); % NOTE: for Chandler, we are only include the positive difficulty points (1:5), but change for other
            case 'J'
                Acc2 = cat(2,Acc2,PsychFun2(:,i));
            case 'E'
                Acc2 = cat(2,Acc2,PsychFun2(:,i));
        end
    end

    f=figure(2);
    f.Position = [480 258 360 320];
    switch animal
        case 'C'
            scatter(xaxis(1:5), PsychFunW(1:5,i));
            fit1 = sigm_fit(xaxis(1:5),PsychFunW(1:5,i));
        case 'J'
            scatter(xaxis, PsychFunW(:,i));
            fit1 = sigm_fit(xaxis,PsychFunW(:,i));
        case 'E'
            scatter(xaxis, PsychFunW(:,i));
            fit1 = sigm_fit(xaxis,PsychFunW(:,i));
    end

    %get input and exclude data points, then add to master list if good
    %curve
    name = 'Good Curves?';  %input GUI allows user to specify if tuning metrics are worth calculating.
    prompt = {'Good Curve? No = 0, Yes = 1','# to exclude'};
    defaultparams = {'1','0'};
    params = inputdlg(prompt,name,numlines,defaultparams);
    goodcurve = (str2double(params{1}));
    exclusions = (str2double(params{2}));

    if goodcurve > 0
        KeepSessionW(i) = i;
        set(figure(2),'Visible','on'); %calls figure 1, both curves will be on same figure.
        if exclusions == 1
            [Xvals,Yvals] = ginput(1);
            tempX = knnsearch(xaxis,Xvals);
            PsychFunW(tempX,i) = NaN;
        elseif exclusions == 2
            [Xvals,Yvals] = ginput(2);
            tempX = knnsearch(xaxis,Xvals);
            PsychFunW(tempX,i) = NaN;
            elseif exclusions == 3
            [Xvals,Yvals] = ginput(3);
            tempX = knnsearch(xaxis,Xvals);
            PsychFunW(tempX,i) = NaN;
            elseif exclusions == 4
            [Xvals,Yvals] = ginput(4);
            tempX = knnsearch(xaxis,Xvals);
            PsychFunW(tempX,i) = NaN;
            elseif exclusions == 5
            [Xvals,Yvals] = ginput(5);
            tempX = knnsearch(xaxis,Xvals);
            PsychFunW(tempX,i) = NaN;
        end
        switch animal
            case 'C'
                AccW = cat(2,AccW,PsychFunW(1:5,i)); % NOTE: for Chandler, we are only include the positive difficulty points (1:5), but change for other
            case 'J'
                AccW = cat(2,AccW,PsychFunW(:,i));
            case 'E'
                AccW = cat(2,AccW,PsychFunW(:,i));
        end
    end

    clear data channels filelist GoodUnitAs GoodUnitBs GoodUnitCs
end
close all

%%Below code is for animals with complete psychometric curves (i.e. both
%%positive and negative difficulties on the xaxis below)
switch animal
    case 'E'
        Acc2(1,isnan(Acc2(1,:))) = 1;
        Acc2(2,isnan(Acc2(2,:))) = 0.9;
        Acc2(3,isnan(Acc2(3,:))) = 0.7;
        Acc2(4,isnan(Acc2(4,:))) = 0.6;
        Acc2(5,isnan(Acc2(5,:))) = 0.5;
        Acc2(6,isnan(Acc2(6,:))) = 0.5;
        Acc2(7,isnan(Acc2(7,:))) = 0.4;
        Acc2(8,isnan(Acc2(8,:))) = 0.3;
        Acc2(9,isnan(Acc2(9,:))) = 0.1;
        Acc2(10,isnan(Acc2(10,:))) = 0;

        AccW(1,isnan(AccW(1,:))) = 1;
        AccW(2,isnan(AccW(2,:))) = 0.9;
        AccW(3,isnan(AccW(3,:))) = 0.7;
        AccW(4,isnan(AccW(4,:))) = 0.6;
        AccW(5,isnan(AccW(5,:))) = 0.5;
        AccW(6,isnan(AccW(6,:))) = 0.5;
        AccW(7,isnan(AccW(7,:))) = 0.4;
        AccW(8,isnan(AccW(8,:))) = 0.3;
        AccW(9,isnan(AccW(9,:))) = 0.1;
        AccW(10,isnan(AccW(10,:))) = 0;
    case 'C'
        xaxis = xaxis(1:5);
        Acc2(1,isnan(Acc2(1,:))) = 1;
        Acc2(2,isnan(Acc2(2,:))) = 0.9;
        Acc2(3,isnan(Acc2(3,:))) = 0.7;
        Acc2(4,isnan(Acc2(4,:))) = 0.6;
        Acc2(5,isnan(Acc2(5,:))) = 0.5;
        AccW(1,isnan(AccW(1,:))) = 1;
        AccW(2,isnan(AccW(2,:))) = 0.9;
        AccW(3,isnan(AccW(3,:))) = 0.7;
        AccW(4,isnan(AccW(4,:))) = 0.6;
        AccW(5,isnan(AccW(5,:))) = 0.5;
    case 'J'
        Acc2(1,isnan(Acc2(1,:))) = 1;
        Acc2(2,isnan(Acc2(2,:))) = 0.9;
        Acc2(3,isnan(Acc2(3,:))) = 0.7;
        Acc2(4,isnan(Acc2(4,:))) = 0.6;
        Acc2(5,isnan(Acc2(5,:))) = 0.5;
        Acc2(6,isnan(Acc2(6,:))) = 0.5;
        Acc2(7,isnan(Acc2(7,:))) = 0.4;
        Acc2(8,isnan(Acc2(8,:))) = 0.3;
        Acc2(9,isnan(Acc2(9,:))) = 0.1;
        Acc2(10,isnan(Acc2(10,:))) = 0;

        AccW(1,isnan(AccW(1,:))) = 1;
        AccW(2,isnan(AccW(2,:))) = 0.9;
        AccW(3,isnan(AccW(3,:))) = 0.7;
        AccW(4,isnan(AccW(4,:))) = 0.6;
        AccW(5,isnan(AccW(5,:))) = 0.5;
        AccW(6,isnan(AccW(6,:))) = 0.5;
        AccW(7,isnan(AccW(7,:))) = 0.4;
        AccW(8,isnan(AccW(8,:))) = 0.3;
        AccW(9,isnan(AccW(9,:))) = 0.1;
        AccW(10,isnan(AccW(10,:))) = 0;
end

%%This code below should be universal as long as xaxis and Acc2 & AccW are
%%the same lengths

for r = 1:length(Acc2(1,:))
    [param,stat] = sigm_fit(xaxis,Acc2(:,r));
    %o = findobj;
    %pause
    hold on
    fit2(:,r) = stat.ypred;
    hold on
end
errorbar(xaxis,mean(fit2,2),std(fit2,0,2)/sqrt(r-1),'r')
hold on

for r = 1:length(AccW(1,:))
    [param,stat] = sigm_fit(xaxis,AccW(:,r));
    %o = findobj;
    %pause
    hold on
    fitW(:,r) = stat.ypred;
    hold on
end

errorbar(xaxis,mean(fitW,2),std(fitW,0,2)/sqrt(r-1),'b')
hold on

switch task
    case 'Ori'
        scatter(-4,mean(AccInv),'k')
        hold on
        errorbar(-4,mean(AccInv),std(AccInv,0,2)/sqrt(r-1),'k')
    case 'Con'
        scatter(-4,mean(AccInv),'k')
        hold on
        errorbar(-4,mean(AccInv),std(AccInv,0,2)/sqrt(r-1),'k')
    case 'Color'
        scatter(-0.42,mean(AccInv),'k')
        hold on
        errorbar(-0.42,mean(AccInv),std(AccInv,0,2)/sqrt(r-1),'k')
end

switch task
    case 'Ori'
        save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW','OriList','-mat', '-append')
    case 'Con'
        save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW','ConList','-mat', '-append')
    case 'Color'
        save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW','ColorList','-mat', '-append')
end

