## Step 2: Creating the PCF file

The PCF [Physical Constraint File] file can be accessed [here](https://github.com/ojasvi-shah/VSDSquadron-FM-Research-Internship-by-Ojasvi-Shah/blob/main/VSDFM.pcf). It is used in FPGA development to map logical signals from HDL code to physical pins on the FPGA chip. Each *set_io* command establishes this connection between the named ports to physical pins on the board. The connections established by this file can be represented as follows:

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
