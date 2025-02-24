## Step 4: Final Documentation

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
5. Verify that Blue LED remains ON (controlled by SB_RGBA_DRV) - this is the expected result.

### Challenges Faced and Solutions Implemented
- faced difficulty in connecting board: was able to refer group where someone had already found a solution - a USBC cable that could transfer data was needed
- found it kind of hard to understand the verilog originally - google searches were able to clear things up
