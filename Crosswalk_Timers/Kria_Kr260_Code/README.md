# FPGA UART Transmitter Modules for Crosswalk Timer

This folder contains VHDL modules used to implement UART communication from an FPGA to an external device (such as an Arduino). The modules incrementally build on each other to transmit predefined or dynamically selected byte sequences based on fuzzy logic, representing crosswalk timer values. Each module is designed to handle various aspects of UART communication, including transmitting multiple bytes, single-byte transmissions, and integrating fuzzy input to dynamically adjust the transmitted data.

## Modules Overview

### **UART, UART_TX, UART_RX**
This VHDL code implements a UART (Universal Asynchronous Receiver-Transmitter) transmitter module, provided by a professor in a previous course. The code defines a state machine with four states: IDLE, START, DATA, and STOP, which handle the transmission of serial data over UART. The `baud_rate_clk_generator` generates the required baud rate clock based on the system clock, while the `tx_start_detector` ensures the transmission starts only when a valid start signal is received. The `data_index_counter` manages the transmission of the 8-bit data, and the finite state machine controls the start bit, data bits, and stop bit transmission.

The design ensures proper synchronization between the baud clock and data transmission, which is critical for sending data serially via UART. The module sends data from a parallel 8-bit input (`tx_data_in`) serially through the output (`tx_data_out`) at a specified baud rate, handling the start and stop bits appropriately. This module was tested and implemented in the course as a foundational building block for communication between systems.

### **UART_Test_Bytes**

#### **Module 1: UART_Test_Bytes (Multiple Byte Transmission)**
This module transmits a sequence of four predefined bytes over UART from an FPGA to an Arduino using a 25 MHz clock. It initializes the transmission process after a set initial delay, sending bytes one by one in the sequence `0x2D`, `0x23`, `0x19`, and `0x0F`. A UART instance is instantiated, and transmission is controlled through a finite state machine (FSM) that manages the `tx_start` signal and ensures each byte is sent with the correct timing according to the baud rate (115200). After each byte is transmitted, the system waits for a specified delay (`BYTE_TRANSMISSION_DELAY`) before transmitting the next byte in the sequence. The module stops after transmitting all four bytes. This module demonstrates the ability to sequentially send multiple bytes from the FPGA to the Arduino, allowing for more complex data communication testing.

#### **Module 2: UART_Test_Bytes (Single Byte Transmission)**
This simplified version of the first module is designed to transmit a single byte (`0x23` or 35 in decimal) over UART from the FPGA to the Arduino. After an initial delay, the module starts transmitting the byte using the `tx_start` signal. The UART instance handles the transmission, and the system ensures that the byte is sent only once by using a flag (`tx_sent`). This module is useful for testing the basic functionality of UART transmission and ensuring that a single byte can be correctly sent and received by the Arduino.

Both modules are useful for testing UART communication between the FPGA and Arduino, with the first module testing multiple byte transmissions and the second focusing on a single byte.

### **UART_TEST_Top**
The `UART_TEST_Top` module transmits four input bytes sequentially over UART from the FPGA to an external device, such as an Arduino. The input bytes are provided as `input_byte1`, `input_byte2`, `input_byte3`, and `input_byte4`, and these are loaded into an array `data_in`. The module controls the transmission of each byte one by one using a UART interface. A `tx_start` signal initiates the UART transmission, and the actual data is transmitted through the `tx` output. The UART module is instantiated within the design, but the reception side (`rx`) is not used and is tied to '1'.

The module also manages timing to ensure that each byte is sent with proper delays. It introduces an initial delay before the first byte is transmitted, controlled by `initial_delay_counter`, and ensures there is sufficient delay between each byte using `byte_delay_counter`. The `byte_index` tracks which byte is currently being transmitted, and the `test_byte` signal holds the byte to be sent. Once a byte is transmitted (`byte_done` is set), the next byte in the sequence is loaded, and this continues until all four bytes are sent. This module is designed for testing sequential byte transmission via UART, allowing for controlled and timed communication from the FPGA to an external system.

### **UART_Byte_Transmitter**
The `UART_Byte_Transmitter` module is the top-level module responsible for selecting and transmitting a set of four bytes over UART based on a 2-bit `fuzzy_input` signal, which represents different crosswalk timing conditions. The module handles four predefined byte sets: `idle_bytes` (representing an idle state), `short_bytes`, `mid_bytes`, and `long_bytes`, each corresponding to different pedestrian timer values.

The core functionality is based on the `fuzzy_input`, which determines the byte sequence to be transmitted. When the `fuzzy_input` changes, a new set of bytes is selected, and a reset signal (`reset_trigger`) is temporarily set to trigger the transmission process. This change in `fuzzy_input` selects one of the byte sequences, which is then assigned to four signals (`tx_byte1`, `tx_byte2`, `tx_byte3`, `tx_byte4`). The selected byte set is sent via the `UART_TEST_Top` module, which manages the actual UART transmission of the bytes over the `tx` line.

This module integrates the decision-making logic based on fuzzy input with the UART transmission functionality, dynamically sending different byte sequences based on the state of the crosswalk, as indicated by the fuzzy logic.

