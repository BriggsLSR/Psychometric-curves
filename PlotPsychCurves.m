% code to open behavioral data files then compute separate psychometric curves for
% each stimulus position on the monitor (right or left). Start with
% pre-lesion and Left side stimulus position, then pre-lesion Right then
% lesion Left then lesion Right

figure
for i = 1:2
    [datafile,path] = uigetfile('C:/Users/farranbriggs/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Farransmacbook/MATLAB/matlabfiles/'); %[datafile,path] = uigetfile('Z:\Data\Awake\Ferret_behavioral_box\');
    load(datafile);
    propCorMid=[]; propCorR=[]; propCorL=[]; fitL=[]; fitR=[]; fitMid=[]; PosMidl=[]; PosLf=[]; PosRt=[];
    for r = 1:length(Experiments.sessions)
        y=[]; d=[]; PosMid=[]; PosL=[]; PosR=[];
        y(:,1) = Experiments.sessions(r).level;
        y(:,2) = Experiments.sessions(r).side;
        y(:,3) = Experiments.sessions(r).correct;
        y(:,4) = Experiments.sessions(r).choice;
        y(:,5) = Experiments.sessions(r).hemifield;
        y(:,6) = Experiments.sessions(r).exit;

        d = find(y(:,6) == 1);
        if isempty(d) == 0
            y(d(1):end,:) = [];
        end
        d=[];
        d = find(y(:,5) == 990);
        if isempty(d) == 0
            PosMid = y(d,:);
        end
        d=[];
        d = find(y(:,5) > 990);
        if isempty(d) == 0
            PosR = y(d,:);
        end
        d=[];
        d = find(y(:,5) < 990);
        if isempty(d) == 0
            PosL = y(d,:);
        end

        if isempty(PosMid) == 0
            if length(PosMid(:,1)) > 5
                cohs=[];
                cohs = unique(PosMid(:,1));
                cohs = sort(cohs);
                for j = 1:length(cohs)
                    propCorMid(j,1,r) = cohs(j);
                    correctML=[]; incorrectML=[]; correctMR=[]; incorrectMR=[];
                    correctML = find(PosMid(:,1) == cohs(j) & PosMid(:,2) == 1 & PosMid(:,3) == 1);
                    incorrectML = find(PosMid(:,1) == cohs(j) & PosMid(:,2) == 1 & PosMid(:,3) == 0);
                    correctMR = find(PosMid(:,1) == cohs(j) & PosMid(:,2) == 2 & PosMid(:,3) == 1);
                    incorrectMR = find(PosMid(:,1) == cohs(j) & PosMid(:,2) == 2 & PosMid(:,3) == 0);
                    if length(correctML) > 2
                        propCorMid(j,2,r) = 1 - (length(correctML) / (length(incorrectML) + length(correctML)));
                    end
                    if length(correctMR) > 2
                        propCorMid(j,3,r) = length(correctMR) / (length(incorrectMR) + length(correctMR));
                    end
                end
            end
        end

        if isempty(PosR) == 0
            if length(PosR(:,1)) > 5
                cohs=[];
                cohs = unique(PosR(:,1));
                cohs = sort(cohs);
                for j = 1:length(cohs)
                    propCorR(j,1,r) = cohs(j);
                    correctML=[]; incorrectML=[]; correctMR=[]; incorrectMR=[];
                    correctML = find(PosR(:,1) == cohs(j) & PosR(:,2) == 1 & PosR(:,3) == 1);
                    incorrectML = find(PosR(:,1) == cohs(j) & PosR(:,2) == 1 & PosR(:,3) == 0);
                    correctMR = find(PosR(:,1) == cohs(j) & PosR(:,2) == 2 & PosR(:,3) == 1);
                    incorrectMR = find(PosR(:,1) == cohs(j) & PosR(:,2) == 2 & PosR(:,3) == 0);
                    if length(correctML) > 2
                        propCorR(j,2,r) = 1 - (length(correctML) / (length(incorrectML) + length(correctML)));
                    end
                    if length(correctMR) > 2
                        propCorR(j,3,r) = length(correctMR) / (length(incorrectMR) + length(correctMR));
                    end
                end
            end
        end

        if isempty(PosL) == 0
            if length(PosL(:,1)) > 5
                cohs=[];
                cohs = unique(PosL(:,1));
                cohs = sort(cohs);
                for j = 1:length(cohs)
                    propCorL(j,1,r) = cohs(j);
                    correctML=[]; incorrectML=[]; correctMR=[]; incorrectMR=[];
                    correctML = find(PosL(:,1) == cohs(j) & PosL(:,2) == 1 & PosL(:,3) == 1);
                    incorrectML = find(PosL(:,1) == cohs(j) & PosL(:,2) == 1 & PosL(:,3) == 0);
                    correctMR = find(PosL(:,1) == cohs(j) & PosL(:,2) == 2 & PosL(:,3) == 1);
                    incorrectMR = find(PosL(:,1) == cohs(j) & PosL(:,2) == 2 & PosL(:,3) == 0);
                    if length(correctML) > 2
                        propCorL(j,2,r) = 1 - (length(correctML) / (length(incorrectML) + length(correctML)));
                    end
                    if length(correctMR) > 2
                        propCorL(j,3,r) = length(correctMR) / (length(incorrectMR) + length(correctMR));
                    end
                end
            end
        end
    end

    if length(propCorL(:,1,1)) == 1
        x=[]; del=[];
        x = sum(propCorL,2);
        x = squeeze(x);
        del = find(x == 0);
        propCorL(:,:,del) = [];
    else
        for s = 1:length(propCorL(1,1,:))
            propCorL(:,:,s) = sortrows(propCorL(:,:,s));
        end
    end

    if length(propCorR(:,1,1)) == 1
        x=[]; del=[];
        x = sum(propCorR,2);
        x = squeeze(x);
        del = find(x == 0);
        propCorR(:,:,del) = [];
    else
        for s = 1:length(propCorR(1,1,:))
            propCorR(:,:,s) = sortrows(propCorR(:,:,s));
        end
    end

    if length(propCorMid(:,1,1)) == 1
        x=[]; del=[];
        x = sum(propCorMid,2);
        x = squeeze(x);
        del = find(x == 0);
        propCorMid(:,:,del) = [];
    else
        for s = 1:length(propCorMid(1,1,:))
            propCorMid(:,:,s) = sortrows(propCorMid(:,:,s));
        end
    end

    xaxisvalsL = unique(propCorL(:,1,:));
    xaxisvalsL(find(xaxisvalsL == 0)) = [];
    xaxisvalsR = unique(propCorR(:,1,:));
    xaxisvalsR(find(xaxisvalsR == 0)) = [];
    xaxisvalsMid = unique(propCorMid(:,1,:));
    xaxisvalsMid(find(xaxisvalsMid == 0)) = [];

    tempL=[]; tempR=[]; PosLpropL=[]; PosLpropLerr=[]; PosLpropR=[]; PosLpropRerr=[]; PosRpropL=[]; PosRpropLerr=[]; PosRpropR=[]; PosRpropRerr=[];
    PosMidpropL=[]; PosMidpropLerr=[]; PosMidpropR=[]; PosMidpropRerr=[];

    for u = 1:length(xaxisvalsL)
        z1=[]; z2=[]; z3=[];
        [z1,z2,z3] = find(propCorL(:,1,:) == xaxisvalsL(u));
        for v = 1:length(z1)
            tempL(v) = propCorL(z1(v),2,z2(v));
            tempR(v) = propCorL(z1(v),3,z2(v));
        end
        PosLpropL(u,1) = mean(tempL,'omitnan');
        PosLpropLerr(u,1) = std(tempL,'omitnan')./sqrt(length(z1));
        PosLpropR(u,1) = mean(tempR,'omitnan');
        PosLpropRerr(u,1) = std(tempR,'omitnan')./sqrt(length(z1));
    end

    tempL=[]; tempR=[];
    for u = 1:length(xaxisvalsR)
        z1=[]; z2=[]; z3=[];
        [z1,z2,z3] = find(propCorR(:,1,:) == xaxisvalsR(u));
        for v = 1:length(z1)
            tempL(v) = propCorR(z1(v),2,z2(v));
            tempR(v) = propCorR(z1(v),3,z2(v));
        end
        PosRpropL(u,1) = mean(tempL,'omitnan');
        PosRpropLerr(u,1) = std(tempL,'omitnan')./sqrt(length(z1));
        PosRpropR(u,1) = mean(tempR,'omitnan');
        PosRpropRerr(u,1) = std(tempR,'omitnan')./sqrt(length(z1));
    end

    tempL=[]; tempR=[];
    for u = 1:length(xaxisvalsMid)
        z1=[]; z2=[]; z3=[];
        [z1,z2,z3] = find(propCorMid(:,1,:) == xaxisvalsMid(u));
        for v = 1:length(z1)
            tempL(v) = propCorMid(z1(v),2,z2(v));
            tempR(v) = propCorMid(z1(v),3,z2(v));
        end
        PosMidpropL(u,1) = mean(tempL,'omitnan');
        PosMidpropLerr(u,1) = std(tempL,'omitnan')./sqrt(length(z1));
        PosMidpropR(u,1) = mean(tempR,'omitnan');
        PosMidpropRerr(u,1) = std(tempR,'omitnan')./sqrt(length(z1));
    end

    PosLf = [flip(PosLpropL);PosLpropR];
    PosLerr = [flip(PosLpropLerr);PosLpropRerr];
    PosRt = [flip(PosRpropL);PosRpropR];
    PosRerr = [flip(PosRpropLerr);PosRpropRerr];
    PosMidl = [flip(PosMidpropL);PosMidpropR];
    PosMiderr = [flip(PosMidpropLerr);PosMidpropRerr];

    xaxisL = [-1*flip(xaxisvalsL);xaxisvalsL];
    xaxisR = [-1*flip(xaxisvalsR);xaxisvalsR];
    xaxisMid = [-1*flip(xaxisvalsMid);xaxisvalsMid];

    options = fitoptions('weibull');
    options.StartPoint = [1,0.2];

    fitL = fit(xaxisL+2,PosLf,'weibull',options);
    fitLvals = feval(fitL,[1:0.1:3]);
    fitR = fit(xaxisR+2,PosRt,'weibull',options);
    fitRvals = feval(fitR,[1:0.1:3]);
    fitMid = fit(xaxisMid+2,PosMidl,'weibull',options);
    fitMidvals = feval(fitMid,[1:0.1:3]);
    

    if i==1
        subplot(1,3,1), errorbar(xaxisL,PosLf,PosLerr,'k')
        hold on
        subplot(1,3,1), plot([-1:0.1:1],fitLvals,'k')
        hold on
        subplot(1,3,2), errorbar(xaxisMid,PosMidl,PosMiderr,'k')
        hold on
        subplot(1,3,2), plot([-1:0.1:1],fitMidvals,'k')
        hold on
        subplot(1,3,3), errorbar(xaxisR,PosRt,PosRerr,'k')
        hold on
        subplot(1,3,3), plot([-1:0.1:1],fitRvals,'k')
        hold on

    elseif i==2
       subplot(1,3,1), errorbar(xaxisL,PosLf,PosLerr,'r')
        hold on
        subplot(1,3,1), plot([-1:0.1:1],fitLvals,'r')
        hold on
        subplot(1,3,2), errorbar(xaxisMid,PosMidl,PosMiderr,'r')
        hold on
        subplot(1,3,2), plot([-1:0.1:1],fitMidvals,'r')
        hold on
        subplot(1,3,3), errorbar(xaxisR,PosRt,PosRerr,'r')
        hold on
        subplot(1,3,3), plot([-1:0.1:1],fitRvals,'r')
    end
    clear Experiments
end