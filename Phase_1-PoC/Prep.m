% Prepare raw data --------

RP_Trial_temp = RP_Trial5_Raw;
DL_Trial_temp = DL_Trial5_Raw; 

% Convert RPi data timestamp from UNIX timestamp to MATLAB datetime variable
RP_Trial_temp.t = datetime(RP_Trial_temp.t, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert DL data timestamp from a numerical timestamp to MATLAB datetime variable
t1 = compose('%.2f' , DL_Trial_temp.t); % Convert number to string so it can be read by datetime function
DL_Trial_temp.t = datetime(t1, 'InputFormat', 'yyyyMMddHHmmss.SS', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert data-logger pressure
DL_Trial_temp.P_DL = -(DL_Trial_temp.P_DL - 6) .* 3.125;

% Filter the data ---------

RP_Trial_temp{:, 2:end} = sgolayfilt(RP_Trial_temp{:, 2:end}, 3, 201);
DL_Trial_temp{:, 2:end} = sgolayfilt(DL_Trial_temp{:, 2:end}, 3, 201);

% Convert and clean up ----

RP_TT = table2timetable(RP_Trial_temp);
DL_TT = table2timetable(DL_Trial_temp);

RP_TT = sortrows(RP_TT);
DL_TT = sortrows(DL_TT);
RP_TT = rmmissing(RP_TT);
DL_TT = rmmissing(DL_TT);
%RP_TT = unique(RP_TT);
%DL_TT = unique(DL_TT);

% Synchronise --------------

F_s = 1; % Sample rate

clear RP_Trial_temp;
clear DL_Trial_temp;
clear t1;

combined_TT = synchronize(RP_TT, DL_TT, 'regular', 'linear', 'SampleRate', F_s);

% Set up final dataset ------

t = 1:length(combined_TT{:,1});   % Make time array of 1s intervals of the length of the dataset
t = t(:);   % Transpose T
dataset = timetable2table(combined_TT);
dataset.t = t;


% ---------------------------



