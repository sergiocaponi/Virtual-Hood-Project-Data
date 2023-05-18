%%% Config
%drift_correction_offset = 0.025;
max_degree = 10;                 % Degree of polynomial for drift correction
%tolerance = 0.0;            % Set a tolerance for the distance from the polynomial fit


O2 = raw_table{:, O2_index};


% % Fit a first polynomial to the raw data
% p = polyfit(1:length(O2), O2, max_degree);
% polynomial_fit = polyval(p, 1:length(O2));
% 
% % Create a new dataset with values below the polynomial removed and replaced with interpolated values
% drift_dataset = O2;
% for i = 1:length(O2)
%     if O2(i) - polynomial_fit(i) < -tolerance
%         drift_dataset(i) = NaN; % Remove the value if it is below the polynomial fit
%     end
% end
% drift_dataset = fillmissing(drift_dataset, 'linear'); % Interpolate missing values
% 
% % Fit a new polynomial (the drift correction polynomial) to the new dataset
% p = polyfit(1:length(drift_dataset), drift_dataset, max_degree);
% drift = polyval(p, 1:length(drift_dataset)) + drift_correction_offset;

% Create polynomial to characterise drift
[~,~,drift_poly] = RobustDetrend(O2, max_degree, 0.95, t_raw);

% Correct the data by subtracting the drift from it
corrected_O2 = O2 - drift_poly + 20.95;

raw_table{:,O2_index} = corrected_O2;

% Plot the datasets
f = figure;
plot(O2, LineWidth=0.6)
hold on
%plot(polynomial_fit)
%plot(drift_dataset)
plot(drift_poly, LineWidth=0.9)
plot(corrected_O2, LineWidth=0.6)
ylim([18.5,21.5]);
title("Trial 2");
legend('Raw data', 'Drift Polynomial', 'Corrected Data');
ylabel("O_2 volume fraction [%]");
xlabel("Time since experiment start [s]");

fontsize(f, "scale", 1.2);
