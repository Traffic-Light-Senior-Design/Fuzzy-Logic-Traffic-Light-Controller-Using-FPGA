
---

# Fuzzy Inference System (FIS) for Traffic Light Controller

This project uses four distinct Fuzzy Inference System (FIS) files, one for each set of traffic lanes, to dynamically control the green light duration based on traffic density. The fuzzy logic allows for non-linear decision-making, which is more flexible and adaptive compared to traditional methods.

**NOTE**: The following files are recommended to be used with a simulation software that will be capable of handling sequencing logic for each of the following FIS files (corresponding to a series of sequences) such as AnyLogic Simulation.

## Overview of the FIS Files

- `L1_L9_Sequence_TrafficLightController.fis`: Manages the green light duration for the first Green Light Duration sequence of lanes L1 and L9.
- `L6_L5_Sequence_TrafficLightController.fis`: Manages the green light duration for the second Green Light Duration sequence of lanes L6 and L5.
- `L2L3_L7L8_Sequence_TrafficLightController.fis`: Manages the green light duration for the third Green Light Duration sequence of lanes L2+L3 and L7+L8.
- `L3_L5_L4_Sequence_TrafficLightController.fis`: Manages the green light duration for the fourth Green Light Duration sequence of lanes L3, L4, and L5. (Note: L4 and L5 are independent inputs of each other as their densities can vary significantly)
- `L9_L8_Sequence_TrafficLightController.fis`: Manages the green light duration for the fifth Green Light Duration sequence of lanes L9 and L8.

Each FIS file applies fuzzy logic rules based on the input traffic densities to determine the duration of the green light. Below, we detail the logic for each file, including the input/output variables, membership functions, and the rule base.

---
