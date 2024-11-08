
# Traffic Light Fuzzy Logic Controller Using MATLAB

---

## Project Overview
---

This repository contains a MATLAB-based implementation of a Traffic Light Controller System using Fuzzy Logic, designed to optimize green light durations at a busy four-way intersection. This system improves traffic flow by dynamically adjusting green light times based on real-time traffic densities in each lane.

### Intersection Layout
---

The intersection consists of:
- **North-South**: Three lanes in each direction (L1, L2, and L3 for the northbound and L6, L7, and L8 for the southbound).
- **East-West**: Two lanes coming from the East (L4 and L5) and one lane from the West (L9).

### Traffic Flow Sequence
---

The traffic light controller follows a fixed sequence:
1. L1 (northbound left turn only).
2. L6 (southbound left turn only).
3. L2 + L3 (northbound straight lanes) and L7 + L8 (southbound straight lanes).
4. L4 + L5 (westbound lanes, with L4 as left turn only).
5. L9 (eastbound single lane).

Each FIS file corresponds to one sequence, determining the active green light duration based on traffic densities in the primary lane and the competing lanes in the current sequence.

## Motivation for Fuzzy Logic
---

Fuzzy Logic allows the traffic light controller to adapt to real-world variability in traffic densities without requiring rigid thresholds. By using fuzzy rules and membership functions, the controller:
- Minimizes average waiting time.
- Optimizes green light duration for each lane.
- Dynamically adjusts green time according to changing traffic conditions.

## System Components
---

### Fuzzification

1. **Inputs**: Traffic density of each lane is used as an input variable.
2. **Membership Functions (MFs)**: Each lane’s density is represented by three fuzzy categories: **Low**, **Medium**, and **High**.
   - Example: A "Low" density means light traffic, while "High" indicates heavy traffic.
   - MFs are typically triangular or trapezoidal to allow for gradual transitions between categories.

### Rule Evaluation

Each FIS file includes a rule base tailored to its sequence. For example, when evaluating L1:
- The rules account for L1’s density and the densities of L2, L3, L7, and L8.
- **Example Rule**: “IF L1 density is High AND L2/L3 density is Low THEN green time for L1 is Long.”
- Rules are evaluated based on the degree of membership, allowing the system to "fire" each rule to an extent proportional to input values.

### Defuzzification

The fuzzy outputs from rule evaluation are converted into crisp green light durations through **defuzzification**:
1. **Method**: The **Centroid of Area (COA)** method is used to find a single scalar value for green light duration.
2. **Purpose**: This produces precise, actionable green light times that the simulation can apply to each lane sequence.

### FIS Files

The system includes five FIS files, each controlling green time for one of the sequences:
- `L1_ConsiderL2L3_L7L8_MamdaniSequence_TrafficLightController.fis`
- `L6_ConsiderL2L3_L7L8_MamdaniSequence_TrafficLightController.fis`
- `L2L3_L7L8_MamdaniSequence_TrafficLightController.fis`
- `L4_L5_ConsiderL9_MamdaniSequence_TrafficLightController.fis`
- `L9_ConsiderL4_L5_MamdaniSequence_TrafficLightController.fis`

Each file’s rule base ensures that green time for the primary lane in the sequence is optimized relative to the traffic in competing lanes.

## Using the MATLAB Fuzzy Logic Designer Toolbox
---

To visualize and fine-tune the system, use the **MATLAB Fuzzy Logic Designer Toolbox**:

1. **Loading and Editing FIS Files**:
   - Open MATLAB and type `fuzzy` in the command window.
   - Use **File > Import > From Workspace** to load an FIS file.
   - Adjust MFs and rules in the **Membership Function** and **Rule Editor** tabs.

2. **Creating and Editing Rules**:
   - Navigate to the **Rule Editor** to define or modify rules. For instance:
     - Example: “IF L1 density is High AND L2/L3 density is Low THEN green time is Long.”
   - You can customize rules for more nuanced traffic management.

3. **Testing and Visualizing**:
   - **Rule Viewer**: Enter sample values to see the effect on green light duration.
   - **Surface Viewer**: Visualize input-output relationships to understand the system’s response across different densities.

4. **Exporting**:
   - Save the adjusted FIS file and load it into the simulation to test in real time.

---

This Fuzzy Logic Traffic Light Controller System showcases the effectiveness of adaptive, rule-based logic in managing complex traffic flows at an intersection. By incorporating real-time data, the system improves efficiency and responsiveness, contributing to smoother, safer traffic management.