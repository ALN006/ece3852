VIVADO ?= C:/Xilinx/Vivado/2022.2/bin/vivado.bat

ifeq ($(PROJ),) 
$(error usage: make proj|rebuild|clean PROJ=<project_name>) 
endif

XPR := vivado/$(PROJ)/$(PROJ).xpr
RTL := $(wildcard $(PROJ)/rtl/*.sv)
XDC := $(PROJ)/constraints.xdc

.PHONY: proj clean

proj: $(XPR)
	
$(XPR): common/make_proj.tcl
	$(VIVADO) -mode batch -source common/make_proj.tcl -tclargs $(PROJ) $(MB)

rebuild:
	$(MAKE) clean PROJ=$(PROJ)
	$(MAKE) proj PROJ=$(PROJ)

clean:
	rm $(wildcard *.jou)
	rm $(wildcard *.log)
	rm -rf vivado/$(PROJ)
