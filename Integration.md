## Step 3: Integrating with the VSDSquadron FPGA Mini Board
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
5. Observe the behavior of the RGB LED on the board to confirm successful programming.
