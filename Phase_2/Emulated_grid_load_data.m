% Load raw data --------
filename = "8x8_trial_3.csv";


raw_table = readtable("raw_data\" + filename);
t_raw = raw_table{:,2};
O2_index = 7;
T_g_index = 11;
P_index = 8;
