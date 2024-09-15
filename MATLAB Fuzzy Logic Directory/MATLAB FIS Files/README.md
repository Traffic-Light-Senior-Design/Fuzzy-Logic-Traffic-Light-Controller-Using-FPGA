
---

# Fuzzy Inference System (FIS) for Traffic Light Controller

This project uses four distinct Fuzzy Inference System (FIS) files, one for each set of traffic lanes, to dynamically control the green light duration based on traffic density. The fuzzy logic allows for non-linear decision-making, which is more flexible and adaptive compared to traditional methods.

## Overview of the FIS Files

- `L1_L2_L3_TrafficLightController.fis`: Manages the green light duration for the **Main North** direction (L1, L2, L3).
- `L6_L7_L8_TrafficLightController.fis`: Manages the green light duration for the **Main South** direction (L6, L7, L8).
- `L4_L5_TrafficLightController.fis`: Manages the green light duration for the **Sub East** direction (L4, L5).
- `L9_TrafficLightController.fis`: Manages the green light duration for the **Sub West** direction (L9).

Each FIS file applies fuzzy logic rules based on the input traffic densities to determine the duration of the green light. Below, we detail the logic for each file, including the input/output variables, membership functions, and the rule base.

## Why Fuzzy Logic?

Traffic conditions are highly dynamic and uncertain, which makes fuzzy logic an ideal approach. Fuzzy logic systems do not require exact inputs but instead operate on linguistic variables (like "low traffic", "moderate traffic", or "high traffic"). This helps smooth transitions and improve decision-making, particularly in handling mixed traffic flows and peak-hour variations.

Fuzzy logic offers the following advantages:
- **Adaptivity**: Adjusts to real-time changes in traffic density.
- **Flexibility**: Handles uncertainty and imprecision effectively.
- **Rule-based structure**: Easy to implement human-like reasoning.

## Input and Output Variables

Each FIS system has the following inputs and outputs:

- **Inputs**: 
  - The traffic density of lanes in the respective direction. 
  - For example, in `L1_L2_L3_TrafficLightController.fis`, the inputs are the densities of L1 (Main North) and L2+L3 (a combined measure for Main North right/left turns).

- **Output**:
  - The duration (in seconds) for which the green light remains active for that direction. Longer green durations are granted for lanes with higher traffic density.

### Input: Traffic Density

The traffic density input values range from 0 (empty) to 1 (fully congested). Each lane has its own density input, reflecting the real-time load of vehicles on that lane.

#### Membership Function (MF) Shapes
For each lane's traffic density, the FIS uses triangular membership functions to classify density levels into three categories:
- **Low**: Traffic density is low, and no significant green light duration is required.
- **Medium**: Moderate traffic density that requires an average green light duration.
- **High**: High congestion, so a longer green light duration is needed.

These membership functions allow smooth transitions between traffic states, ensuring the system reacts progressively rather than abruptly to changes.

### Output: Green Light Duration

The green light duration, also expressed as a fuzzy variable, is defined by three levels of output:
- **Short**: The green light remains active for a short duration when traffic is low.
- **Medium**: The green light duration is moderate for medium traffic levels.
- **Long**: A long green light duration is provided when traffic is heavy.

The output membership function is designed similarly to the input, using triangular shapes to determine the degree of output. The precise duration is determined by the rule base (explained next) and the defuzzification process (often using the centroid method).

## Rule Base

The rule base is the heart of each FIS file. It contains a set of IF-THEN rules that dictate the system's behavior based on the traffic densities. Each rule consists of:
- **IF**: Conditions based on the traffic densities of the lanes.
- **THEN**: A corresponding green light duration.

### Example Rule Base

For the `L1_L2_L3_TrafficLightController.fis`, the rule base may look like this:

1. **IF** the traffic density in L1 is **High** AND the density in L2+L3 is **High**, **THEN** set the green light duration to **Long**.
2. **IF** the traffic density in L1 is **Low** AND the density in L2+L3 is **Medium**, **THEN** set the green light duration to **Short**.
3. **IF** the traffic density in L1 is **Medium** AND the density in L2+L3 is **Low**, **THEN** set the green light duration to **Medium**.

The rule base for each FIS file differs slightly depending on the layout and importance of the traffic lanes they manage. For instance, more critical lanes (like the Main North lanes) will have a higher priority in terms of longer green durations.

## Membership Function Design

The design of the membership functions follows standard fuzzy logic principles:
- **Triangular Shape**: This shape is chosen for simplicity and computational efficiency. It provides a smooth transition between different density levels.
- **Ranges**: 
  - **Low**: 0.0 - 0.3 (light traffic)
  - **Medium**: 0.3 - 0.7 (moderate traffic)
  - **High**: 0.7 - 1.0 (heavy traffic)

For each input and output, the boundaries of these membership functions are carefully chosen to reflect real-world conditions. The output membership function similarly uses the "Short", "Medium", and "Long" categories to represent green light durations.

## Defuzzification

The defuzzification process in each FIS file converts the fuzzy output (e.g., a degree of membership to "Short" or "Long" green light duration) into a crisp value that represents the exact green light duration in seconds. The **centroid method** is used for this, which calculates the center of the area under the membership function curve.

## Summary of Each FIS File

### Main North (L1, L2, L3) - `L1_L2_L3_TrafficLightController.fis`
- Inputs: Traffic densities for L1 and L2+L3.
- Output: Green light duration for Main North.
- Rule base: Optimized for prioritizing Main North's through traffic and turns.

### Main South (L6, L7, L8) - `L6_L7_L8_TrafficLightController.fis`
- Inputs: Traffic densities for L6 and L7+L8.
- Output: Green light duration for Main South.
- Rule base: Balances between through traffic and left/right turns at Main South.

### Sub East (L4, L5) - `L4_L5_TrafficLightController.fis`
- Inputs: Traffic densities for L4 and L5.
- Output: Green light duration for Sub East.
- Rule base: Favors moderate green light durations based on eastbound traffic density.

### Sub West (L9) - `L9_TrafficLightController.fis`
- Inputs: Traffic density for L9.
- Output: Green light duration for Sub West.
- Rule base: Optimized for westbound traffic with fewer complex rules due to a single input.

---

Each FIS file plays a vital role in controlling the traffic light timings at the intersection. The fuzzy logic system dynamically adjusts green light durations in response to real-time traffic densities, allowing for more efficient traffic flow and reduced waiting times. By using these FIS systems, the intersection is better equipped to handle varying traffic conditions with minimal manual intervention.

---
