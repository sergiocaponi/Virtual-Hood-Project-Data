% plot(DataloggerRaw_Trial_4.t_DL, DataloggerRaw_Trial_4.P_DPT1);

RP_Trial5 = RP_Trial5_Raw;
DL_Trial5 = DL_Trial5_Raw;


% Convert RPi data timestamp from UNIX timestamp to MATLAB datetime variable
t_RP = datetime(RP_Trial5.epoch, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert DL data timestamp from a numerical timestamp to MATLAB datetime variable
t1 = compose('%.2f' , DL_Trial5.timestamp); % Convert number to string so it can be read by datetime function
t_DL = datetime(t1, 'InputFormat', 'yyyyMMddHHmmss.SS', 'Format', 'MM/dd/yy HH:mm:ss.SS');


RP_filtered = sgolayfilt(RP_Trial5{:, 2:end}, 3, 201);
DL_filtered = sgolayfilt(DL_Trial5{:, 2:end}, 3, 201);


RP_TT = array2timetable(RP_filtered, 'RowTimes', t_RP);
DL_TT = array2timetable(DL_filtered, 'RowTimes', t_DL);
RP_TT = sortrows(RP_TT);
DL_TT = sortrows(DL_TT);
RP_TT = rmmissing(RP_TT);
DL_TT = rmmissing(DL_TT);
%RP_TT = unique(RP_TT);
%DL_TT = unique(DL_TT);

% FILTERING TEST -------------

F_s = 1; % Sample rate




combined_TT = synchronize(RP_TT, DL_TT, 'regular', 'linear', 'SampleRate', F_s);


plot(combined_TT.Time, combined_TT{:, 2:end}, '-');
hold on
%plot(RP_TT.Time, RP_filtered(:,3), ':');

% ---------------------------

final_dataset = combined_TT{:,:};
t = 1:length(final_dataset(:,1));
t = t(:);
final_dataset = [t final_dataset];


%Combined_TT = synchronize(RPi_TT, DL_TT);

