%%
clc
% cd 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master'
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsData'
addpath(genpath('C:\BriggsLabCode\ferret behavior\PLDAPSNL-master'))
addpath(genpath('Y:\Data\Student Temp Folder\Silei Work\Lesion_analysis'))
% addpath(genpath('C:\toolbox\Psychtoolbox-3-3.0.16.8'))
% addpath(genpath('Y:\Data\Student Temp Folder\Silei Work'))
% addpath(genpath('C:\Users\BriggsLabNaturalSc\Documents\'))
savepath

%% daily check
% run the program once, check if the water comes out
% run the program again, in case of synchronization error
%% synchronization error
% first make sure the second screen is primary
% change the display frame rate to lower
% vertical sync to be on, unless application says
%% training stage 1 - get reward from all ports in any sequence
clear all
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsDataLesion'
settingsStruct = pldapsExperiments.ori.ori_FBAB4Settings_training1;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_norepeat, 'free_norepeat_green', settingsStruct); % one port will not give water repetitively
% p = pldaps(@pldapsExperiments.ori.ori_setup_free_repeat, 'free_repeat_Oatmeal', settingsStruct); % one port will give water repetitively
p.run
return
%% training stage 1 - get reward from back port first, and then any one of the front ports
% fixed phase in pldapsExperiments.ori.oritrial_free_sequence1
clear all
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsDataLesion'
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_sequence;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_sequence1, 'free_sequence_green', settingsStruct);
p.run
% %% training stage 1 - get reward from back port first, and then any one of the front ports
% clear all
% %questdlg('Did you set up plexon recording?');
% settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_SZ; % use central flash
% p = pldaps(@pldapsExperiments.ori.ori_setup_free_SZ, 'free_sequence_Bacon', settingsStruct); %contrast_discrimination_small_rand_pancake
% p.run
% questdlg('Did you stop plexon&cineplex recording?');
%% training stage 2 - orientation trials, block or random
clear all
close all
%questdlg('Did you set up plexon recording?');
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsData'
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_SZ;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_SZ, 'ori_discrimination_pseudo_Bacon', settingsStruct); %contrast_discrimination_small_rand_pancake
p.run
questdlg('Did you stop plexon&cineplex recording?');
questdlg('!Turn off Matlab!');
%% training stage 2 - side trials, block or random
clear all
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_side;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_side,'side_discrimination_small_rand_waffle', settingsStruct); %'ori_discrimination_side_gaussian_pseudo_waffle' 'ori_discrimination_side_block_pancake'
p.run
return
%% training stage 3 - contrast discrimination
clear all 
close all
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsData' 
%questdlg('Did you set up plexon recording?'); 
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_contrast;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_contrast,'contrast_discrimination_small_pseudo_toast', settingsStruct); %contrast_discrimination_small_rand_pancake
p.run
questdlg('Did you stop plexon&cineplex recording?');
questdlg('!Turn off Matlab!');
%% dot motion
clear all
close all
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsDataLesion'
%questdlg('Did you set up plexon recording?')
% settingsStruct = pldapsExperiments.dots.dots_FBAA4Settings_free;
% p = pldaps(@pldapsExperiments.dots.dots_setup_free,'dots_test', settingsStruct); %contrast_discrimination_small_rand_pancake
settingsStruct = pldapsExperiments.dots.dots_FBAD5Settings_patch;
p = pldaps(@pldapsExperiments.dots.dots_setup_free_patch,'dots_direction_block_white', settingsStruct);
p.run
%% Find beginning trial in a movie
% type in info of first several trials in movie
movieinfo = [1 0; 4 1; 1 1]; %[trialresponse correctness]
open movieinfo
% Get trials info
PDSstructure = "Y:\Data\Awake\Ferret_behavioral_box\pldapsData\contrast_discrimination_small_pseudo_pancake20220430pldapsExperiments.ori.ori_setup_free_contrast1953.PDS";
trialresponse = [];
correctness = [];
%correctchoice = [];
session = [];
for iSession = 1: length(PDSstructure)
    PDS = importdata(PDSstructure(iSession));

    for iTrial = 1:length(PDS.data)-1
        trialresponse = [trialresponse find(PDS.data{iTrial}.stimulus.respTrial)];
        correctness = [correctness isfield(PDS.data{iTrial}.pldaps,'goodtrial')];
        session = [session PDSstructure(iSession)];
    end
end
trialresponse = trialresponse';
correctness = correctness';
session = session';
datatable = table(trialresponse,correctness,session);
open datatable
startTrial_check = intersect(strfind(datatable.trialresponse', movieinfo(:,1)'),strfind(datatable.correctness', movieinfo(:,2)'));
% Then record startTrial in data spreadsheet
%% Analysis
open 'Y:\Data\Student Temp Folder\Silei Work\Lesion_analysis\CorrectRate'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\figure generation\Contrast figures\Contrast_main_publication'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\figure generation\Contrast figures\Contrast_main'
return
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\SupportFunctions\pdsDefaultTrialStructureNL' %adjust port
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\SupportFunctions\pldapsDefaultTrialFunction'
open  'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\@pldaps\pldapsClassDefaultParameters'
open generateCondList
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\+pds\+keyboard\keyboardCmd'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\+pds\+keyboard\setup.m' % keyboard representation
cd 'C:\Users\BriggsLabNaturalSc\Documents\ferret behavior\PLDAPSNL-master\pldapsData'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\@pldaps\run.m'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\@pldaps\pldaps.m'
open 'C:\BriggsLabCode\ferret behavior\PLDAPSNL-master\@pldaps\runTrial.m'
PDS = importdata('contrast_discrimination_small_pseudo_waffle20220603pldapsExperiments.ori.ori_setup_free_contrast1208.PDS')
% save data if program crashes
dbquit; data = p.data; conditions = p.conditions; initialParameters{1,1}.display.screenSize(3) = 1920; save contrast_discrimination_small_pseudo_peach20230630pldapsExperiments.ori.ori_setup_free_contrast.PDS
%initial setup
cd C:\toolbox\Psychtoolbox-3-3.0.16.8\Psychtoolbox
SetupPsychtoolbox
cd 'Y:\Data\Awake\Ferret_behavioral_box\pldapsData'
% test synchronization
BitsPlusIdentityClutTest(2,1)
%% flush
clear all
settingsStruct = pldapsExperiments.ori.ori_FBAB4Settings_flush;
p = pldaps(@pldapsExperiments.ori.ori_setup_free_flush, 'flush', settingsStruct); % one port will give water repetitively
p.run
return
%% training stage 2 - center grating, block trials
clear all
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_block;
p = pldaps(@pldapsExperiments.ori.ori_setup_free, 'ori_discrimination_block', settingsStruct);
p.run
return
%% training stage 3 - center grating, orientation discrimination
clear all
settingsStruct = pldapsExperiments.ori.ori_FBAA4Settings_pseudo;
p = pldaps(@pldapsExperiments.ori.ori_setup_free, 'ori_discrimination_waffle', settingsStruct);
p.run
return
%% 
%extend logspace:
V = logspace(log10(21.2725),log10(56.8107*2),13); % original vector
L = log10(V);
%N = L(end):mean(diff(L)):log10(121/2); % extend at the end
N = sort(L(1):-mean(diff(L)):log10(7)); % extend at the beginning
% Z = [V,10.^N(2:end)] % new vector, extended at the end, same log-scale
Z = [10.^N(1:end-1),V] % new vector, extended at the beginning, same log-scale

%change distance between each level:
logspace(log10(8),log10(65/2),12)
logspace(log10(0.3),log10(0.5),7)