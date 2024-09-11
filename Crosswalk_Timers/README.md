# Crosswalk Timer System with FPGA and Arduino

## Overview

This part of the project implements a dynamic crosswalk timing system using a combination of FPGA and Arduino platforms. The system uses fuzzy logic to determine crosswalk timer values and communicates these values from the FPGA to the Arduino via UART. The Arduino then displays the timers on seven-segment displays, counting down based on the transmitted data.

The project is divided into two main parts:

1. **FPGA Side**: Handles the generation and transmission of crosswalk timer values based on input from fuzzy logic (representing conditions like pedestrian presence or traffic volume). It uses a UART interface to send these values to the Arduino.
2. **Arduino Side**: Receives the timer values from the FPGA and displays them on multiple seven-segment displays, ensuring a smooth countdown process and handling the synchronization of multiple displays.

## Project Structure

The project is organized into two primary folders:

### `fpga/`
This folder contains all the VHDL modules used to implement the UART communication and control logic on the FPGA. The FPGA is responsible for dynamically adjusting the crosswalk timers based on fuzzy input and transmitting the appropriate timer values to the Arduino. The key functionality includes:
- Transmitting multiple bytes over UART to the Arduino.
- Handling different crosswalk timing conditions (idle, short, medium, long) based on fuzzy logic inputs.
- Managing UART state machines and byte transmission logic.

### `arduino/`
This folder contains Arduino sketches that manage the reception of UART data from the FPGA and display the crosswalk timers on seven-segment displays. The Arduino code handles:
- Receiving bytes from the FPGA and converting them into digits displayed on four independent seven-segment displays.
- Implementing a countdown feature for each display, based on the received timer values.
- Ensuring smooth synchronization and refresh rates for the displays, as well as multiplexing control for the seven-segment digits.

## Crosswalk Timing System

The crosswalk timing system works by using sensors or other inputs to feed into a fuzzy logic system implemented on the FPGA. Based on this input, the FPGA selects a set of four bytes representing the time values for the pedestrian crosswalk timers. These values are transmitted via UART to the Arduino, which displays the times on seven-segment displays.

### Key Features:
- **Fuzzy Logic Input**: The system adjusts the pedestrian timer values based on input signals (such as sensor data indicating pedestrian presence). The FPGA decides between idle, short, medium, and long timer modes.
- **UART Communication**: The FPGA communicates the selected timer values to the Arduino using UART, ensuring reliable transmission of the timer data.
- **Seven-Segment Display Countdown**: The Arduino receives the timer values and controls multiple seven-segment displays to show the countdowns, providing visual feedback for the crosswalk timers.

## How It Works

1. The FPGA receives fuzzy logic input, representing various crosswalk timing conditions.
2. Based on the input, the FPGA selects a corresponding set of bytes representing the timer values for the crosswalk.
3. The selected byte sequence is sent from the FPGA to the Arduino using UART communication.
4. The Arduino receives the bytes, splits them into digits, and displays the timer values on the seven-segment displays.
5. The displays count down the values and turn off when the timer reaches zero, with real-time updates based on new input from the FPGA.

## Installation and Usage

1. **FPGA Side**: Synthesize and upload the VHDL code in the `fpga/` and `fpga/UART` folders to your FPGA board.
2. **Arduino Side**: Upload the UART_To_Display_Countdown Arduino sketch in the `arduino/` folder to your Arduino board.
3. Connect the UART TX pin from the FPGA to the RX pin of the Arduino.
4. Power up both systems, and based on the input to the FPGA, the crosswalk timers will be displayed on the Arduino’s seven-segment displays.

---

This project demonstrates the integration of FPGA-based logic and Arduino-based display control, providing a functional crosswalk timing system using real-time communication between the two platforms.

