%% PLOT CONTOUR PLOT OF LOCAL HEAT RELEASE RATES
% First run:
% - gen_timing
% - Emulated_grid_load_data
% - eoc_drift_correction_new
% - parse_data
% - calorimetry

tiles = tiledlayout(2,2);
title(tiles, "Trial results: local HRRs per unit area (4 to 7)");

nexttile
contourf(xq1, yq1, Q_PUA_grid4)
title("Trial 2 (Total: " + round(Q4, 1) + "kW)")
ylabel("y coordinate")
xlabel("x coordinate")

nexttile
contourf(xq1, yq1, Q_PUA_grid5)
title("Trial 3 (Total: " + round(Q5, 1) + "kW)")
%ylabel("y coordinate")
xlabel("x coordinate")

colorbar

nexttile
contourf(xq2, yq2, Q_PUA_grid6)
title("Trial 6 (Total: " + round(Q6, 1) + "kW)")
ylabel("y coordinate")
xlabel("x coordinate")

nexttile
contourf(xq2, yq2, Q_PUA_grid7)
title("Trial 7 (Total: " + round(Q7, 1) + "kW)")
%ylabel("y coordinate")
xlabel("x coordinate")

colorbar
