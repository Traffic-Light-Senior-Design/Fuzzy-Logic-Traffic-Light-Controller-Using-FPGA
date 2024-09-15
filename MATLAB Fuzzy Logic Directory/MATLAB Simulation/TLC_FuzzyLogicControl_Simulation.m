% Kevin Bui
% 9/1/24
% MATLAB Simulation Script for Fuzzy Logic Controller of Traffic Light Intersection

% Clears program upon each runtime
clc
close all

% Load FIS files for each direction (4 FIS files for 4 directions)
fis_MainNorth = readfis('L1_L2_L3_TrafficLightController.fis');
fis_MainSouth = readfis('L6_L7_L8_TrafficLightController.fis');
fis_SubEast = readfis('L4_L5_TrafficLightController.fis');
fis_SubWest = readfis('L9_TrafficLightController.fis');

% Simulation parameters
simTime = 300;          % seconds
dt = 1;                 % time step in seconds (iterating through loop)
time = 0:dt:simTime;    % vector of time steps (time values)

% Initialize traffic densities of the time values vector for each lane
density_L1 = zeros(size(time));
density_L2L3 = zeros(size(time));
density_L4 = zeros(size(time));
density_L5 = zeros(size(time));
density_L6 = zeros(size(time));
density_L7L8 = zeros(size(time));
density_L9 = zeros(size(time));

% Initial values
density_L1(1) = 0.3; % 30% initial density
density_L2L3(1) = 0.4;
density_L4(1) = 0.2;
density_L5(1) = 0.2;
density_L6(1) = 0.3;
density_L7L8(1) = 0.4;
density_L9(1) = 0.5;

% Allocating arrays for outputs
greenDurations = zeros(4, length(time));    % Array of 4 directions (MainNorth - 1, MainSouth - 2, SubEast - 3, SubWest - 4)
waitingTimes = zeros(4, length(time));      % Same as above
activeDirections = zeros(4, length(time));  % Same as above

% Initial setup
currentGroup = 1; % Start with MainNorth & MainSouth
elapsedTime = 0;  % Timer for the current green light duration

% Define the sequence
sequence = [1, 1, 2, 3]; % 1 for MainNorth & MainSouth, 2 for SubEast, 3 for SubWest

% Simulation loop
for t = 2:length(time)
    % Simulating traffic inflow using a random pattern with sine waves (randomly generated)
    inflow = 0.1 * (1 + sin(0.1 * time(t)) + 0.1 * randn());
    outflow = 0.05 * (1 + 0.1 * randn());
    
    % Update traffic densities based on inflow and outflow
    if currentGroup == 1 % MainNorth and MainSouth are green
        % Other direction's traffic densities will increase but not decrease
        density_L4(t) = max(0, min(1, density_L4(t-1) + inflow * 0.7));
        density_L5(t) = max(0, min(1, density_L5(t-1) + inflow));
        density_L9(t) = max(0, min(1, density_L9(t-1) + inflow));

        % MainNorth and MainSouth traffic densities increasing/decreasing
        density_L1(t) = max(0, min(1, density_L1(t-1) + inflow * 0.8 - outflow * greenDurations(1, t-1)/60));
        density_L2L3(t) = max(0, min(1, density_L2L3(t-1) + inflow - outflow * greenDurations(1, t-1)/60));
        density_L6(t) = max(0, min(1, density_L6(t-1) + inflow * 0.8 - outflow * greenDurations(2, t-1)/60));
        density_L7L8(t) = max(0, min(1, density_L7L8(t-1) + inflow - outflow * greenDurations(2, t-1)/60));
        activeDirections(:, t) = [1; 1; 0; 0]; % MainNorth and MainSouth are active

    elseif currentGroup == 2 % SubEast is green
        % Other direction's traffic densities will increase but not decrease
        density_L1(t) = max(0, min(1, density_L1(t-1) + inflow * 0.8));
        density_L2L3(t) = max(0, min(1, density_L2L3(t-1) + inflow));
        density_L6(t) = max(0, min(1, density_L6(t-1) + inflow * 0.8));
        density_L7L8(t) = max(0, min(1, density_L7L8(t-1) + inflow));
        density_L9(t) = max(0, min(1, density_L9(t-1) + inflow));

        % SubEast traffic densities increasing/decreasing
        density_L4(t) = max(0, min(1, density_L4(t-1) + inflow * 0.7 - outflow * greenDurations(3, t-1)/60));
        density_L5(t) = max(0, min(1, density_L5(t-1) + inflow - outflow * greenDurations(3, t-1)/60));
        activeDirections(:, t) = [0; 0; 1; 0]; % SubEast is active

    elseif currentGroup == 3 % SubWest is green
        % Other direction's traffic densities will increase but not decrease
        density_L1(t) = max(0, min(1, density_L1(t-1) + inflow * 0.8));
        density_L2L3(t) = max(0, min(1, density_L2L3(t-1) + inflow));
        density_L6(t) = max(0, min(1, density_L6(t-1) + inflow * 0.8));
        density_L7L8(t) = max(0, min(1, density_L7L8(t-1) + inflow));
        density_L4(t) = max(0, min(1, density_L4(t-1) + inflow * 0.7));
        density_L5(t) = max(0, min(1, density_L5(t-1) + inflow));

        % SubWest traffic densities increasing/decreasing
        density_L9(t) = max(0, min(1, density_L9(t-1) + inflow - outflow * greenDurations(4, t-1)/60));
        activeDirections(:, t) = [0; 0; 0; 1]; % SubWest is active
    end

    % Calculate green light durations using FIS based on current densities
    greenDurations(1, t) = evalfis(fis_MainNorth, [density_L1(t), density_L2L3(t)]);
    greenDurations(2, t) = evalfis(fis_MainSouth, [density_L6(t), density_L7L8(t)]);
    greenDurations(3, t) = evalfis(fis_SubEast, [density_L4(t), density_L5(t)]);
    greenDurations(4, t) = evalfis(fis_SubWest, density_L9(t));
    
    % Update waiting times (if a direction is not active, waiting time accumulates)
    % (WORK IN PROGRESS)

    %for i = 1:4
    %    if activeDirections(i, t) == 0
    %        waitingTimes(i, t) = waitingTimes(i, t-1) + dt;
    %    else
    %        waitingTimes(i, t) = 0; % reset waiting time when direction is active
    %    end
    %end

    % Updating the timer and check if it needs to switch directions
    elapsedTime = elapsedTime + dt;
    if elapsedTime >= greenDurations(currentGroup, t)
        % Time to switch direction
        elapsedTime = 0;
        % Move to next direction in sequence
        currentGroup = mod(currentGroup, length(sequence)) + 1;
    end
end

% Plot traffic densities for each direction
figure;
plot(time, density_L1, 'b', time, density_L2L3, 'r');
hold on;
title('Traffic Density - MainNorth');
xlabel('Time (s)');
ylabel('Density (0 to 1)');
legend('L1', 'L2+L3');

figure;
plot(time, density_L6, 'b', time, density_L7L8, 'r');
hold on;
title('Traffic Density - MainSouth');
xlabel('Time (s)');
ylabel('Density (0 to 1)');
legend('L6', 'L7+L8');

figure;
plot(time, density_L4, 'b', time, density_L5, 'r');
hold on;
title('Traffic Density - SubEast');
xlabel('Time (s)');
ylabel('Density (0 to 1)');
legend('L4', 'L5');

figure;
plot(time, density_L9, 'b');
hold on;
title('Traffic Density - SubWest');
xlabel('Time (s)');
ylabel('Density (0 to 1)');
legend('L9');

% Plot green light durations for each direction
figure;
subplot(2,2,1);
plot(time, greenDurations(1, :), 'g');
title('Green Light Duration - MainNorth');
xlabel('Time (s)');
ylabel('Duration (s)');

subplot(2,2,2);
plot(time, greenDurations(2, :), 'g');
title('Green Light Duration - MainSouth');
xlabel('Time (s)');
ylabel('Duration (s)');

subplot(2,2,3);
plot(time, greenDurations(3, :), 'g');
title('Green Light Duration - SubEast');
xlabel('Time (s)');
ylabel('Duration (s)');

subplot(2,2,4);
plot(time, greenDurations(4, :), 'g');
title('Green Light Duration - SubWest');
xlabel('Time (s)');
ylabel('Duration (s)');

% Plot the green light status for each direction
figure;

% Subplot for MainNorth
subplot(4,1,1);
stairs(time, activeDirections(1, :), 'LineWidth', 2);
ylim([-0.1, 1.1]);
yticks([0 1]);
yticklabels({'Off', 'On'});
title('Green Light Status - MainNorth');
xlabel('Time (s)');
ylabel('Status');

% Subplot for MainSouth
subplot(4,1,2);
stairs(time, activeDirections(2, :), 'LineWidth', 2);
ylim([-0.1, 1.1]);
yticks([0 1]);
yticklabels({'Off', 'On'});
title('Green Light Status - MainSouth');
xlabel('Time (s)');
ylabel('Status');

% Subplot for SubEast
subplot(4,1,3);
stairs(time, activeDirections(3, :), 'LineWidth', 2);
ylim([-0.1, 1.1]);
yticks([0 1]);
yticklabels({'Off', 'On'});
title('Green Light Status - SubEast');
xlabel('Time (s)');
ylabel('Status');

% Subplot for SubWest
subplot(4,1,4);
stairs(time, activeDirections(4, :), 'LineWidth', 2);
ylim([-0.1, 1.1]);
yticks([0 1]);
yticklabels({'Off', 'On'});
title('Green Light Status - SubWest');
xlabel('Time (s)');
ylabel('Status');

% Adjust the layout for better viewing
sgtitle('Green Light Status Over Time');

% Display average green durations and waiting times
avgGreenDurations = mean(greenDurations, 2);
%avgWaitingTimes = mean(waitingTimes, 2);
disp('Average Green Light Durations (s):');
disp(avgGreenDurations');
%disp('Average Waiting Times (s):');
%disp(avgWaitingTimes');
