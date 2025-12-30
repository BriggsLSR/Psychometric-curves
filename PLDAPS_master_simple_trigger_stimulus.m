%% most simplified for Datapixx debugging
clear all
close all
settingsStruct = pldapsExperiments.ori.Settings_simple_trigger_stimulus;
p = pldaps(@pldapsExperiments.ori.setup_simple_trigger_stimulus, 'test', settingsStruct); 
p.run