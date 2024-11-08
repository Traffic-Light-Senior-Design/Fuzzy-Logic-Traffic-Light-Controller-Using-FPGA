Here’s the README with a Table of Contents added for easy navigation.

---

# Traffic Light Controller System Using jFuzzyLogic

## Table of Contents
- [Project Overview](#project-overview)
  - [Intersection Layout](#intersection-layout)
  - [Traffic Light Sequence](#traffic-light-sequence)
- [Using jFuzzyLogic for Traffic Control](#using-jfuzzylogic-for-traffic-control)
  - [Fuzzy Logic Process](#fuzzy-logic-process)
    - [1. Fuzzification](#1-fuzzification)
    - [2. Rule Evaluation](#2-rule-evaluation)
    - [3. Defuzzification](#3-defuzzification)
  - [FIS Files in jFuzzyLogic](#fis-files-in-jfuzzylogic)
- [Getting Started with jFuzzyLogic](#getting-started-with-jfuzzylogic)
  - [Requirements](#requirements)
  - [Installation and Setup](#installation-and-setup)
  - [Running the Simulation](#running-the-simulation)
- [Explanation of the jFuzzyLogic FCL Files](#explanation-of-the-jfuzzylogic-fcl-files)
  - [Example of an FCL File (L1 Consideration)](#example-of-an-fcl-file-l1-consideration)
- [Testing and Debugging](#testing-and-debugging)
  - [jFuzzyLogic Console](#jfuzzylogic-console)
- [Conclusion](#conclusion)

---

## Project Overview

This project is a Fuzzy Logic-based Traffic Light Controller implemented in **jFuzzyLogic**, an open-source Fuzzy Logic library for Java. This version of the project aims to replicate and extend the MATLAB-based system, with additional flexibility and compatibility for embedding in Java applications.

### Intersection Layout

The intersection setup mirrors the MATLAB-based design:
- **North-South**: Three lanes in each direction (L1, L2, and L3 for northbound; L6, L7, and L8 for southbound).
- **East-West**: Two lanes from the East (L4 and L5) and one lane from the West (L9).

### Traffic Light Sequence

The sequence for green light control is defined as follows:
1. L1 (northbound left turn only).
2. L6 (southbound left turn only).
3. L2 + L3 (northbound) and L7 + L8 (southbound) simultaneously.
4. L4 + L5 (eastbound lanes, with L4 as left turn only).
5. L9 (westbound single lane with multiple direction options).

Each FIS file in jFuzzyLogic corresponds to one of these sequences and determines the active green light duration based on traffic densities in the primary lane and its competing lanes.

## Using jFuzzyLogic for Traffic Control

### Fuzzy Logic Process

#### 1. Fuzzification
- **Inputs**: The traffic density for each lane is the primary input.
- **Membership Functions**: Each input uses three fuzzy sets—**Low**, **Medium**, and **High**—with trapezoidal and triangular shapes to provide smooth transitions.
- **FIS Files in FCL Format**: The logic rules and membership functions are defined using `.fcl` files compatible with jFuzzyLogic.

#### 2. Rule Evaluation
Each `.fcl` file contains a rule set optimized for its sequence in the traffic light cycle. When evaluating, for example, L1’s green time:
- Rules consider L1’s density along with the densities of L2, L3, L7, and L8.
- **Example Rule**: “IF L1 density is High AND L2/L3 density is Low THEN green time for L1 is Long.”

#### 3. Defuzzification
The rules produce fuzzy outputs for green light duration, which jFuzzyLogic defuzzifies to a single crisp value:
- **Method**: The **Centroid of Area (COA)** method is used to determine the final green light duration.
- This crisp green time value is the final output used in the simulation.

### FIS Files in jFuzzyLogic

The following FIS files are implemented as `.fcl` files:
- `L1_ConsiderL2L3_L7L8.fcl`
- `L6_ConsiderL2L3_L7L8.fcl`
- `L2L3_L7L8.fcl`
- `L4_L5_ConsiderL9.fcl`
- `L9_ConsiderL4_L5.fcl`

Each `.fcl` file represents a sequence, applying fuzzy logic to determine the optimal green time for each lane in that sequence based on competing traffic densities.

## Getting Started with jFuzzyLogic

### Requirements
- **Java Development Kit (JDK)** version 8 or higher.
- **jFuzzyLogic** library. You can download it from [jFuzzyLogic's GitHub repository](https://github.com/rodrigomelo9/jFuzzyLogic).

### Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YourUsername/TrafficLightControllerSystem.git
   cd TrafficLightControllerSystem
   ```

2. **Import jFuzzyLogic Library**:
   - Download the jFuzzyLogic `.jar` file and include it in your project’s library path.

3. **Add FCL Files**:
   - Place all `.fcl` files in the working directory so they can be accessed by your Java application.

### Running the Simulation

1. **Load and Configure FIS**:
   - Use jFuzzyLogic to load each `.fcl` file as needed in your Java simulation.
   - Example code to load and test an FCL file:
     ```java
     FIS fis = FIS.load("L1_ConsiderL2L3_L7L8.fcl", true);
     if (fis == null) {
         System.err.println("Cannot load file.");
         return;
     }
     ```

2. **Setting Input Values**:
   - Set traffic density inputs for each lane. For instance, to set L1’s density:
     ```java
     fis.setVariable("L1_density", 0.7);  // 0.7 corresponds to a High density
     ```

3. **Evaluating the System**:
   - Run the fuzzy inference system and retrieve the green time output:
     ```java
     fis.evaluate();
     double greenTime = fis.getVariable("green_time").getValue();
     System.out.println("Green time for L1: " + greenTime);
     ```

4. **Loop Through Sequences**:
   - Implement a loop or scheduling mechanism to cycle through sequences according to the specified order, adjusting green light times dynamically based on traffic densities.

## Explanation of the jFuzzyLogic FCL Files

Each `.fcl` file is structured to reflect the unique traffic dynamics of each lane sequence.

- **Rule Base**: The rules follow similar logic to the MATLAB implementation, such as prioritizing low-traffic lanes when a high-density lane needs time, and vice versa.
- **Membership Functions**: Each input (e.g., lane density) has membership functions defined in triangular or trapezoidal shapes, matching the traffic characteristics for that lane.
- **Defuzzification Output**: Each rule base in `.fcl` files outputs a `green_time` variable, which is defuzzified to a crisp duration.

### Example of an FCL File (L1 Consideration)

Below is an excerpt from `L1_ConsiderL2L3_L7L8.fcl` that defines rules and MFs for L1’s sequence:

```fcl
FUNCTION_BLOCK L1_ConsiderL2L3_L7L8

VAR_INPUT
    L1_density : REAL;
    L2L3_density : REAL;
    L7L8_density : REAL;
END_VAR

VAR_OUTPUT
    green_time : REAL;
END_VAR

FUZZIFY L1_density
    TERM low := (0, 1) (0.3, 1) (0.5, 0);
    TERM medium := (0.3, 0) (0.5, 1) (0.7, 0);
    TERM high := (0.5, 0) (0.7, 1) (1, 1);
END_FUZZIFY

RULEBLOCK No1
    RULE 1 : IF L1_density IS high AND L2L3_density IS low THEN green_time IS long;
    RULE 2 : IF L1_density IS medium AND L2L3_density IS medium THEN green_time IS medium;
    RULE 3 : IF L1_density IS low AND L7L8_density IS high THEN green_time IS short;
END_RULEBLOCK

END_FUNCTION_BLOCK
```

## Testing and Debugging

### jFuzzyLogic Console
Use the jFuzzyLogic console to test and visualize each `.fcl` file:
- Run `jFuzzyLogicConsole` and load an `.fcl` file.
- Experiment with input values to see real-time changes in green time outputs.
- Adjust rules and MFs as needed to improve performance.

## Conclusion

Implementing the Traffic Light Controller System in jFuzzyLogic allows for greater flexibility, platform independence, and easy integration into Java applications. The project demonstrates the power of fuzzy logic in adaptive traffic management, improving flow and minimizing waiting times across various traffic densities.

--- 

This README now includes a comprehensive overview and is organized with a Table of Contents for easy navigation.