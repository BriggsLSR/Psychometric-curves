%Get accuracy and RT data from discrimation trials and computer
%psychometric functions
%Start with orientation discrimination tasks:
load OriList
numRep = length(OriList);

for i = 1:numRep
    c=[]; d=[]; RTmat=[]; missts=[]; abortts=[]; inv2=[]; invW=[]; RT2=[]; RTW=[]; RTinv2=[]; RTinvW=[]; m=[]; Missmat=[]; Missinv=[]; xaxis=[];
    datafile = char(OriList{i});
    load(datafile);
    RTmat = data.RTmat;
    missts = data.missts;
    abortts = data.abortts;
    RTmat(:,6) = data.answerts;
    if isfield(data,'Missmat') == 1
        Missmat = data.Missmat;
        Missmat(:,5) = Missmat(:,5) - str2num(char(data.gratingparams{11,2}));
        c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
        d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
        inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
        invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
        RT2 = RTmat(c,:);
        RTW = RTmat(d,:);
        RTinv2 = RTmat(inv2,:);
        RTinvW = RTmat(invW,:);
        Missinv = Missmat(find(Missmat(:,4) == 1),:);
        xaxis = unique(RTmat(:,5));
        for s = 1:length(xaxis)
            f2=[]; fW=[]; m2=[]; mW=[];
            f2 = find(RT2(:,5) == xaxis(s));
            m2 = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 1);
            PsychFun2(s,i) = length(f2) / (length(f2) + length(m2));
            fW = find(RTW(:,5) == xaxis(s));
            mW = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 2);
            PsychFunW(s,i) = length(fW) / (length(fW) + length(mW));
        end
        AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + length(Missinv(:,1)));
        Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
    else
        m = find(missts < RTmat(1,6));
        if isempty(m) ~= 1
            RTmat(1,7) = length(m);
        else RTmat(1,7) = 0;
        end
        for r = 2:length(RTmat(:,1))
            m=[];
            m = find(missts < RTmat(r,6) & missts > RTmat(r-1,6));
            if isempty(m) ~= 1
                RTmat(r,7) = length(m);
            else RTmat(r,7) = 0;
            end
        end
        c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
        d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
        inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
        invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
        RT2 = RTmat(c,:);
        RTW = RTmat(d,:);
        RTinv2 = RTmat(inv2,:);
        RTinvW = RTmat(invW,:);
        xaxis = unique(RTmat(:,5));
        for s = 1:length(xaxis)
            f2=[]; fW=[];
            f2 = find(RT2(:,5) == xaxis(s));
            PsychFun2(s,i) = length(f2) / (length(f2) + sum(RT2(f2,7)));
            fW = find(RTW(:,5) == xaxis(s));
            PsychFunW(s,i) = length(fW) / (length(fW) + sum(RTW(fW,7)));
        end
        AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + sum(RTinv2(:,7)) + sum(RTinvW(:,7)));
        Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
    end

    Acc2(:,i) = PsychFun2(:,i);
    AccW(:,i) = PsychFunW(:,i);

    % Generate plots for single days
    figure
    scatter(xaxis, PsychFun2(:,i));
    fit1 = sigm_fit(xaxis,PsychFun2(:,i));

    clear data channels filelist GoodUnitAs GoodUnitBs GoodUnitCs
end

% %analyze contrast discrimination tasks
% % load ConList
% numRep = length(ConList);
% 
% for i = 1:numRep
%     c=[]; d=[]; RTmat=[]; missts=[]; abortts=[]; inv2=[]; invW=[]; RT2=[]; RTW=[]; RTinv2=[]; RTinvW=[]; m=[]; Missmat=[]; Missinv=[]; xaxis=[];
%     datafile = char(ConList{i});
%     load(datafile);
%     RTmat = data.RTmat;
%     missts = data.missts;
%     abortts = data.abortts;
%     RTmat(find(RTmat(:,1)==0),:) = [];
%     RTmat(:,6) = data.answerts;
%     RTmat(:,5) = RTmat(:,5) - str2num(char(data.gratingparams{13,2}));
%     if isfield(data,'Missmat') == 1
%         Missmat = data.Missmat;
%         Missmat(:,5) = Missmat(:,5) - str2num(char(data.gratingparams{13,2}));
%         c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
%         d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
%         inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
%         invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
%         RT2 = RTmat(c,:);
%         RTW = RTmat(d,:);
%         RTinv2 = RTmat(inv2,:);
%         RTinvW = RTmat(invW,:);
%         Missinv = Missmat(find(Missmat(:,4) == 1),:);
%         xaxis = unique(RTmat(:,5));
%         for s = 1:length(xaxis)
%             f2=[]; fW=[]; m2=[]; mW=[];
%             f2 = find(RT2(:,5) == xaxis(s));
%             m2 = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 1);
%             PsychFun2(s,i) = length(f2) / (length(f2) + length(m2));
%             fW = find(RTW(:,5) == xaxis(s));
%             mW = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 2);
%             PsychFunW(s,i) = length(fW) / (length(fW) + length(mW));
%         end
%         AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + length(Missinv(:,1)));
%         Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
%     else
%         m = find(missts < RTmat(1,6));
%         if isempty(m) ~= 1
%             RTmat(1,7) = length(m);
%         else RTmat(1,7) = 0;
%         end
%         for r = 2:length(RTmat(:,1))
%             m=[];
%             m = find(missts < RTmat(r,6) & missts > RTmat(r-1,6));
%             if isempty(m) ~= 1
%                 RTmat(r,7) = length(m);
%             else RTmat(r,7) = 0;
%             end
%         end
%         c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
%         d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
%         inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
%         invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
%         RT2 = RTmat(c,:);
%         RTW = RTmat(d,:);
%         RTinv2 = RTmat(inv2,:);
%         RTinvW = RTmat(invW,:);
%         xaxis = unique(RTmat(:,5));
%         for s = 1:length(xaxis)
%             f2=[]; fW=[];
%             f2 = find(RT2(:,5) == xaxis(s));
%             PsychFun2(s,i) = length(f2) / (length(f2) + sum(RT2(f2,7)));
%             fW = find(RTW(:,5) == xaxis(s));
%             PsychFunW(s,i) = length(fW) / (length(fW) + sum(RTW(fW,7)));
%         end
%         AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + sum(RTinv2(:,7)) + sum(RTinvW(:,7)));
%         Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
%     end
% 
%     Acc2(:,i) = PsychFun2(:,i);
%     AccW(:,i) = PsychFunW(:,i);
% 
%     % Generate plots for single days
%     figure
%     scatter(xaxis, PsychFun2(:,i));
%     fit1 = sigm_fit(xaxis,PsychFun2(:,i));
% 
%     clear data channels filelist GoodUnitAs GoodUnitBs GoodUnitCs
% end
% 
% %Analyze color behavior
% % load ColorList
% numRep = length(ColorList);
% 
% for i = 1:numRep
%     c=[]; d=[]; RTmat=[]; missts=[]; abortts=[]; inv2=[]; invW=[]; RT2=[]; RTW=[]; RTinv2=[]; RTinvW=[]; m=[]; Missmat=[]; Missinv=[]; xaxis=[];
%     datafile = char(ColorList{i});
%     load(datafile);
%     % RTmat = data.RTmat; % Just RTmat for Chandler data
%     RTmat = RTmat;
%     % missts = data.missts;
%     missts = missts;
%     % abortts = data.abortts;
%     abortts = abortts;
%     RTmat(find(RTmat(:,1)==0),:) = [];
%     % RTmat(:,6) = data.answerts;
%     RTmat(:,6) = answerts;
%     if isfield(data,'Missmat') == 1
%         Missmat = data.Missmat;
%         c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
%         d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
%         inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
%         invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
%         RT2 = RTmat(c,:);
%         RTW = RTmat(d,:);
%         RTinv2 = RTmat(inv2,:);
%         RTinvW = RTmat(invW,:);
%         Missinv = Missmat(find(Missmat(:,4) == 1),:);
%         xaxis = unique(RTmat(:,5));
%         for s = 1:length(xaxis)
%             f2=[]; fW=[]; m2=[]; mW=[];
%             f2 = find(RT2(:,5) == xaxis(s));
%             m2 = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 1);
%             PsychFun2(s,i) = length(f2) / (length(f2) + length(m2));
%             fW = find(RTW(:,5) == xaxis(s));
%             mW = find(Missmat(:,5) == xaxis(s) & Missmat(:,3) == 2);
%             PsychFunW(s,i) = length(fW) / (length(fW) + length(mW));
%         end
%         AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + length(Missinv(:,1)));
%         Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
%     else
%         m = find(missts < RTmat(1,6));
%         if isempty(m) ~= 1
%             RTmat(1,7) = length(m);
%         else RTmat(1,7) = 0;
%         end
%         for r = 2:length(RTmat(:,1))
%             m=[];
%             m = find(missts < RTmat(r,6) & missts > RTmat(r-1,6));
%             if isempty(m) ~= 1
%                 RTmat(r,7) = length(m);
%             else RTmat(r,7) = 0;
%             end
%         end
%         c = find(RTmat(:,3) == 1 & RTmat(:,4) == 0);
%         d = find(RTmat(:,3) == 2 & RTmat(:,4) == 0);
%         inv2 = find(RTmat(:,3) == 1 & RTmat(:,4) == 1);
%         invW = find(RTmat(:,3) == 2 & RTmat(:,4) == 1);
%         RT2 = RTmat(c,:);
%         RTW = RTmat(d,:);
%         RTinv2 = RTmat(inv2,:);
%         RTinvW = RTmat(invW,:);
%         xaxis = unique(RTmat(:,5));
%         for s = 1:length(xaxis)
%             f2=[]; fW=[];
%             f2 = find(RT2(:,5) == xaxis(s));
%             PsychFun2(s,i) = length(f2) / (length(f2) + sum(RT2(f2,7)));
%             fW = find(RTW(:,5) == xaxis(s));
%             PsychFunW(s,i) = length(fW) / (length(fW) + sum(RTW(fW,7)));
%         end
%         AccInv(i) = (length(RTinv2(:,1)) + length(RTinvW(:,1))) / (length(RTinv2(:,1)) + length(RTinvW(:,1)) + sum(RTinv2(:,7)) + sum(RTinvW(:,7)));
%         Abort(i) =  length(abortts) / (length(abortts) + length(missts) + length(RTmat(:,1)));
%     end
% 
%     Acc2(:,i) = PsychFun2(:,i);
%     AccW(:,i) = PsychFunW(:,i);
% 
%     % Generate plots for single days
%     figure
%     scatter(xaxis, PsychFun2(:,i));
%     fit1 = sigm_fit(xaxis,PsychFun2(:,i));
% 
%     hold on
%     plot(fit1)
%     clear data channels filelist GoodUnitAs GoodUnitBs GoodUnitCs
% end

% after creating Accuracy matrices (Acc2 and AccW) in excel, evening out column lengths,
% etc, use the following to plot sigmoidal functions for each session and
% average:
Acc2(:,i) = PsychFun2(:,i);
AccW(:,i) = PsychFunW(:,i);


for r = 1:length(Acc2(1,:))
    [param,stat] = sigm_fit(xaxis,Acc2(:,r));
    hold on
    %pause
end

for r = 1:length(Acc2(1,:))
    [param,stat] = sigm_fit(xaxis,Acc2(:,r));
    hold on
    fit2(:,r) = stat.ypred;
end

hold on
errorbar(xaxis,mean(fit2,2),std(fit2,0,2)/sqrt(6),'m')

for r = 1:length(AccW(1,:))
    [param,stat] = sigm_fit(xaxis,AccW(:,r));
    hold on
    %pause
end

for r = 1:length(AccW(1,:))
    [param,stat] = sigm_fit(xaxis,AccW(:,r));
    hold on
    fitW(:,r) = stat.ypred;
end

hold on
errorbar(xaxis,mean(fitW,2),std(fitW,0,2)/sqrt(5),'c')
hold on

%plotting Ethel data using "use" versions
for r = 1:length(useAcc2(1,:))
    [param,stat] = sigm_fit(xaxis,useAcc2(:,r));
    hold on
    %pause
end

for r = 1:length(useAcc2(1,:))
    [param,stat] = sigm_fit(xaxis,useAcc2(:,r));
    hold on
    fit2(:,r) = stat.ypred;
end

hold on
errorbar(xaxis,mean(fit2,2),std(fit2,0,2)/sqrt(6),'m')

for r = 1:length(useAccW(1,:))
    [param,stat] = sigm_fit(xaxis,useAccW(:,r));
    hold on
    %pause
end

for r = 1:length(useAccW(1,:))
    [param,stat] = sigm_fit(xaxis,useAccW(:,r));
    hold on
    fitW(:,r) = stat.ypred;
end

hold on
errorbar(xaxis,mean(fitW,2),std(fitW,0,2)/sqrt(5),'c')
hold on

