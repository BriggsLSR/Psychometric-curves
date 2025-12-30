name = 'Enter Number of sessions';
prompt = {'Number of Sessions'};
numlines = 1;
defaultparams = {'1'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});


for i = 1:numRep
    [datafile,path] = uigetfile('C:\Users\Farran Briggs\Documents\MATLAB\matlabfiles\LFPanalysis\');
    load(datafile);
    
    mnRT = mean(data.RTmat(:,1));
        cfastRT = find(data.RTmat(:,1) <= mnRT & data.RTmat(:,3) == 0);
        cslowRT = find(data.RTmat(:,1) > mnRT & data.RTmat(:,3) == 0);
        dfastRT = find(data.RTmat(:,1) <=mnRT & data.RTmat(:,3) == 1);
        dslowRT = find(data.RTmat(:,1) > mnRT & data.RTmat(:,3) == 1);
        data.mnRTs = [mean(data.RTmat(cfastRT,1)) mean(data.RTmat(dfastRT,1)) mean(data.RTmat(cslowRT,1)) mean(data.RTmat(dslowRT,1))];
        mnRTs(i,:) = data.mnRTs;
        
        save([path datafile],'data','filelist','channels','-mat')
    clear channels data filelist
end