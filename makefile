VIVADO ?= C:/Xilinx/Vivado/2022.2/bin/vivado.bat

XPR := vivado/$(PROJ)/$(PROJ).xpr
RTL := $(wildcard $(PROJ)/rtl/*.sv)
XDC := $(PROJ)/constraints.xdc

.PHONY: proj clean

proj: common/make_proj.tcl $(RTL) $(XDC)
	$(VIVADO) -mode batch -source common/make_proj.tcl -tclargs $(PROJ)

clean:
	rm -rf vivado/$(PROJ)
