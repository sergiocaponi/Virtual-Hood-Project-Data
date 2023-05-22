%%% Config
%drift_correction_offset = 0.025;
max_degree = 9;                 % Degree of polynomial for drift correction
%tolerance = 0.0;            % Set a tolerance for the distance from the polynomial fit
sz = 10;

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

%plot(O2)
%hold on

error = zeros(sz,1);

for i = 1:sz
    % Create polynomial to characterise drift
    [~,~,drift_poly] = RobustDetrend(O2, i, 0.95, t_raw);
    
    % Correct the data by subtracting the drift from it
    corrected_O2 = O2 - drift_poly;

    absolute_o2 = abs(corrected_O2);
    %plot(absolute_o2);
    error(i) = trapz(absolute_o2);

    %plot(drift_poly)
end

[min_acc, degree] = min(error)

% Create polynomial to characterise drift
[~,~,drift_poly] = RobustDetrend(O2, max_degree, 0.95, t_raw);

% Correct the data by subtracting the drift from it
corrected_O2 = O2 - drift_poly + 20.95;
%plot(corrected_O2)

%legend('Old','1','2', '3','4','5','6','7','8','9','10', 'New')

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