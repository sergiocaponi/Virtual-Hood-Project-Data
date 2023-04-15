% Plot temperature data

tiledlayout(2,1);

nexttile
plot(dataset.t, combined_TT{:, ["T_probe", "T_RP"]}, '-');
hold on
legend("Datalogger Temperature", "Raspberry Pi Temperature");

nexttile
plot(dataset.t, combined_TT{:, ["P_DL", "P_RP"]}, '-');
hold on
legend("Datalogger Pressure", "Raspberry Pi Pressure");


