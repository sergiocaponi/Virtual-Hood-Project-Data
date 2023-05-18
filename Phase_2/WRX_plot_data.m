% Config


t = dataset{:,1};
V_pump_index = 2;
V_batt_index = 3;
T_cpu_index = 4;
T_pcb_index = 5;
O2_index = 6;
P_index = 7;
T_o2_index = 8;
T_gK_index = 9;
T_g_index = 10;
T_w_index = 11;

if i_end == 0
    i_end = length(t);
end

V_batt = dataset{i_start:i_end, V_batt_index};
T_cpu = dataset{i_start:i_end, T_cpu_index};
T_pcb = dataset{i_start:i_end, T_pcb_index};
o2 = dataset{i_start:i_end, O2_index};
P = dataset{i_start:i_end, P_index};
T_o2 = dataset{i_start:i_end, T_o2_index};
T_g = dataset{i_start:i_end, T_g_index};
T_w = dataset{i_start:i_end, T_w_index};




tiles = tiledlayout(3,1);
title(tiles, "Water-reservoir Exchanger Trial 2 Data");

nexttile
title("O_2 Concentration");
plot(t, o2, 'k');
xlim([0,600]);
%xlabel("Time (t) [s]")
ylabel("O_2 Concentration [%]")

legend("Volumetric O_2 Concentration", 'Location', 'southoutside')


nexttile
xlim([0,600]);
yyaxis left
plot(t, T_g);
ylabel("Temperature [°C]")
hold on
%xlabel("Time (t) [s]")

yyaxis right
plot(t, P);
ylabel("Differential Pressure [Pa]")

legend("Gas temperature (T_g)", "Differential pressure (P)", 'Location', 'southoutside', 'NumColumns', 2)

nexttile
xlim([0,600]);
yyaxis right
plot(t, V_batt);
ylabel("Voltage [V]")
hold on
yyaxis left
plot(t, T_o2);
plot(t, T_w);
plot(t, T_cpu);
plot(t, T_pcb);
ylabel("Temperature [°C]")
xlabel("Time (t) [s]")

legend("EOC sampling point temp.", "Water temperature", "CPU temperature", "PCB Temperature", "Battery voltage", ...
    'Location', 'southoutside', 'NumColumns', 3)


%fontsize(tiles, "scale", 1.2)


