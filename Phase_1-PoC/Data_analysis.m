% plot(DataloggerRaw_Trial_4.t_DL, DataloggerRaw_Trial_4.P_DPT1);

RP_Trial5 = RP_Trial5_Raw;
DL_Trial5 = DL_Trial5_Raw;


% Convert RPi data timestamp from UNIX timestamp to MATLAB datetime variable
RP_Trial5.t = datetime(RP_Trial5.t, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert DL data timestamp from a numerical timestamp to MATLAB datetime variable
t1 = compose('%.2f' , DL_Trial5.t); % Convert number to string so it can be read by datetime function
DL_Trial5.t = datetime(t1, 'InputFormat', 'yyyyMMddHHmmss.SS', 'Format', 'MM/dd/yy HH:mm:ss.SS');


RP_Trial5{:, 2:end} = sgolayfilt(RP_Trial5{:, 2:end}, 3, 201);
DL_Trial5{:, 2:end} = sgolayfilt(DL_Trial5{:, 2:end}, 3, 201);


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




combined_TT = synchronize(RP_TT, DL_TT, 'regular', 'linear', 'SampleRate', F_s);


%plot(combined_TT.timestamp, combined_TT{:, 2:end}, '-');
%hold on
%plot(RP_TT.Time, RP_filtered(:,3), ':');

% ---------------------------

t = 1:length(combined_TT{:,1});   % Make time array of 1s intervals of the length of the dataset
t = t(:);   % Transpose T
dataset = timetable2table(combined_TT);
dataset.t = t;

plot(dataset.t, combined_TT{:, ["T_probe", "T_RP"]}, '-');
hold on
legend("Datalogger Temperature", "Raspberry Pi Temperature");


%Combined_TT = synchronize(RPi_TT, DL_TT);
