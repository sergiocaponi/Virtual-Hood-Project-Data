% Initialize the final vectors to store average values:
sz = size(timing_matrix,1)/2;
final_matrix = zeros(sz, 3);
x = zeros(sz,1);
y = zeros(sz,1);
O2 = zeros(sz,1);
T_g = zeros(sz,1);
P = zeros(sz,1);



%% Loop through each point in the time matrix
for i = 1:size(timing_matrix,1)/2
    
    % Get the x and y coordinates for the current point
    x(i) = timing_matrix(i*2-1,2);
    y(i) = timing_matrix(i*2-1,3);
    
    % Get the start and end times for the current point
    start_time = timing_matrix(i*2-1,1);
    end_time = timing_matrix(i*2,1);
    
    % Get the raw data for the current time window
    window = t_raw(:,1) > start_time & t_raw(:,1) < end_time;
    
    % Calculate the average value and store it in the final matrix
    %final_matrix(i, 1) = x_pt;
    %final_matrix(i, 2) = y_pt;

    O2(i) = mean(corrected_O2(window));
    T_g(i) = mean(raw_table{window, T_g_index});
    P(i) = mean(raw_table{window, P_index});
end

% plot the data matrix as a heatmap
%figure;
%imagesc(final_matrix);
%colormap(flipud(hot));
%colorbar;


xv = linspace(min(x), max(x), 50);
yv = linspace(min(y), max(y), 50);

[xq,yq] = meshgrid(xv,yv);

tiles = tiledlayout(2,2);
title("Plots");

nexttile
O2_grid = griddata(x,y,O2,xq,yq);
surf(xq, yq, O2_grid);

nexttile
T_g_grid = griddata(x,y,T_g,xq,yq);
surf(xq, yq, T_g_grid);

nexttile
P_grid = griddata(x,y,P,xq,yq);
surf(xq, yq, P_grid);








