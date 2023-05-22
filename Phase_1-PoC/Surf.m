data = pt_dataset;



minDist = min(data.Distance.* 10);
maxDist = max(data.Distance.* 10);



%r = linspace(minDist, maxDist, numR);
%interpolatedTemp = interp1(data.Distance, data.T_RP, interpolatedDist, 'spline');

r = data.Distance .* 10;
T_g = data.T_RP;
O2 = data.O2;
P = data.P_RP;


% Step 5: Create the grid
numTh = 90; % Number of angles for the grid
th = linspace(0, 2*pi, numTh);
[R, TH] = meshgrid(r, th);
T_g = repmat(T_g', numTh, 1);
O2 = repmat(O2', numTh, 1);
P = repmat(P', numTh, 1);

[x, y] = pol2cart(TH, R, T_g);



%%
O2 = O2 * 20.95/16.735;
% Temperature and O2 conversions
T_g_kelvin = T_g + 273;
T_amb = min(T_g_kelvin);
O2_mass = O2 * 0.232/0.2095/100;

% Pressure value correction
P_offset = P;

% Calculate gas density and velocity
gas_density = 1.2*T_amb./T_g_kelvin;
vel = (abs(P_offset)*2./gas_density).^0.5;

% Mass flow rate
mass_flow_rate = vel .* gas_density;


% Simple oxygen depletion calorimetry per unit area (in kW/m2)
Q_PUA =  13.1 * 1000 * (mass_flow_rate * 0.232 - mass_flow_rate .* O2_mass);

%%



xv = linspace(-maxDist, maxDist, 30);
yv = linspace(-maxDist, maxDist, 30);



% Step 6: Plot the interpolated temperature values on the grid

[xq,yq] = meshgrid(xv,yv);
Q_PUA_grid = griddata(x,y,Q_PUA,xq,yq,"cubic");

toremove = isnan(Q_PUA_grid);
Q_PUA_grid(toremove) = 0;
% FINAL INTEGRATION:
Q = trapz(yv,trapz(xv,Q_PUA_grid,2));
Q = Q/(1000^2)  % Convert from mm^2 to m^2



%% Plot values:

tiles = tiledlayout(1,1);
%title(tiles, "Trial 5 Results")
%title(tiles, "Trial 5 Results", "Calculated Total Heat Release Rate: " + round(Q, 1) + "kW");

% nexttile
% contour(x, y, O2, O2(1,:), 'ShowText','on', 'LabelSpacing', 10000, "LabelFormat","%0.1f");
% grid on
% title("Volumetric O_2 concentration [%]");
% %xlabel("Distance in x-axis [mm]");
% %ylabel("Distance in y-axis [mm]");
% zlabel("O_2 volume fraction [%]");
% 
% nexttile
% contour(x, y, T_g, 5, 'ShowText','on', 'LabelSpacing', 10000, "LabelFormat","%0.0f");
% grid on
% %surf(xq, yq, T_g_grid);
% title("Gas temperature [°C]");
% zlabel("Temperature [°C]");
% 
% nexttile
% [C, h] = contour(x, y, P, 5, 'ShowText','on', 'LabelSpacing', 10000, "LabelFormat","%0.3f");
% title("Bi-directional Vel. Probe Pressure [Pa]");
% grid on
% zlabel("Differential Pressure [Pa]");

% nexttile
surf(xq, yq, Q_PUA_grid);
title("Heat release rate over sampled area");
grid on
zlabel("HRR per unit area [kW/m^2]");


fontsize(tiles, "scale", 1.2);
set(gcf, 'Renderer', 'painters')