
%code written 2/9/23  by Abi Alpers
% extracts frames from MotionBuilder data and creates averaged frames based
% on timing of unit spiking in associated data file
%Inputs: MATLAB data structure from NeuroExplorer (use code
%'CreateDataStructureFerretNatural.m'); .avi video of ferret's view of
%arena (use output from PatchVid.m')
%Outputs: MATLAB images composed of averaged frames for each spike
%has been tested and works with two different video files

%load in data 

load('AbiTestData.mat') %MATLAB data structure for neural data
test = VideoReader('Test 2021-11-07 05.42.49 PM #.avi'); %video file

%read function reads in each frame of the video. it's a 4-D matrix of
%HxWx3xF with F being the frame number. Use the 4th dimension to get the
%frame info
viddata = read(test);

%% Sanity check section
%this section is used as a check. it outputs a random sample of three
%frames so you know that you are getting actual images out
% sample = randi(length(viddata(1,1,1,:)),[1 3]); 
% for j = 1:length(sample)
%     figure
%     image = imagesc(viddata(:,:,:,sample(j)));
%     colormap gray
% end

%% Back to the normal code

%conversions needed to compare the video and neural data
totaltime = test.NumFrames / test.FrameRate;
framets = 0:1/120:totaltime;

%this section creates a structure of the frames that happen 0.03-0.05
%seconds before each spike
aveSTAframe = [];
for x = 1:length(data.unitAts(1,:))
    STAframe=[];
    if sum(data.unitAts(:,x) ~= 0)
        for i = 1:length(data.unitAts(:,x))
            if data.unitAts(i,x) > 0.05 && data.unitAts(i,x)-0.05 < totaltime
                a=[];
                a = find(framets > data.unitAts(i,x)-0.05 & framets < data.unitAts(i,x)-0.03);
                if a(1) < length(viddata(1,1,1,:))
                STAframe(:,:,:,i) = viddata(:,:,:,a(1));
                end
            end
        end
        aveSTAframe = cat(3,aveSTAframe,mean(STAframe,3)); 
    end
end

%this section creates a spike-triggered average image of the video for each
%unit in the data structure. will output as many images as units

for k = 1:length(aveSTAframe(:,:,:,1))
    figure
    image = imagesc(aveSTAframe(:,:,:,k));
    colormap gray
end









