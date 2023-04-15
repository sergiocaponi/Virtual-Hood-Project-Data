


% Initialize the final matrix to store the average values
final_matrix = zeros(8,8);

% Loop through each point in the time matrix
for i = 1:size(time_matrix,1)/2
    
    % Get the x and y coordinates for the current point
    x = time_matrix(i*2-1,2);
    y = time_matrix(i*2-1,3);
    
    % Get the start and end times for the current point
    start_time = time_matrix(i*2-1,1);
    end_time = time_matrix(i*2,1);
    
    % Get the raw data for the current time window
    data_window = raw_data{raw_data{:,1} > start_time & raw_data{:,1} < end_time, 2};
    
    % Calculate the average value and store it in the final matrix
    final_matrix(y+1, x+1) = mean(data_window);
end

% plot the data matrix as a heatmap
figure;
imagesc(final_matrix);
colormap(flipud(hot));
colorbar;