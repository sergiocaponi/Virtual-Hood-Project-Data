raw_table = readtable("raw_data\8x8_trial_2.csv");
t = raw_table{:,2};
O2_index = 7;
T_g_index = 11;
P_index = 8;
T_o2_index = 9;

o2 = raw_table{:, O2_index};
T_g = raw_table{:, T_g_index};
P = raw_table{:, P_index};
T_o2 = raw_table{:, T_o2_index};

plot(t, o2, t, T_g, t, T_o2);