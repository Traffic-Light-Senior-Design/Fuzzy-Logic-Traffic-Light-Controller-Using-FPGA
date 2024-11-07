# ------------------------------------------------------------------------------
# Kria KR260 SOM General Constraints File
# Use this file by uncommenting the necessary lines based on your project.
# This file contains general definitions for clocks, I/O standards, input/output
# timing, and general reusable configurations for the Kria KR260 SOM.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#  IO Map
# ------------------------------------------------------------------------------

# -------------Clock IO MAP------------------#

#25MHz clock
set_property PACKAGE_PIN C3 [get_ports clk_25MHz]
set_property IOSTANDARD LVCMOS18 [get_ports clk_25MHz]

#26MHz positive clock
#set_property PACKAGE_PIN C21 [get_ports clk_26MHz_pos]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_26MHz_pos]

#26MHz negative clock
#set_property PACKAGE_PIN C22 [get_ports clk_26MHz_neg]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_26MHz_neg]

#27MHz positive clock
#set_property PACKAGE_PIN E21 [get_ports clk_27MHz_pos]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_27MHz_pos]

#27MHz negative clock
#set_property PACKAGE_PIN E22 [get_ports clk_27MHz_neg]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_27MHz_neg]

#74.25MHz positive clock
#set_property PACKAGE_PIN V6 [get_ports clk_74_25MHz_pos]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_74_25MHz_pos]

#74.25MHz negative clock
#set_property PACKAGE_PIN V5 [get_ports clk_74_25MHz_neg]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_74_25MHz_neg]

#125MHz positive clock
#set_property PACKAGE_PIN F23 [get_ports clk_125MHz_pos]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_125MHz_pos]

#125MHz negative clock
#set_property PACKAGE_PIN F24 [get_ports clk_125MHz_neg]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_125MHz_neg]

#156.25MHz positive clock
#set_property PACKAGE_PIN Y6 [get_ports clk_156_25MHz_pos]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_156_25MHz_pos]

#156.25MHz negative clock
#set_property PACKAGE_PIN Y5 [get_ports clk_156_25MHz_neg]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_156_25MHz_neg]


# Template for defining a generated clock (from PLL/MMCM):
#create_generated_clock -name clk_out -source [get_ports clk_in] -divide_by 4 [get_ports clk_out]


# -------------PMOD IO MAP------------------#

###---PMOD-1---###

# PMOD 1 - pin 1: upper right pin
set_property PACKAGE_PIN H12 [get_ports pmod1[0]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[0]]

# PMOD 1 - pin 3: upper pin
set_property PACKAGE_PIN E10 [get_ports pmod1[1]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[1]]

# PMOD 1 - pin 5: upper pin
set_property PACKAGE_PIN D10 [get_ports pmod1[2]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[2]]

# PMOD 1 - pin 7: upper left pin
set_property PACKAGE_PIN C11 [get_ports pmod1[3]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[3]]

# PMOD 1 - pin 2: lower right pin
set_property PACKAGE_PIN B10 [get_ports pmod1[4]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[4]]

# PMOD 1 - pin 4: lower pin
set_property PACKAGE_PIN E12 [get_ports pmod1[5]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[5]]

# PMOD 1 - pin 6: lower pin
set_property PACKAGE_PIN D11 [get_ports pmod1[6]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[6]]

# PMOD 1 - pin 8: lower left pin
set_property PACKAGE_PIN B11 [get_ports pmod1[7]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod1[7]]


####---PMOD-2---###

# PMOD 2 - pin 1: upper right pin
set_property PACKAGE_PIN J11 [get_ports pmod2[0]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[0]]

# PMOD 2 - pin 3: upper pin
set_property PACKAGE_PIN J10 [get_ports pmod2[1]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[1]]

# PMOD 2 - pin 5: upper pin
set_property PACKAGE_PIN K13 [get_ports pmod2[2]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[2]]

# PMOD 2 - pin 7: upper left pin
set_property PACKAGE_PIN K12 [get_ports pmod2[3]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[3]]

# PMOD 2 - pin 2: lower right pin
set_property PACKAGE_PIN H11 [get_ports pmod2[4]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[4]]

# PMOD 2 - pin 4: lower pin
set_property PACKAGE_PIN G10 [get_ports pmod2[5]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[5]]

# PMOD 2 - pin 6: lower pin
set_property PACKAGE_PIN F12 [get_ports pmod2[6]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[6]]

# PMOD 2 - pin 8: lower left pin
set_property PACKAGE_PIN F11 [get_ports pmod2[7]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod2[7]]


####---PMOD-3---###

# PMOD 3 - pin 1: upper right pin
set_property PACKAGE_PIN AE12 [get_ports pmod3[0]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[0]]

# PMOD 3 - pin 3: upper pin
set_property PACKAGE_PIN AF12 [get_ports pmod3[1]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[1]]

# PMOD 3 - pin 5: upper pin
set_property PACKAGE_PIN AG10 [get_ports pmod3[2]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[2]]

# PMOD 3 - pin 7: upper left pin
set_property PACKAGE_PIN AH10 [get_ports pmod3[3]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[3]]

# PMOD 3 - pin 2: lower right pin
set_property PACKAGE_PIN AF11 [get_ports pmod3[4]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[4]]

# PMOD 3 - pin 4: lower pin
set_property PACKAGE_PIN AG11 [get_ports pmod3[5]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[5]]

# PMOD 3 - pin 6: lower pin
set_property PACKAGE_PIN AH12 [get_ports pmod3[6]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[6]]

# PMOD 3 - pin 8: lower left pin
set_property PACKAGE_PIN AH11 [get_ports pmod3[7]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod3[7]]


####---PMOD-4---###

# PMOD 4 - pin 1: upper right pin
set_property PACKAGE_PIN AC12 [get_ports pmod4[0]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[0]]

# PMOD 4 - pin 3: upper pin
set_property PACKAGE_PIN AD12 [get_ports pmod4[1]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[1]]

# PMOD 4 - pin 5: upper pin
set_property PACKAGE_PIN AE10 [get_ports pmod4[2]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[2]]

# PMOD 4 - pin 7: upper left pin
set_property PACKAGE_PIN AF10 [get_ports pmod4[3]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[3]]

# PMOD 4 - pin 2: lower right pin
set_property PACKAGE_PIN AD11 [get_ports pmod4[4]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[4]]

# PMOD 4 - pin 4: lower pin
set_property PACKAGE_PIN AD10 [get_ports pmod4[5]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[5]]

# PMOD 4 - pin 6: lower pin
set_property PACKAGE_PIN AA11 [get_ports pmod4[6]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[6]]

# PMOD 4 - pin 8: lower left pin
set_property PACKAGE_PIN AA10 [get_ports pmod4[7]]
set_property IOSTANDARD LVCMOS33 [get_ports pmod4[7]]



######################## Raspberry Pi GPIO Header ########################
### AXI GPIO ### 

# RPI Header pin 27 --- som240_2_d52
set_property PACKAGE_PIN AD15 [get_ports {rpi_gpio[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[0]}]

# RPI Header pin 28 --- som240_2_d53
set_property PACKAGE_PIN AD14 [get_ports {rpi_gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[1]}]

# RPI Header pin 3 --- som240_2_d54
set_property PACKAGE_PIN AE15 [get_ports {rpi_gpio[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[2]}]

# RPI Header pin 5 --- som240_2_d56
set_property PACKAGE_PIN AE14 [get_ports {rpi_gpio[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[3]}]

# RPI Header pin 7 --- som240_2_d57
set_property PACKAGE_PIN AG14 [get_ports {rpi_gpio[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[4]}]

# RPI Header pin 29 --- som240_2_d58
set_property PACKAGE_PIN AH14 [get_ports {rpi_gpio[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[5]}]

# RPI Header pin 31 --- som240_2_c54
set_property PACKAGE_PIN AG13 [get_ports {rpi_gpio[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[6]}]

# RPI Header pin 26 --- som240_2_C55
set_property PACKAGE_PIN AH13 [get_ports {rpi_gpio[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[7]}]

# RPI Header pin 24 --- som240_2_c56
set_property PACKAGE_PIN AC14 [get_ports {rpi_gpio[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[8]}]

# RPI Header pin 21 --- som240_2_c58
set_property PACKAGE_PIN AC13 [get_ports {rpi_gpio[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[9]}]

# RPI Header pin 19 --- som240_2_c59
set_property PACKAGE_PIN AE13 [get_ports {rpi_gpio[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[10]}]

# RPI Header pin 23 --- som240_2_c60
set_property PACKAGE_PIN AF13 [get_ports {rpi_gpio[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[11]}]

# RPI Header pin 32 --- som240_2_b52
set_property PACKAGE_PIN AA13 [get_ports {rpi_gpio[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[12]}]

# RPI Header pin 33 --- som240_2_b53
set_property PACKAGE_PIN AB13 [get_ports {rpi_gpio[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[13]}]

# RPI Header pin 8 --- som240_2_b54
set_property PACKAGE_PIN W14 [get_ports {rpi_gpio[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[14]}]

# RPI Header pin 10 --- som240_2_b56
set_property PACKAGE_PIN W13 [get_ports {rpi_gpio[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[15]}]

# RPI Header pin 36 --- som240_2_b57
set_property PACKAGE_PIN AB15 [get_ports {rpi_gpio[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[16]}]

# RPI Header pin 11 --- som240_2_b58
set_property PACKAGE_PIN AB14 [get_ports {rpi_gpio[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[17]}]

# RPI Header pin 12 --- som240_2_a54
set_property PACKAGE_PIN Y14 [get_ports {rpi_gpio[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[18]}]

## RPI Header pin 35 --- som240_2_a55
#set_property PACKAGE_PIN Y13 [get_ports {rpi_gpio[19]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[19]}]

## RPI Header pin 38 --- som240_2_a56
#set_property PACKAGE_PIN W12 [get_ports {rpi_gpio[20]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[20]}]

## RPI Header pin 40 --- som240_2_a58
#set_property PACKAGE_PIN W11 [get_ports {rpi_gpio[21]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[21]}]

## RPI Header pin 15 --- som240_2_a59
#set_property PACKAGE_PIN Y12 [get_ports {rpi_gpio[22]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[22]}]

## RPI Header pin 16 --- som240_2_a60
#set_property PACKAGE_PIN AA12 [get_ports {rpi_gpio[23]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[23]}]

## RPI Header pin 18 --- som240_2_a48
#set_property PACKAGE_PIN Y9 [get_ports {rpi_gpio[24]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[24]}]

## RPI Header pin 22 --- som240_2_a50
#set_property PACKAGE_PIN AA8 [get_ports {rpi_gpio[25]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[25]}]

## RPI Header pin 37 --- som240_2_a51
#set_property PACKAGE_PIN AB10 [get_ports {rpi_gpio[26]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[26]}]

## RPI Header pin 13 --- som240_2_a52
#set_property PACKAGE_PIN AB9 [get_ports {rpi_gpio[27]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio[27]}]

### Special Functions ###
#set_property PACKAGE_PIN AD15 [get_ports {rpi_gpio0_id_sd}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio0_id_sd}]

#set_property PACKAGE_PIN AD14 [get_ports {rpi_gpio1_id_sc}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio1_id_sc}]

#set_property PACKAGE_PIN AE15 [get_ports {rpi_gpio2_sda}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio2_sda}]

#set_property PACKAGE_PIN AE14 [get_ports {rpi_gpio3_scl}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio3_scl}]

#set_property PACKAGE_PIN AG14 [get_ports {rpi_gpio4_gpclk0}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio4_gpclk0}]

#set_property PACKAGE_PIN AH14 [get_ports {rpi_gpio5}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio5}]

#set_property PACKAGE_PIN AG13 [get_ports {rpi_gpio6}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio6}]

#set_property PACKAGE_PIN AH13 [get_ports {rpi_gpio7_ce1}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio7_ce1}]

#set_property PACKAGE_PIN AC14 [get_ports {rpi_gpio8_ce0}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio8_ce0}]

#set_property PACKAGE_PIN AC13 [get_ports {rpi_gpio9_miso}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio9_miso}]

#set_property PACKAGE_PIN AE13 [get_ports {rpi_gpio10_mosi}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio10_mosi}]

#set_property PACKAGE_PIN AF13 [get_ports {rpi_gpio11_sclk}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio11_sclk}]

#set_property PACKAGE_PIN AA13 [get_ports {rpi_gpio12_pwm0}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio12_pwm0}]

#set_property PACKAGE_PIN AB13 [get_ports {rpi_gpio13_pwm1}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio13_pwm1}]

#set_property PACKAGE_PIN W14 [get_ports {rpi_gpio14_txd}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio14_txd}]

#set_property PACKAGE_PIN W13 [get_ports {rpi_gpio15_rxd}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio15_rxd}]

#set_property PACKAGE_PIN AB15 [get_ports {rpi_gpio16}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio16}]

#set_property PACKAGE_PIN AB14 [get_ports {rpi_gpio17}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio17}]

#set_property PACKAGE_PIN Y14 [get_ports {rpi_gpio18_pcm_clk}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio18_pcm_clk}]

#set_property PACKAGE_PIN Y13 [get_ports {rpi_gpio19_pcm_fs}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio19_pcm_fs}]

#set_property PACKAGE_PIN W12 [get_ports {rpi_gpio20_pcm_din}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio20_pcm_din}]

#set_property PACKAGE_PIN W11 [get_ports {rpi_gpio21_pcm_dout}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio21_pcm_dout}]

#set_property PACKAGE_PIN Y12 [get_ports {rpi_gpio22}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio22}]

#set_property PACKAGE_PIN AA12 [get_ports {rpi_gpio23}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio23}]

#set_property PACKAGE_PIN Y9 [get_ports {rpi_gpio24}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio24}]

#set_property PACKAGE_PIN AA8 [get_ports {rpi_gpio25}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio25}]

#set_property PACKAGE_PIN AB10 [get_ports {rpi_gpio26}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio26}]

#set_property PACKAGE_PIN AB9 [get_ports {rpi_gpio27}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rpi_gpio27}]


# Additional I/O standards for flexibility:
#set_property IOSTANDARD LVCMOS33 [get_ports additional_io_signal]
#set_property IOSTANDARD LVDS [get_ports differential_signal_p]
#set_property IOSTANDARD LVDS [get_ports differential_signal_n]


###----Unused Pins----###

#set_property PULLUP true [get_ports unused_input]
#set_property PULLDOWN true [get_ports unused_output]


# ------------------------------------------------------------------------------
#  Clock Virtual clock        
# ------------------------------------------------------------------------------

## 25MHz clock
create_clock -period 40.000 -name clk_25MHz -waveform {0.000 20.000} [get_ports clk_25MHz]

## 26MHz positive clock
#create_clock -period 38.462 -name clk_26MHz_pos -waveform {0.000 19.231} [get_ports clk_26MHz_pos]

## 26MHz negative clock
#create_clock -period 38.462 -name clk_26MHz_neg -waveform {0.000 19.231} [get_ports clk_26MHz_neg]

## 27MHz positive clock
#create_clock -period 37.037 -name clk_27MHz_pos -waveform {0.000 18.519} [get_ports clk_27MHz_pos]

## 27MHz negative clock
#create_clock -period 37.037 -name clk_27MHz_neg -waveform {0.000 18.519} [get_ports clk_27MHz_neg]

## 74.25MHz positive clock
#create_clock -period 13.468 -name clk_74_25MHz_pos -waveform {0.000 6.734} [get_ports clk_74_25MHz_pos]

## 74.25MHz negative clock
#create_clock -period 13.468 -name clk_74_25MHz_neg -waveform {0.000 6.734} [get_ports clk_74_25MHz_neg]

## 125MHz positive clock
#create_clock -period 8.000 -name clk_125MHz_pos -waveform {0.000 4.000} [get_ports clk_125MHz_pos]

## 125MHz negative clock
#create_clock -period 8.000 -name clk_125MHz_neg -waveform {0.000 4.000} [get_ports clk_125MHz_neg]

## 156.25MHz positive clock
#create_clock -period 6.400 -name clk_156_25MHz_pos -waveform {0.000 3.200} [get_ports clk_156_25MHz_pos]

## 156.25MHz negative clock
#create_clock -period 6.400 -name clk_156_25MHz_neg -waveform {0.000 3.200} [get_ports clk_156_25MHz_neg]


# ------------------------------------------------------------------------------
# Clock Group
# ------------------------------------------------------------------------------

## Group clocks that are asynchronous to each other
#set_clock_groups -asynchronous -group [get_clocks clk_25MHz] -group [get_clocks clk_125MHz]


# ------------------------------------------------------------------------------
# Clock Domain Group
# ------------------------------------------------------------------------------

## Define clock domains for timing analysis
#set_clock_groups -group [get_clocks clk_25MHz] -group [get_clocks clk_74_25MHz] -physically_exclusive


# ------------------------------------------------------------------------------
#  Output Timing
# ------------------------------------------------------------------------------

##--template for output timing--##

## Set false paths for all outputs
#set_false_path -to [get_ports output_port[*]]

## Set output delays for each individual output: 1-2ns delay
#set_output_delay -clock [get_clocks clock_name] -min 1.000 [get_ports output_port]
#set_output_delay -clock [get_clocks clock_name] -max 2.000 [get_ports output_port]


##--All Output Timings for 25 MHz Clock--##

## Set output delays for PMOD1 pins
#set_output_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod1[*]]
#set_output_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod1[*]]

# Set output delays for PMOD2 pins
set_output_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod2[*]]
set_output_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod2[*]]

# Set output delays for PMOD3 pins
set_output_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod3[*]]
set_output_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod3[*]]

# Set output delays for PMOD4 pins
set_output_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod4[*]]
set_output_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod4[*]]

## Set output delays for RPi GPIO pins
#set_output_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports rpi_gpio[*]]
#set_output_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports rpi_gpio[*]]


# ------------------------------------------------------------------------------
#  Input Timing
# ------------------------------------------------------------------------------

##--template for input timing--##

## Set false paths for all inputs
#set_false_path -from [get_ports input_port[*]]

## Set input delays for each individual switch input: 1-2ns delay
#set_input_delay -clock [get_clocks clock_name] -min 1.000 [get_ports input_port]
#set_input_delay -clock [get_clocks clock_name] -max 2.000 [get_ports input_port]

##--All Output Timings for 25 MHz Clock--##

# Set input delays for RPi GPIO pins
set_input_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports rpi_gpio[*]]
set_input_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports rpi_gpio[*]]

# Set input delays for PMOD1 pins
set_input_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod1[*]]
set_input_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod1[*]]

## Set input delays for PMOD2 pins
#set_input_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod2[*]]
#set_input_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod2[*]]

## Set input delays for PMOD3 pins
#set_input_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod3[*]]
#set_input_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod3[*]]

## Set input delays for PMOD4 pins
#set_input_delay -clock [get_clocks clk_25MHz] -min 1.000 [get_ports pmod4[*]]
#set_input_delay -clock [get_clocks clk_25MHz] -max 2.000 [get_ports pmod4[*]]