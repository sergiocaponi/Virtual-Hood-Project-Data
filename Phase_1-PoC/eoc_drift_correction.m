%% Config
%drift_correction_offset = 0.025;
max_degree = 10;                 % Degree of polynomial for drift correction
%tolerance = 0.0;            % Set a tolerance for the distance from the polynomial fit


O2 = dataset.O2;

% Create polynomial to characterise drift
[~,~,drift_poly] = RobustDetrend(O2, max_degree, 0.95, t');

% Correct the data by subtracting the drift from it
corrected_O2 = O2 - drift_poly + 20.95;

dataset.O2 = corrected_O2;

% Plot the datasets
f = figure;
plot(O2, LineWidth=0.6)
hold on
%plot(polynomial_fit)
%plot(drift_dataset)
plot(drift_poly, LineWidth=0.9)
plot(corrected_O2, LineWidth=0.6)
ylim([15,21.5]);
title("Trial 2");
legend('Raw data', 'Drift Polynomial', 'Corrected Data');
ylabel("O_2 volume fraction [%]");
xlabel("Time since experiment start [s]");

fontsize(f, "scale", 1.2);