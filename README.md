
---

# Traffic Light Controller using Fuzzy Logic

This project simulates the control of traffic lights at a four-way intersection using Fuzzy Logic. The controller makes decisions on green light durations based on traffic densities in each lane. The system dynamically adjusts the timings to optimize traffic flow and minimize waiting times, aiming to improve traffic management efficiency.

## Project Structure

- **Fuzzy Inference System (FIS) Files**: These files contain the Fuzzy Logic rules that dictate how the traffic light timings are adjusted based on traffic densities.
  - `L1_L2_L3_TrafficLightController.fis`: Controls the traffic light timings for the Main North lanes (L1, L2, L3).
  - `L6_L7_L8_TrafficLightController.fis`: Controls the traffic light timings for the Main South lanes (L6, L7, L8).
  - `L4_L5_TrafficLightController.fis`: Controls the traffic light timings for the Sub East lanes (L4, L5).
  - `L9_TrafficLightController.fis`: Controls the traffic light timings for the Sub West lane (L9).

- **MATLAB Simulation Script**: 
  - `TLC_FuzzyLogicControl_Simulation.m`: The main simulation script that integrates the FIS files, simulates traffic density changes, and adjusts green light timings based on fuzzy logic evaluations.

## Fuzzy Logic Design

Fuzzy logic is applied to control the green light duration for each direction at the intersection. The FIS files define the rules that determine how the green light duration should change based on the input traffic densities.

Each direction's traffic is managed independently:
- **Main North (L1, L2, L3)** and **Main South (L6, L7, L8)** lanes are grouped together and share the green light timing.
- **Sub East (L4, L5)** and **Sub West (L9)** have their own separate green light timings.

### Inputs and Outputs
- **Inputs**: The traffic density for each lane is input to the fuzzy logic system. The densities are defined as values between 0 (empty) and 1 (fully congested).
- **Outputs**: The duration for which the green light remains on for the respective direction.

## Simulation Process

1. **Traffic Density Initialization**: At the start of the simulation, the traffic density for each lane is initialized to a value between 0 and 1. These densities evolve over time based on inflow and outflow patterns.
2. **Green Light Duration Calculation**: The simulation uses the FIS files to evaluate the current traffic densities and calculate the optimal green light duration for each direction.
3. **Sequence of Traffic Lights**: The intersection is divided into three phases:
   - Main North and Main South lanes get the green light simultaneously.
   - Sub East gets the green light in the next phase.
   - Sub West gets the green light in the final phase.
4. **Traffic Flow Simulation**: During each green light phase, the traffic densities for the active lanes decrease based on the green light duration, while the densities for inactive lanes increase.
5. **Plotting Results**: The simulation produces several plots to visualize the traffic densities, green light durations, and green light status for each direction.

## How to Run the Simulation

1. Download the FIS files and the simulation script.
2. Open MATLAB and load the simulation file `TLC_FuzzyLogicControl_Simulation.m`.
3. Ensure that all FIS files are in the same directory as the simulation script.
4. Run the simulation to visualize the traffic light control in action.

## Future Improvements

- Implement waiting time calculations for each lane to further optimize traffic flow.
- Explore integrating Vehicle-to-Everything (V2X) communication to improve decision-making based on real-time vehicle data.

---

You can copy this directly into your `README.md` file on GitHub!
