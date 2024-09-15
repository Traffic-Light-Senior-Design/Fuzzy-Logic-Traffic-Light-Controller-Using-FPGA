
---

# Fuzzy Logic Traffic Light Controller Simulation

The simulation file, `TLC_FuzzyLogicControl_Simulation.m`, is a MATLAB script designed to test and visualize the behavior of the traffic light controller based on the four Fuzzy Inference System (FIS) files. This simulation provides a detailed performance analysis of the fuzzy logic controller for different traffic conditions and lane inputs.

## Purpose of the Simulation

The simulation serves the following purposes:
1. **Verification of the Fuzzy Logic System**: Ensures that the FIS files respond correctly to varying traffic densities.
2. **Performance Analysis**: Measures how well the fuzzy controller adapts to different traffic conditions, including light, moderate, and heavy traffic.
3. **Visualization**: Provides a clear visualization of the inputs (traffic densities) and corresponding outputs (green light durations) for each direction at the intersection.

This simulation helps in understanding how the fuzzy logic traffic light controller dynamically adjusts based on real-time traffic conditions and validates the effectiveness of the rule base and membership functions defined in each FIS file.

## MATLAB Simulation Structure

### 1. Initial Setup

The simulation starts by loading the FIS files for each traffic lane:
- `L1_L2_L3_TrafficLightController.fis`
- `L4_L5_TrafficLightController.fis`
- `L6_L7_L8_TrafficLightController.fis`
- `L9_TrafficLightController.fis`

These files are essential for calculating the green light duration based on the traffic density inputs.

```matlab
fis_L1_L2_L3 = readfis('L1_L2_L3_TrafficLightController.fis');
fis_L4_L5 = readfis('L4_L5_TrafficLightController.fis');
fis_L6_L7_L8 = readfis('L6_L7_L8_TrafficLightController.fis');
fis_L9 = readfis('L9_TrafficLightController.fis');
```

### 2. Inputs

The simulation accepts different traffic density values as inputs for each lane. These densities can be manually adjusted to simulate various real-world traffic conditions:
- **L1, L2+L3**: Main Northbound lanes
- **L4, L5**: Sub Eastbound lanes
- **L6, L7+L8**: Main Southbound lanes
- **L9**: Sub Westbound lane

The input densities are represented as values between 0 (no traffic) and 1 (maximum congestion).

Example input setup:
```matlab
traffic_density_L1 = 0.6;  % Medium traffic in L1
traffic_density_L2_L3 = 0.8;  % High traffic in L2 and L3
traffic_density_L4_L5 = 0.4;  % Low to medium traffic in L4 and L5
traffic_density_L6 = 0.5;  % Medium traffic in L6
traffic_density_L7_L8 = 0.9;  % High traffic in L7 and L8
traffic_density_L9 = 0.3;  % Low traffic in L9
```

These inputs are passed to the corresponding FIS files to compute the green light duration for each direction.

### 3. FIS Evaluation

The FIS files process the traffic density inputs and output the green light duration. The `evalfis` function is used to evaluate the FIS for each set of inputs.

```matlab
green_duration_L1_L2_L3 = evalfis([traffic_density_L1, traffic_density_L2_L3], fis_L1_L2_L3);
green_duration_L4_L5 = evalfis([traffic_density_L4_L5], fis_L4_L5);
green_duration_L6_L7_L8 = evalfis([traffic_density_L6, traffic_density_L7_L8], fis_L6_L7_L8);
green_duration_L9 = evalfis([traffic_density_L9], fis_L9);
```

The computed green light durations are stored as output variables, which will be visualized or further analyzed.

### 4. Visualization

The script includes visualization tools to display the green light durations based on the inputs. For instance, bar plots or other graphs may be used to compare the green light durations for each direction.

```matlab
bar([green_duration_L1_L2_L3, green_duration_L4_L5, green_duration_L6_L7_L8, green_duration_L9]);
xlabel('Traffic Lanes');
ylabel('Green Light Duration (seconds)');
title('Green Light Duration based on Traffic Density');
```

This gives a clear and immediate understanding of how the system reacts to the provided traffic conditions.

### 5. Iterative Testing

For thorough performance testing, the simulation can iterate through various traffic density configurations. This allows you to observe how the system performs under different conditions over time.

```matlab
for i = 0:0.1:1
    % Adjust traffic densities dynamically
    traffic_density_L1 = i;
    traffic_density_L2_L3 = 1 - i;
    
    % Evaluate FIS and display updated results
    green_duration_L1_L2_L3 = evalfis([traffic_density_L1, traffic_density_L2_L3], fis_L1_L2_L3);
    % Additional code for updating and plotting results
end
```

This iterative process tests the adaptability of the system, ensuring that it performs effectively in all scenarios.

### 6. Results and Analysis

At the end of the simulation, results are presented in terms of how the green light durations are distributed based on the current traffic densities. The user can analyze whether the controller is effectively balancing traffic flow and preventing excessive delays in any one direction.

---

The `TLC_FuzzyLogicControl_Simulation.m` file serves as a crucial testing tool for this fuzzy logic-based traffic light controller. By simulating real-world traffic conditions, we can verify the system's performance, observe its adaptability to fluctuating traffic levels, and refine the FIS rule base and membership functions accordingly.

This simulation helps ensure that the fuzzy logic system offers efficient and optimized traffic control, reducing delays and improving overall traffic flow.

---
