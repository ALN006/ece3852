VIVADO ?= C:/Xilinx/Vivado/2022.2/bin/vivado.bat

XPR := vivado/$(PROJ)/$(PROJ).xpr
RTL := $(wildcard $(PROJ)/rtl/*.sv)
XDC := $(PROJ)/constraints.xdc

.PHONY: proj clean

proj: $(XPR)
	
$(XPR): common/make_proj.tcl
	$(VIVADO) -mode batch -source common/make_proj.tcl -tclargs $(PROJ)

rebuild:
	$(MAKE) clean PROJ=$(PROJ)
	$(MAKE) proj PROJ=$(PROJ)

clean:
	rm -rf vivado/$(PROJ)
