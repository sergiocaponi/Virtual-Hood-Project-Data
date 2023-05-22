% Define the constants
num_points = 64;
x_step_time = 2.95;
y_step_time = 3.4;
x_step = 100;
y_step = 100;
wait_time = 20;
start_time = 0;

lim = sqrt(num_points)-1;

% Initialize the matrix
timing_matrix = zeros(num_points * 2, 3);

% Initialize the variables
x = 0;
y = 0;


% Set first position
end_time = start_time + wait_time;
time = end_time;
timing_matrix(2,:) = [end_time x y];

% Loop over all the points
for i = 2:num_points
    
    % Update the x and y coordinates
    if mod(y, 2*y_step) == 0 % Even row, move right
        if x == lim*x_step
            y = y + y_step; % Move down
            start_time = time + y_step_time;
        else
            x = x + x_step;
            start_time = time + x_step_time;
        end
    else % Odd row, move left
        if x == 0
            y = y + y_step; % Move down
            start_time = time + y_step_time;
        else
            x = x - x_step;
            start_time = time + x_step_time;
        end
    end
    
    % Calculate the start and end times for the current point
    end_time = start_time + wait_time;
    
    % Store the start and end times in the matrix
    timing_matrix((i-1)*2+1,:) = [start_time x y];
    timing_matrix(i*2,:) = [end_time x y];

    % Update the time variable
    time = end_time;
end

%clearvars -except timing_matrix;
