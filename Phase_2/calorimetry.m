% Code to perform simple calorimetry
% 
% Basic formulae based on simple ideal gas equation for gas density,
% McCafferey's Bi-Directional Velocity Probe and its equation for gas
% velocity
% 
% Calorimetry based on SFPE handbook and "Fire Calorimetry" handbook by
% NIST (1995)
% ------------------------------------------------------------------------

% Config
DPT_offset = 0;
grid_sz_x = 50; % Used for plotting, can be arbitrary
grid_sz_y = 50; %


% Temperature and O2 conversions
T_g_kelvin = T_g + 273;
T_amb = min(T_g_kelvin);
O2_mass = O2 * 0.232/0.2095/100;

% Pressure value correction
P_offset = P + DPT_offset;

% Calculate gas density and velocity
gas_density = 1.2*T_amb./T_g_kelvin;
vel = (abs(P_offset)*2./gas_density).^0.5;

% Mass flow rate
mass_flow_rate = vel .* gas_density;


% Simple oxygen depletion calorimetry per unit area (in kW/m2)
Q_PUA =  13.1 * 1000 * (mass_flow_rate * 0.232 - mass_flow_rate .* O2_mass);


%% Create grid matrices of the values:
% This section should still be usable even if arrays are not equally
% spaced, as long as the x and y variables contain the point coordinates of
% each measurement point.

% Create equally spaced linear arrays
xv = linspace(min(x), max(x), grid_sz_x);
yv = linspace(min(y), max(y), grid_sz_y);

% Make a 2 mesh matrices of those values (one is the transposition of the
% other)
[xq,yq] = meshgrid(xv,yv);

% Create grid matrices for each measurement. Last option defines
% interpolation type
O2_grid = griddata(x,y,O2,xq,yq,"cubic");
T_g_grid = griddata(x,y,T_g,xq,yq,"cubic");
P_grid = griddata(x,y,P_offset,xq,yq,"cubic");
Q_PUA_grid = griddata(x,y,Q_PUA,xq,yq,"cubic");


% FINAL INTEGRATION:
Q = trapz(yv,trapz(xv,Q_PUA_grid,2));
Q = Q/(1000^2)  % Convert from mm^2 to m^2



%% Plot values:

tiles = tiledlayout(2,2);
title(tiles, "Trial Results", "Calculated Total Heat Release Rate: " + round(Q, 1) + "kW");

nexttile
surf(xq, yq, O2_grid);
title("Volumetric O_2 concentration");
%xlabel("Distance in x-axis [mm]");
%ylabel("Distance in y-axis [mm]");
zlabel("O_2 volume fraction [%]");

nexttile
surf(xq, yq, T_g_grid);
title("Gas temperature");
zlabel("Temperature [°C]");

nexttile
surf(xq, yq, P_grid);
title("Bi-directional Vel. Probe Pressure");
zlabel("Differential Pressure [Pa]");

nexttile
surf(xq, yq, Q_PUA_grid);
title("Heat release rate over sampled area");
zlabel("HRR per unit area [kW/m^2]");


set(gcf, 'Renderer', 'painters')

