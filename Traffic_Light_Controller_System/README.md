# Traffic Light Fuzzy Logic Controller Using FPGA

## Overview
This repository contains the code and documentation for a **Traffic Light Fuzzy Logic Controller** developed on an FPGA. The system is designed to optimize traffic flow and pedestrian crossing times in real-time by dynamically adjusting green light durations based on detected traffic densities and crosswalk signals. The project uses fuzzy logic principles implemented in VHDL to achieve adaptive, responsive control over traffic light sequences.

### Key Features
- **Adaptive Traffic Control**: The controller adjusts traffic light timings based on real-time traffic density, reducing congestion and wait times.
- **Integrated Pedestrian Crosswalk Timers**: Crosswalk times are synchronized with the green light phases, ensuring pedestrian safety.
- **Modular Design**: Each lane sequence is modular, allowing for straightforward scalability and customization.
- **Robust Testing**: Includes comprehensive testbenches to validate the functionality of each module and the overall system.

## Folder Structure

- **Project Code**: Contains VHDL files for the individual sequence controllers, the main state machine, and all other components needed to run the traffic light controller system.
- **Testbenches**: Includes the testbenches for each sequence controller and the state machine, used to validate and simulate module functionality.
- **images**: Stores simulation images referenced in README files for visualizing testbench outputs.

## Project Overview and Functionality

The **Traffic Light Fuzzy Logic Controller** is designed for intersections with adaptive, responsive traffic light control based on fuzzy logic. Each lane or set of lanes is assigned a **Sequence Controller** module that takes in an 8-bit traffic density value and determines the appropriate green light duration based on fuzzy rules. The **State Machine** module then cycles through these sequences, ensuring each sequence’s green, yellow, and red phases are correctly timed.

1. **Sequence Controllers**: Each sequence controller operates on traffic density inputs for its respective lanes. Using fuzzy logic, it evaluates the input and outputs a precise green light duration. This modular approach allows each lane or lane group to be managed independently.
2. **State Machine**: The central control module that connects all sequence controllers and coordinates light transitions across the intersection. It processes real-time crosswalk button signals and updates crosswalk timers, synchronizing pedestrian crossing with traffic light sequences.
3. **Crosswalk Timers**: Integrated with the state machine to ensure pedestrian timers align with traffic sequences, enhancing both vehicle flow and pedestrian safety.

This project is designed to be robust, scalable, and adaptable for various intersection configurations. 

## Installation and Usage

### Prerequisites
1. **Vivado Design Suite**: To compile and simulate the VHDL files.
2. **VHDL Knowledge**: Basic understanding of VHDL syntax and FPGA simulation.
3. **FPGA Board (e.g., Xilinx Kria KR260)**: This project is developed with the Xilinx platform in mind, but it can be adapted for other FPGAs with modifications.

### Setup and Compilation

1. **Required Files**:
   - `Project Code`: Contains the VHDL files for each traffic light sequence controller, the state machine, and other components.
   - `Testbenches`: Contains testbench files to validate each sequence controller and the state machine.

2. **Open Vivado**:
   - Open Vivado and create a new project.
   - Add the VHDL files from the `Project Code` and `Testbenches` folders to the project.

3. **Run Simulations**:
   - For initial testing, run simulations using the files in the `Testbenches` folder. Each testbench file can be simulated to verify module functionality.
   - Use the simulation images in the `/images` folder as a reference for expected outputs.

4. **Synthesize and Implement on FPGA**:
   - Once verified through simulation, proceed with synthesis and implementation on your FPGA board.
   - Be sure to adjust any necessary constraints (clock settings, I/O pins) to match your specific FPGA setup.

### Usage

1. **Traffic Density Input**: Configure your FPGA’s input pins to accept 8-bit traffic density signals.
2. **Crosswalk Button Configuration**: Map the crosswalk buttons to the appropriate FPGA input pins, as detailed in the **State Machine** section.
3. **Run the System**: Load the bitstream onto your FPGA and observe the adaptive traffic control in action, with green light timings adjusting in real-time based on input traffic density and crosswalk signals.

### Extending the Project

This project is modular, allowing for further customization or scaling:
- **Adding Sequences**: New sequence controllers can be added for additional lanes.
- **Modifying Fuzzy Rules**: The fuzzy logic rules in each sequence controller can be adjusted to fine-tune green light durations for specific traffic conditions.
- **Adapting Crosswalk Timers**: The crosswalk timer module can be modified to add more detailed control over pedestrian signals.

---

This README provides a complete overview, installation instructions, and usage guidelines for the **Traffic Light Fuzzy Logic Controller** project. By following these instructions, you can set up, test, and run this adaptive traffic control system on your FPGA.
