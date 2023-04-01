% plot(DataloggerRaw_Trial_4.t_DL, DataloggerRaw_Trial_4.P_DPT1);

RP_Trial5 = RP_Trial5_Raw;
DL_Trial5 = DL_Trial5_Raw;


% Convert RPi data timestamp from UNIX timestamp to MATLAB datetime variable
t_RP = datetime(RP_Trial5.epoch, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert DL data timestamp from a numerical timestamp to MATLAB datetime variable
t1 = compose('%.2f' , DL_Trial5.timestamp); % Convert number to string so it can be read by datetime function
t_DL = datetime(t1, 'InputFormat', 'yyyyMMddHHmmss.SS', 'Format', 'MM/dd/yy HH:mm:ss.SS');


RP_filtered = sgolayfilt(RP_Trial5.P_RPi, 3, 201);
DL_filtered = sgolayfilt(DL_Trial5.P_DPT, 3, 201);

RP_Trial5{:, 2:end} = sgolayfilt(RP_Trial5.P_RPi, 3, 201);

RP_TT = table2timetable(RP_Trial5);
DL_TT = table2timetable(DL_Trial5);
RP_TT = sortrows(RP_TT);
DL_TT = sortrows(DL_TT);
RP_TT = rmmissing(RP_TT);
DL_TT = rmmissing(DL_TT);
%RP_TT = unique(RP_TT);
%DL_TT = unique(DL_TT);

% FILTERING TEST -------------

F_s = 1; % Sample rate




Combined_TT = synchronize(RP_TT, DL_TT, 'regular', 'linear', 'SampleRate', F_s);


plot(RP_TT.epoch(1:15:end), RP_TT.P_RPi(1:15:end), ':');
hold on
plot(RP_TT.epoch, RP_filtered, '-');

% ---------------------------


%Combined_TT = synchronize(RPi_TT, DL_TT);
