raw_table = readtable("raw_data\trial6.csv");
t = raw_table{:,2};
O2_index = 7;
T_g_index = 11;
P_index = 8;
T_o2_index = 9;

o2 = raw_table{:, O2_index};

T_g = raw_table{:, T_g_index};
P = raw_table{:, P_index};
T_o2 = raw_table{:, T_o2_index};

yyaxis left
ylabel("Volumetric O_2 Concentration [%]")
plot(t, o2);
hold on
yyaxis right
ylabel("Temperature [C]")
plot(t, T_g, t, T_o2);

legend("O_2 Concentration", "Gas temperature T_g", "EOC Temperature")