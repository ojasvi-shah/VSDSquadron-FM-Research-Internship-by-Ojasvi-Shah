# VSDSquadron FM Research Internship by Ojasvi Shah
The **VSDSquadron FPGA Mini (FM)** is a compact and low-cost development board designed for FPGA prototyping and embedded system projects. This board provides a seamless hardware development experience with an integrated programmer, versatile GPIO access, and onboard memory, making it ideal for students, hobbyists, and developers exploring FPGA-based designs. ([source](https://www.vlsisystemdesign.com/vsdsquadronfm/))

# Task 1: Understanding and Implementing the Verilog Code on FM
## Objective: 
Understanding and documenting the provided Verilog code, creating the necessary PCF file, and integrating the design with the [VSDSquadron FPGA Mini Board](https://www.vlsisystemdesign.com/vsdsquadronfm/) using the provided [datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf)

## Contents:
### Step 1: Understanding the Verilog code
The Verilog code can be accessed [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSDFM_top_module.v). It is code for a FPGA (Field Programmable Gate Array) board, and implements a hardware module that controls RGB LEDs using an internal oscillator and counter. Now, for the description of the module, expand or collapse:
<details>
<summary>Module Analysis </summary>

### Port Analysis:
The first section of the code specifies the **ports** of the board, which are in the form of:
1. *led_red, led_blue, led_green* : These **three output wires** control the **RGB LED colors**. Each wire carries a **single-bit signal** that determines whether its corresponding color is **active** (1) or **inactive** (0).
2. *hw_clk* : A **single-bit input wire** that connects to the **hardware oscillator**, providing the system **clock signal** that drives the module's timing.
3. *testwire* : A **single-bit output** that provides a **test/debug signal**, specifically connected to **bit 5** of the frequency counter.

### Internal Component Analysis:
The module specifies three main internal components:

**1. Internal Oscilliator (*SB_HFOSC*)**
- Purpose: This generates a stable internal clock signal
- Configuration: Uses CLKHF_DIV = "0b10" (binary 2) for clock division
- Control Signals:
    1. *CLKHFPU = 1'b1* : Enables power-up
    2. *CLKHFEN = 1'b1* : Enables oscillator
    3. *CLKHF* : Output connected to internal *int_osc* signal

**2. Frequency Counter Logic**
- Implementation: 28-bit register (*frequency_counter_i*)
- Operation: Increments on every positive edge of *int_osc*
- Test functionality: Bit 5 is routed to *testwire* for monitoring
- Purpose: Provides a way to verify oscillator operation and timing


**3. RGB LED Driver (*SB_RGBA_DRV*)**

- Configuration:
    1. *RGBLEDEN = 1'b1* : Enables LED operation
    2. *RGB0PWM = 1'b0* : Red LED minimum brightness
    3. *RGB1PWM = 1'b0* : Green LED minimum brightness
    4. *RGB2PWM = 1'b1* : Blue LED maximum brightness
    5. *CURREN = 1'b1* : Enables current control
- Current settings: All LEDs set to "0b000001" (minimum current)
- Output connections:
    1. *RGB0* → *led_red*
    2. *RGB1* → *led_green*
    3. *RGB2* → *led_blue*
### Module Documentation (Summary)
**Purpose**

This Verilog module implements an RGB LED controller with internal timing capabilities. It provides a stable internal clock source and manages RGB LED outputs while maintaining testability through a dedicated test signal. It provides a complete solution for RGB LED control with built-in timing and test capabilities, and is suitable for embedded systems requiring stable LED operation with minimal external dependencies.

**Internal Logic and Oscillator**

The module uses a high-frequency oscillator (*SB_HFOSC*) as its internal timing source. The oscillator's output drives a 28-bit frequency counter, which provides both timing information and a test signal. The counter's bit 5 is routed to the *testwire* output for external monitoring.

**RGB LED Driver Functionality**

The RGB LED driver (SB_RGBA_DRV) manages the LED outputs with the following characteristics:

- Current-controlled outputs with minimum current setting ("0b000001")
- Pulse Width Modulation (PWM) control for each color channel
- Fixed configuration:
    1. Blue LED at maximum brightness (*RGB2PWM = 1'b1*)
    2. Red and Green LEDs at minimum brightness (*RGB0PWM = RGB1PWM = 1'b0*)
</details>

### Step 2: Creating the PCF file
### Step 3: Integrating with the VSDSquadron FPGA Mini Board
### Step 4: Final Documentation

# Task 2: Implementing a UART feedback mechanism
## Objective:
Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality

## Contents:
### Step 1: Study the Existing Code
### Step 2: Design Documentation
### Step 3: Implementation
### Step 4: Testing and Verification
### Step 5: Documentation
