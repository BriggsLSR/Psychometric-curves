% type in information
PDS = importdata('contrast_discrimination_small_rand_waffle20211104pldapsExperiments.ori.ori_setup_free_contrast1430.PDS');
calibration_trialnum = 1;
first_rear_break_time_camera = 1;
trial_you_want_to_look_at = 2;

% get offset_to_be_subtracted_from_pldaps
first_rear_break_time_pldaps = PDS.data{1,calibration_trialnum}.timing.datapixxPreciseTime(2) +  p.data{1,calibration_trialnum}.stimulus.timeTrialStartResp;
offset_to_be_subtracted_from_pldaps = first_rear_break_time_pldaps - first_rear_break_time_camera;

% get the pldaps time of midpoint break
midpoint_break_time_pldaps = PDS.data{1,trial_you_want_to_look_at}.timing.datapixxPreciseTime(2) + p.data{1,trial_you_want_to_look_at}.stimulus.timemidpointCrossed;

% time in video corresponding to midpoint break (in sec)
midpoint_break_time_camera = midpoint_break_time_pldaps - offset_to_be_subtracted_from_pldaps;
midpoint_break_time_camera