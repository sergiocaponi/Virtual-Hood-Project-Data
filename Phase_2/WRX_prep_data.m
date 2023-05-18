% Prepare raw data --------
RP_data_name = "trial2_0704.csv";
DL_data_name = "trial2_0704.csv";
i_start = 1;
i_end = 0;

RP_raw_table = readtable("raw_data\" + RP_data_name);
DL_raw_table = readtable("raw_data\" + DL_data_name);


% Convert RPi data timestamp from UNIX timestamp to MATLAB datetime variable
RP_raw_table.Var1 = datetime(RP_raw_table.Var1, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');

% Convert DL data timestamp from a numerical timestamp to MATLAB datetime variable
t1 = compose('%.2f' , DL_raw_table.Var1); % Convert number to string so it can be read by datetime function
DL_raw_table.Var1 = datetime(DL_raw_table.Var1, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SS');
%DL_raw_table.Var1 = datetime(t1, 'InputFormat', 'yyyyMMddHHmmss.SS', 'Format', 'MM/dd/yy HH:mm:ss.SS');


% Filter the data ---------

RP_raw_table{:, 2:end} = sgolayfilt(RP_raw_table{:, 2:end}, 2, 3);
DL_raw_table{:, 2:end} = sgolayfilt(DL_raw_table{:, 2:end}, 2, 3);

% Convert and clean up ----

RP_TT = table2timetable(RP_raw_table);
DL_TT = table2timetable(DL_raw_table);

RP_TT = removevars(RP_TT, "Var2");
DL_TT = removevars(DL_TT, "Var2");
RP_TT = sortrows(RP_TT);
DL_TT = sortrows(DL_TT);
RP_TT = rmmissing(RP_TT);
DL_TT = rmmissing(DL_TT);
%RP_TT = unique(RP_TT);
%DL_TT = unique(DL_TT);

% Synchronise --------------

F_s = 1; % Sample rate

combined_TT = synchronize(RP_TT, DL_TT, 'regular', 'linear', 'SampleRate', F_s);

% Set up final dataset ------

t = 1:length(combined_TT{:,1});   % Make time array of 1s intervals of the length of the dataset
t = t(:);   % Transpose T
dataset = timetable2table(combined_TT);
dataset.Var1 = t;


% ---------------------------



