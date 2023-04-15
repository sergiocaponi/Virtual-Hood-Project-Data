% Simple calorimetry

% Temperature and O2 conversions
T_g_kelvin = T_g +273;
O2_mass = O2 * 0.232/0.2095/100;

% Calculate gas velocity
gas_density = 1.2*273./T_g_kelvin;
vel = (abs(P)*2./gas_density).^0.5;

% Mass flow rate
mass_flow_rate = vel .* gas_density;

% Simple oxygen depletion calorimetry based on SFPE handbook, per unit area
Q_PUA =  13.1 * (mass_flow_rate * 0.232 - mass_flow_rate .* O2_mass)*1000;

% Integrating Q
Q = trapz(0.1, Q_PUA)



%% Plot

xv = linspace(min(x), max(x), 50);
yv = linspace(min(y), max(y), 50);

[xq,yq] = meshgrid(xv,yv);

tiles = tiledlayout(2,2);
title("Plots");

nexttile
O2_grid = griddata(x,y,O2,xq,yq);
surf(xq, yq, O2_grid);
title("Volumentric O2 concentration (%)");

nexttile
T_g_grid = griddata(x,y,T_g,xq,yq);
surf(xq, yq, T_g_grid);
title("Gas temperature (C)");

nexttile
P_grid = griddata(x,y,P,xq,yq);
surf(xq, yq, P_grid);
title("Differential Pressure (Pa)");

nexttile
HRRPUA_grid = griddata(x,y,Q_PUA,xq,yq);
surf(xq, yq, HRRPUA_grid);
title("Heat release rate per unit area (kW)");
