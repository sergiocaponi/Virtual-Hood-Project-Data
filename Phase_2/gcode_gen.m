% Define G-code commands
dwell_cmd = "G04";  % Rapid positioning command
move_cmd = "G01";  % Linear interpolation command
x_step = 100;
y_step = 100;

% Define movement speed
feed_rate = 5000;  % mm/min

% Generate G-code commands for each point
gcode1 = sprintf("%s X%d Y%d F%.0f\n", move_cmd, 0, 0, feed_rate);
wait_time = timing_matrix(2, 1) - timing_matrix(1, 1);
gcode2 = sprintf("%s P%d\n", dwell_cmd, round(wait_time));  % Pause for point duratio

fprintf(gcode1);  % Print G-code command to console (or file)
fprintf(gcode2);  % Print G-code command to console (or file)

for i = 1:(size(timing_matrix, 1)/2 - 1)
    i = i*2+1;
    x = timing_matrix(i, 2);
    y = timing_matrix(i, 3);
    start_time = timing_matrix(i, 1);
    end_time = timing_matrix(i+1, 1);

    dx = abs(timing_matrix(i-1, 2) - timing_matrix(i, 2));
    dy = abs(timing_matrix(i-1, 3) - timing_matrix(i, 3));
    d = sqrt(dx^2 + dy^2);

    dt = start_time - timing_matrix(i-1, 1);

    %feed_rate = d/dt*60;

    wait_time = end_time - start_time;
    gcode1 = sprintf("%s X%d Y%d F%.0f\n", move_cmd, x, y, feed_rate);
    gcode2 = sprintf("%s P%d\n", dwell_cmd, round(wait_time));  % Pause for point duration

    fprintf(gcode1);  % Print G-code command to console (or file)
    fprintf(gcode2);  % Print G-code command to console (or file)
end

gcode1 = sprintf("%s X%d Y%d F%.0f\n", move_cmd, 0, y, feed_rate);
gcode2 = sprintf("%s X%d Y%d F%.0f\n", move_cmd, 0, 0, feed_rate);

fprintf(gcode1);  % Print G-code command to console (or file)
fprintf(gcode2);  % Print G-code command to console (or file)

clearvars -except timing_matrix;
