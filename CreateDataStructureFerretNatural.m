%this opens up .pl2 and .mat files for a freely moving ferret recording session and reads data into a
%structure called 'data' which is saved to the original session variable
%(e.g. Waffle01xx22). Can batch-analyze data from all sessions
%sequentially.

name = 'Enter Number of sessions to analyze';
prompt = {'Number of Sessions'};
numlines = 1;
defaultparams = {'1'};
params = inputdlg(prompt,name,numlines,defaultparams);
numRep = str2double(params{1});

for i = 1:numRep
    [datafile,path] = uigetfile('Z:\Data\Student Temp Folder\Abi\MatlabStructures');
    load(datafile);
    
    for r = 1:length(filelist(1,:))
        StartingFileName = char(filelist(r));
        
        [OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreThresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(StartingFileName);
        
        disp(['Opened File Name: ' OpenedFileName]);
        disp(['Version: ' num2str(Version)]);
        disp(['Frequency : ' num2str(Freq)]);
        disp(['Comment : ' Comment]);
        disp(['Date/Time : ' DateTime]);
        disp(['Duration : ' num2str(Duration)]);
        disp(['Num Pts Per Wave : ' num2str(NPW)]);
        disp(['Num Pts Pre-Threshold : ' num2str(PreThresh)]);
        % some of the information is only filled if the plx file version is >102
        if ( Version > 102 )
            if ( Trodalness < 2 )
                disp('Data type : Single Electrode');
            elseif ( Trodalness == 2 )
                disp('Data type : Stereotrode');
            elseif ( Trodalness == 4 )
                disp('Data type : Tetrode');
            else
                disp('Data type : Unknown');
            end
            
            disp(['Spike Peak Voltage (mV) : ' num2str(SpikePeakV)]);
            disp(['Spike A/D Resolution (bits) : ' num2str(SpikeADResBits)]);
            disp(['Slow A/D Peak Voltage (mV) : ' num2str(SlowPeakV)]);
            disp(['Slow A/D Resolution (bits) : ' num2str(SlowADResBits)]);
        end
        
        
        
        % get some counts
        [tscounts, wfcounts, evcounts, slowcounts] = plx_info(OpenedFileName,1);
        
        % tscounts, wfcounts are indexed by (unit+1,channel+1)
        % tscounts(:,ch+1) is the per-unit counts for channel ch
        % sum( tscounts(:,ch+1) ) is the total wfs for channel ch (all units)
        % [nunits, nchannels] = size( tscounts )
        % To get number of nonzero units/channels, use nnz() function
        
        % gives actual number of units (including unsorted) and actual number of
        % channels plus 1
        [nunits1, nchannels1] = size( tscounts );
        
        % we will read in the timestamps of all units,channels into a two-dim cell
        % array named allts, with each cell containing the timestamps for a unit,channel.
        % Note that allts second dim is indexed by the 1-based channel number.
        % preallocate for speed
        allts = cell(nunits1, nchannels1);
%         for iunit = 0:nunits1-1   % starting with unit 0 (unsorted)
%             for ich = 1:nchannels1-1
%                 if ( tscounts( iunit+1 , ich+1 ) > 0 )
%                     % get the timestamps for this channel and unit
%                     [nts, allts{iunit+1,ich}] = plx_ts(OpenedFileName, ich , iunit );
%                 end
%             end
%         end
        
        for iunit = 1:4   % starting with unit 1, SKIPPING unit 0 (unsorted), and only going through UnitD's although there probably aren't any
            for ich = 1:nchannels1-1
                if ( tscounts( iunit+1 , ich+1 ) > 0 )
                    % get the timestamps for this channel and unit
                    [nts, allts{iunit,ich}] = plx_ts(OpenedFileName, ich , iunit );
                end
            end
        end
        
        % get some other info about the spike channels
        [nspk,spk_filters] = plx_chan_filters(OpenedFileName);
        [nspk,spk_gains] = plx_chan_gains(OpenedFileName);
        [nspk,spk_threshs] = plx_chan_thresholds(OpenedFileName);
        [nspk,spk_names] = plx_chan_names(OpenedFileName);
        
        
        % get the a/d data into a cell array also.
        % This is complicated by channel numbering.
        % The number of samples for analog channel 0 is stored at slowcounts(1).
        % Note that analog ch numbering starts at 0, not 1 in the data, but the
        % 'allad' cell array is indexed by ich+1
        numads = (64:95);
        
            % preallocate for speed
            allad = cell(1,length(numads));
            for ich = 1:32
                    [adfreq, nad, tsad, fnad, allad{ich}] = plx_ad(OpenedFileName, numads(ich));
            end
     pl2 = PL2GetFileIndex(OpenedFileName);
       %PL2Print(pl2.AnalogChannels);
%             [nad,adfreqs] = plx_adchan_freqs(OpenedFileName);
%             [nad,adgains] = plx_adchan_gains(OpenedFileName);
%             [nad,adnames] = plx_adchan_names(OpenedFileName);
     
        % and finally the events
        [u,nevchannels] = size( evcounts );
        if ( nevchannels > 0 )
            % need the event chanmap to make any sense of these
            [u,evchans] = plx_event_chanmap(OpenedFileName);
            for iev = 1:nevchannels
                if ( evcounts(iev) > 0 )
                    evch = evchans(iev);
                    if ( evch == 257 )
                        [nevs{iev}, tsevs{iev}, svStrobed] = plx_event_ts(OpenedFileName, evch);
                    else
                        [nevs{iev}, tsevs{iev}, svdummy] = plx_event_ts(OpenedFileName, evch);
                    end
                end
            end
        end
        [nev,evnames] = plx_event_names(OpenedFileName);
        
        data(r).file = OpenedFileName;
        data(r).datetime = DateTime;
        data(r).duration = Duration;
        data(r).samplefreq = Freq;
        data(r).adfreq = adfreq;
        data(r).LFPs = allad;
        data(r).startts = tsevs{1};
        data(r).endts = tsevs{2};
        edge = (0:0.001:0.3);
        
        for j = 1:length(channels)
            if length(allts{1,channels(j)}) > 0
                n = []; wave = []; noisewv = []; mnwave = []; stdNwv = []; c = []; d = []; ISI = [];
                data(r).unitAts(1:length(allts{1,channels(j)}),j) = allts{1,channels(j)};
                d = data(r).unitAts(1:length(allts{1,channels(j)}),j);
                if length(d) < 2
                data(r).ISIAdist(j,:) = zeros(1,length(edge));
                else
                    for c = 1:(length(d) - 1)
                    ISI(c)=(d(c+1) - d(c));
                    end
                data(r).ISIAdist(j,:) = histc(ISI,edge);
                end
                [n, npw, ts, wave] = plx_waves_v(StartingFileName, channels(j), 1);
                data(r).waveA(channels(j)).ts = ts;
                data(r).waveA(channels(j)).wave = wave;
                mnwave = mean(wave,1);
                data(r).mnwaveformAs(j,:) = mnwave;
                for x = 1:n
                    noisewv(x,:) = wave(x,:) - mnwave;
                end
                stdNwv = mean(std(noisewv,0,2)) * 2;
                data(r).SNRunitAs(j) = (max(mnwave) - min(mnwave)) / stdNwv;
            else data(r).unitAts(1,j) = 0;
            end
            if length(allts{2,channels(j)}) > 0
                n = []; wave = []; noisewv = []; mnwave = []; stdNwv = []; c = []; d = []; ISI = [];
                data(r).unitBts(1:length(allts{2,channels(j)}),j) = allts{2,channels(j)};
                d = data(r).unitBts(1:length(allts{2,channels(j)}),j);
                if length(d) < 2
                data(r).ISIBdist(j,:) = zeros(1,length(edge));
                else
                    for c = 1:(length(d) - 1)
                    ISI(c)=(d(c+1) - d(c));
                    end
                data(r).ISIBdist(j,:) = histc(ISI,edge);
                end
                [n, npw, ts, wave] = plx_waves_v(StartingFileName, channels(j), 2);
                data(r).waveB(channels(j)).ts = ts;
                data(r).waveB(channels(j)).wave = wave;
                mnwave = mean(wave,1);
                data(r).mnwaveformBs(j,:) = mnwave;
                for x = 1:n
                    noisewv(x,:) = wave(x,:) - mnwave;
                end
                stdNwv = mean(std(noisewv,0,2)) * 2;
                data(r).SNRunitBs(j) = (max(mnwave) - min(mnwave)) / stdNwv;
            else data(r).unitBts(1,j) = 0;
            end
            if length(allts{3,channels(j)}) > 0
                n = []; wave = []; noisewv = []; mnwave = []; stdNwv = []; c = []; d = []; ISI = [];
                data(r).unitCts(1:length(allts{3,channels(j)}),j) = allts{3,channels(j)};
                d = data(r).unitCts(1:length(allts{3,channels(j)}),j);
                if length(d) < 2
                data(r).ISICdist(j,:) = zeros(1,length(edge));
                else
                    for c = 1:(length(d) - 1)
                    ISI(c)=(d(c+1) - d(c));
                    end
                data(r).ISICdist(j,:) = histc(ISI,edge);
                end
                [n, npw, ts, wave] = plx_waves_v(StartingFileName, channels(j), 3);
                data(r).waveC(channels(j)).ts = ts;
                data(r).waveC(channels(j)).wave = wave;
                mnwave = mean(wave,1);
                data(r).mnwaveformCs(j,:) = mnwave;
                for x = 1:n
                    noisewv(x,:) = wave(x,:) - mnwave;
                end
                stdNwv = mean(std(noisewv,0,2)) * 2;
                data(r).SNRunitCs(j) = (max(mnwave) - min(mnwave)) / stdNwv;
            else data(r).unitCts(1,j) = 0;
            end
        end
        
        data(r).starttimes = PL2StartStopTs(StartingFileName, 'start');
        data(r).endtimes = PL2StartStopTs(StartingFileName, 'stop');
        
%         load (char(filelist(2,r))) 
%         data(r).results = Results;
%         data(r).gratingparams = GratingParams;
%         data(r).RTmat = RTmat;
%         data(r).gratTime = gratTime;
%         data(r).channels = channels;
%         data(r).Missmat = Missmat;
%         data(r).ChangeUnits = units;
        
        name2 = 'Enter contacts at layer 4/5 border (> 8 and < 21)';
        prompt2 = {'L4 border'};
        numlines = 1;
        defaultparams2 = {'[3 4 3 4]'};
        params2 = inputdlg(prompt2,name2,numlines,defaultparams2);
        L4border = str2num(params2{1});
        data(r).L4border = L4border;
    end
    save([path datafile],'data','filelist','channels','-mat')
   % clear Results GratingParams RTmat gratTime channels data filelist GoodUnitAs GoodUnitAs GoodUnitAs
end