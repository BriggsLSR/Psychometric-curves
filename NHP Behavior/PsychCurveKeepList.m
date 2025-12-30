% 103125 - This code is meant to isolate a list of all the session that
% weren't excluded and their corresponding .mat files. Essentially, all the
% good behavior days in your dataset.

% Load Data
[datalist,path] = uigetfile('Z:\Data\Awake\Chandler\MatlabDataStructures\PsychStructures');
load(datalist)

% Input GUI
name1 = 'Animal and data type'; 
prompt1 = {'Monkey E, C, or J?','Task'}; % Specify which monkey and which attn task
numlines = 1;
defaultparams1 = {'C','Ori'}; 
params1 = inputdlg(prompt1,name1,numlines,defaultparams1);
animal = params1{1};
task = params1{2};

%% Start with Attn-Toward
% Initialize Variables
KeepList2 = []; % Will later hold paired session and task data
KeepSession2 = num2cell(KeepSession2);
KeepSession2 = [KeepSession2]';

numRep = length(KeepSession2);

switch task
    case 'Ori'
        taskList = OriList;
    case 'Con'
        taskList = ConList;
    case 'Color'
        taskList = ColorList;
end

KeepList2 = [KeepSession2 taskList(1:numRep)]; % Combine KeepSession2 with corresponding taskList entries
KeepList2(cell2mat(KeepList2(:,1)) == 0, :) = []; % Remove rows where first col = 0 (Exclusions from KeepSession2)

%% Next do Attn-Away
% Initialize Variables
KeepListW = []; % Will later hold paired session and task data
KeepSessionW = num2cell(KeepSessionW);
KeepSessionW = [KeepSessionW]';

numRep = length(KeepSessionW);

switch task
    case 'Ori'
        taskList = OriList;
    case 'Con'
        taskList = ConList;
    case 'Color'
        taskList = ColorList;
end

KeepListW = [KeepSessionW taskList(1:numRep)]; % Combine KeepSessionW with corresponding taskList entries
KeepListW(cell2mat(KeepListW(:,1)) == 0, :) = []; % Remove rows where first col = 0 (Exclusions from KeepSessionW)

%% Save
switch task
    case 'Ori'
         save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW', 'KeepList2', 'KeepListW', 'OriList','-mat', '-append')
    case 'Con'
        save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW', 'KeepList2', 'KeepListW', 'ConList','-mat', '-append')
    case 'Color'
        save([path datalist],'Abort', 'Acc2','AccW', 'AccInv', 'task', 'xaxis', 'KeepSession2','KeepSessionW', 'KeepList2', 'KeepListW', 'ColorList','-mat', '-append')
end
