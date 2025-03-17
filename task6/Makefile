# Define project-specific variables
TOP=clk_d
PCF_FILE=VSDSquadronFM
BOARD_FREQ=12
CPU_FREQ=20
FPGA_VARIANT=up5k
FPGA_PACKAGE=sg48
VERILOG_FILE=clk_d.v

#Uart Var
PICO_DEVICE=/dev/ttyUSB0
BAUDS=9600

build:
      yosys -DCPU_freq=$(CPU_FREQ) -q -p "synth_ice40 -abc9 -device u -dsp -top $(TOP) -json $(TOP).json" $(VERILOG_FILE)
      nextpnr-ice40 --force --json $(TOP).json --pcf $(PCF_FILE).pcf --asc $(TOP).asc --freq $(BOARD_FREQ) --$(FPGA_VARIANT) --package $(FPGA_PACKAGE) --opt-timing
      icetime -p $(PCF_FILE).pcf -P $(FPGA_PACKAGE) -r $(TOP).timings -d $(FPGA_VARIANT) -t $(TOP).asc
      icepack -s $(TOP).asc $(TOP).bin

flash:
      iceprog $(TOP).bin

clean:
      rm -rf $(TOP).blif $(TOP).asc $(TOP).bin $(TOP).json $(TOP).timings

terminal:
      sudo picocom -b $(BAUDS) $(PICO_DEVICE) --imap lfcrlf,crcrlf --omap delbs,crlf --omap delbs,crlf --send-cmd "ascii-xfr -s -l 30 -n"

test:
      iverilog -o testbench testbench.sv -Wall -g2005 -sv
      vvp testbench -fst
      gtkwave testbench.vcd
