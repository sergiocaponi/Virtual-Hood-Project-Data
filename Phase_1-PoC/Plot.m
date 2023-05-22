% Plot temperature data

tiledlayout(2,1);

T_error = (combined_TT{:, "T_RP"} - combined_TT{:, "T_probe"})./combined_TT{:, "T_probe"}*100;
T_smooth_error = smoothdata(T_error, 1, "movmedian", 250);

P_error = (combined_TT{:, "P_RP"} - combined_TT{:, "P_DL"})./combined_TT{:, "P_DL"}*100;
P_smooth_error = smoothdata(P_error, 1, "movmedian", 250);

title("Preliminary review trial 5: Data-logger package and DAQ data comparison");




nexttile
yyaxis right
plot(dataset.t, T_smooth_error, "-", "Color",	"#D95319");
hold on
plot(dataset.t, T_error, "--", "Color",	[0.8500 0.3250 0.0980 0.5]);
ylim([-20,50]);
ylabel("Relative error [%]")
yyaxis left
plot(dataset.t, combined_TT{:, "T_probe"}, "-", "Color", "#0072BD");
plot(dataset.t, combined_TT{:, "T_RP"}, "-","Color", "#7E2F8E");
ylabel("Temperature [°C]")
legend("DAQ Temperature", "DLP Temperature", "Error");
xlabel("Experiment elapsed time [s]")

title("Temperature data")


nexttile
yyaxis right
plot(dataset.t, P_smooth_error, "-", "Color",	"#D95319");
hold on
plot(dataset.t, P_error, "--", "Color",	[0.8500 0.3250 0.0980 0.5]);
ylim([-100,100]);
ylabel("Relative error [%]")
yyaxis left
plot(dataset.t, combined_TT{:, "P_DL"}, "-", "Color", "#0072BD");
plot(dataset.t, combined_TT{:, "P_RP"}, "-","Color", "#7E2F8E");
ylabel("Pressure [Pa]")
legend("DAQ Pressure", "DLP Pressure", "Error");
xlabel("Experiment elapsed time [s]")

title("Pressure data")