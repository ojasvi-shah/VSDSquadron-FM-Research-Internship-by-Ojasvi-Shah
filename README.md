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
![image](https://github.com/user-attachments/assets/7a82694b-1b5f-4ad3-bd6b-34b755812aed)

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
The PCF [Physical Constraint File] file can be accessed [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSDFM.pcf). It is used in FPGA development to map logical signals from HDL code to physical pins on the FPGA chip. Each *set_io* command establishes this connection between the named ports to physical pins on the board. To understand the connections established by this file, expand or collapse:

<details>
<summary>Analysis of Connections Established by PCF file</summary>

![image](https://github.com/user-attachments/assets/1e4f786f-e4fd-413c-b556-eb6c0b1b8046)

Further breaking down each command:

### 1. *set_io led_red 39*
This command maps the logical signal *led_red* to the physical pin 39, allowing the HDL code to control a LED (color red is implied) connected to pin 39.

### 2. *set_io led_blue 40*
This command maps the logical signal *led_blue* to the physical pin 40, allowing the HDL code to control a LED (color blue is implied) connected to pin 40.

### 3. *set_io led_green 41*
This command maps the logical signal *led_green* to the physical pin 41, allowing the HDL code to control a LED (color green is implied) connected to pin 41.

### 4. *set_io hw_clk 20*
This command assigns the hardware clock signal *hw_clk* to the physical pin 20, allowing the HDL code to recieve clock inputs through pin 20.

### 5. *set_io testwire 17*
This command maps *testwire* to pin 17, for testing or debugging purposes.
</details>

### Step 3: Integrating with the VSDSquadron FPGA Mini Board
To view the steps to integrate the code with the VSDSquadron FM board, along with the neccessary resources and documentation of the outcome, expand or collapse:

<details>
<summary>Steps of Integrating the Board </summary>
    
### Links
1. Datasheet: [here](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf)
2. Makefile: [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/Makefile)
3. ASC code: [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSD_top_module.asc)
4. JSON code: [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSD_top_module.json)
5. Module Timings: [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSD_top_module.timings)
### Steps to Follow (based on instructions)
1. Reviewing the [VSDSquadron FPGA Mini board datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf) to understand its features and pinout.
2. Using the [datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf) to correlate the physical board connections with the PCF file and Verilog code.
3. Connecting the board to the computer as described in the datasheet (e.g., using USB-C and ensuring FTDI connection).
4. Following the [Makefile](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/Makefile) for building and flashing the Verilog code:
   - Run 'make clean' to clear any previous builds
   - Run 'make build' to compile the design
   - Run 'sudo make flash' to program the FPGA board
5. Observe the behavior of the RGB LED (blinks) on the board to confirm successful programming.

> after make clean: board should look as follows:
> 
> ![image](https://github.com/user-attachments/assets/3f63fccf-8a91-44f1-a29b-aae4f53eb868)

### Final Behaviour

https://github.com/user-attachments/assets/51266b8f-1425-4bfa-a260-f847d74f84de
</details>

### Step 4: Final Documentation
To access the final documentation of task 1, expand or collapse:

<details>
<summary>Final Documentation of Task 1</summary>
    
### Summary of the Verilog code functionality
This [Verilog module](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSDFM_top_module.v) controls an RGB LED with an internal high-frequency oscillator (SB_HFOSC) and a 28-bit frequency counter. The counter's bit 5 is routed to a testwire for monitoring. The RGB LED driver (SB_RGBA_DRV) provides current-controlled PWM outputs with a fixed configuration: blue at maximum brightness, red and green at minimum. It ensures stable LED operation with minimal external dependencies, making it ideal for embedded systems.

### Pin mapping details from the PCF file
The [PCF file](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSDFM.pcf) can be represented as follows:

![image](https://github.com/user-attachments/assets/2dbad546-0b2e-4343-a7e3-c751d4357831)

The file maps a red LED to pin 39, a blue LED to pin 40, a green LED to pin 41, a clock signal to pin 20, and lastly a testwire to pin 17. This also corresponds with the [datasheet](https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/VSDSquadronFMDatasheet.pdf).

### Understanding and Implementing the Verilog Code 
1. Follow the datasheet and install all the tools needed (Yosys for logic synthesis, NextPNR for placement and routing, IceStorm for Bitstream generation, and Git for Version control)
2. Verify the physical board connections between the PCF file and Verilog code
3. Connect the board to the computer as described in the datasheet (e.g., using USB-C and ensuring FTDI connection).
4. Follow the [Makefile](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/Makefile) for building and flashing the Verilog code: (run the following steps)
     - Run 'make clean' to clear any previous builds
     - Run 'make build' to compile the design
     - Run 'sudo make flash' to program the FPGA board
5. Verify that LED remains BLINKS (controlled by SB_RGBA_DRV) - this is the expected result:

https://github.com/user-attachments/assets/9d173465-1031-4fe9-bf60-272951dd391f


### Challenges Faced and Solutions Implemented
- Faced difficulty in connecting board: was able to refer group where someone had already found a solution - a USBC cable that could transfer data was needed
- Found it kind of hard to understand the verilog originally - google searches were able to clear things up
</details>

# Task 2: Implementing a UART feedback mechanism
## Objective:
Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality

## Contents:
### Step 1: Study the Existing Code
UART (Universal Asynchronous Receiver-Transmitter) is a hardware communication protocol used for serial communication between devices. It consists of two main data lines: the TX (Transmit) pin and the RX (Receive) pin. Specifically, a UART loopback mechanism is a test or diagnostic mode where data, which is transmitted to the TX (transmit) pin is directly routed back to the RX (receive) pin of the same module. This allows the system to verify that the TX and RX lines function correctly without the need of an external device. The existing code can be found here. It is sourced from this repository. For the analysis of this code, expand or collapse:

<details>
<summary>Analysis of Existing Code</summary>

### Port Analysis:
The module explains six ports:
- Three **RGB LED outputs** (led_red, led_blue, led_green)
- **UART transmit/receive pins** (uarttx, uartrx)
- **System clock input** (hw_clk)

### Internal Component Analysis
1. **Internal Oscilliator** (SB_HFOSC)
- Implements a high-frequency oscillator
- Uses CLKHF_DIV = "0b10" for frequency division
- Generates internal clock signal (int_osc)

2. **Frequency Counter**
- 28-bit counter (frequency_counter_i)
- Increments on every positive edge of internal oscillator
- Used for timing generation

3. **UART Loopback**
- Direct connection between transmit and receive pins
- Echoes back any received UART data immediately

4. **RGB LED Driver** (SB_RGBA_DRV)
- Controls three RGB channels
- Uses PWM (Pulse Width Modulation) for brightness control
- Current settings configured for each channel
- Maps UART input directly to LED intensity

### Operation Analysis
1. **UART Input Processing**
- Received UART data appears on *uartrx* pin
- Data is immediately looped back out through *uarttx*
- Same data drives all RGB channels simultaneously
2. **LED Control**
- RGB driver converts UART signal to PWM output
- All LEDs respond identically to input signal
- Current limiting set to minimum (0b000001) for each channel
3. **Timing Generation**
- Internal oscillator provides clock reference
- Frequency counter generates timing signals
- Used for PWM generation and LED control
</details>

### Step 2: Design Documentation

<details>
<summary>Block Diagram Illustrating the UART Loopback Architecture.</summary>

![image](https://github.com/user-attachments/assets/3447a27b-59fe-49e7-9c73-9a85f39c8a7d)
</details>

<details>
<summary>Detailed Circuit Diagram showing Connections between the FPGA and any Peripheral Devices used.</summary>

![image](https://github.com/user-attachments/assets/af77ea52-38ef-415a-a724-43abf43bc207)
</details>

### Step 3: Implementation
### Step 4: Testing and Verification
### Step 5: Documentation
