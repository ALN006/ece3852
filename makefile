# Usage: make <target> TOP_MODULE=<top_module_name> [PROJECT=<project_dir>] [SRC=<src_dir>] [TEST=<verification_dir_name>] [BUILD=<build_dir_name>]
GREEN  := \033[0;32m
YELLOW := \033[0;33m
RED    := \033[0;31m
NC     := \033[0m

# Configurable defaults
PROJECT ?= final_project
SRC     ?= src
TEST    ?= test
BUILD   ?= build

# Guard for TOP_MODULE
ifndef TOP_MODULE
$(error $(RED)ERROR: TOP_MODULE is not defined. Usage: make <target> TOP_MODULE=<module_name>$(NC))
endif

SRC_DIR     := $(PROJECT)/$(SRC)
TEST_DIR    := $(PROJECT)/$(TEST)
BUILD_DIR   := $(PROJECT)/$(BUILD)
SRC_FILES   := $(wildcard $(SRC_DIR)/*.sv)
PKG_FILES 	:= $(wildcard $(SRC_DIR)/*_pkg.sv)
DESIGN_SV   := $(SRC_DIR)/$(TOP_MODULE).sv
TB_SV       := $(TEST_DIR)/test_$(TOP_MODULE).sv
FORMAL_SBY  := $(TEST_DIR)/$(TOP_MODULE).sby
FLAT_V     	:= $(BUILD_DIR)/$(TOP_MODULE)_flat.v
TB_BIN      := obj_dir/Vtest_$(TOP_MODULE)
DESIGN_VCD  := test_$(TOP_MODULE).vcd
DESIGN_JSON := $(TEST_DIR)/$(TOP_MODULE).json
DESIGN_SVG  := $(TEST_DIR)/$(TOP_MODULE).svg

.PHONY: lint_src lint_all_src flatten make_sby proof run_formal tb lint_tb compile_tb run_tb wave draw clean

lint_src: $(DESIGN_SV)
	@printf "\n $(GREEN) INFO: linting design src file $(DESIGN_SV)$(NC) \n\n"
	verilator --lint-only -fno-dfg -Wall -I$(SRC_DIR) $(DESIGN_SV) $(PKG_FILES)

lint_all_src: $(SRC_FILES)
	@printf "\n $(GREEN) INFO: linting all design src files in $(SRC_DIR)/$(NC) \n\n"
	verilator --lint-only -Wall -I$(SRC_DIR) $(SRC_FILES)

# Yosys's built-in frontend can't parse packages/imports, so convert with sv2v first
flatten: lint_src $(FLAT_V)
$(FLAT_V): $(SRC_FILES)
	@printf "\n $(GREEN) INFO: flattening $(TOP_MODULE) with sv2v into $(FLAT_V)$(NC) \n\n"
	@mkdir -p $(BUILD_DIR)
	sv2v -E Assert --top=$(TOP_MODULE) -I$(SRC_DIR) $(SRC_FILES) -w $(FLAT_V)

make_sby: lint_src $(FORMAL_SBY)
$(FORMAL_SBY): make_sby.zig
	@printf "\n $(GREEN) INFO: creating initial sby file for source file $(DESIGN_SV)$(NC) \n\n"
	zig run make_sby.zig -- $(TOP_MODULE) $(BUILD_DIR) $(TEST_DIR)

proof: lint_src $(FLAT_V) $(FORMAL_SBY)
	@printf "\n $(GREEN) INFO: running formal verification with SymbiYosys on $(DESIGN_SV)$(NC) \n\n"
	sby -f $(FORMAL_SBY)

tb: lint_src $(TB_SV)
$(TB_SV): make_tb.zig
	@printf "\n $(GREEN) INFO: creating initial tb file for source file $(DESIGN_SV)$(NC) \n\n"
	zig run make_tb.zig -- $(TOP_MODULE) $(SRC_DIR) $(TEST_DIR)

lint_tb: $(TB_SV) lint_src
	@printf "\n $(GREEN) INFO: linting a sim src file $(TB_SV)$(NC) \n\n"
	verilator --lint-only --timing -Wall -I$(SRC_DIR) $(TB_SV)

compile_tb: lint_tb $(TB_BIN)
$(TB_BIN): $(TB_SV) $(DESIGN_SV)
	@printf "\n $(GREEN) INFO: compiling sim source file for verilator$(NC) \n\n"
	verilator --binary --timing -Wall --trace --assert -I$(SRC_DIR) $(TB_SV) --top-module test_$(TOP_MODULE)

run_tb: $(TB_BIN) lint_src
	@printf "\n $(GREEN) INFO: running sim binary $(TB_BIN)$(NC) \n\n"
	./$(TB_BIN)

$(DESIGN_VCD): $(TB_BIN)
	@printf "\n $(GREEN) INFO: generating VCD waveform using $(TB_BIN)$(NC) \n\n"
	./$(TB_BIN)

wave: lint_src $(DESIGN_VCD)
	@printf "\n $(GREEN) INFO: opening GTKwave for expected waveform$(NC) \n\n"
	gtkwave $(DESIGN_VCD)

draw: lint_src $(FLAT_V) $(DESIGN_SVG)
$(DESIGN_JSON): $(FLAT_V)
	@printf "\n $(GREEN) INFO: creating JSON file from source file $(DESIGN_SV)$(NC) \n\n"
	yosys -p "read_verilog $(FLAT_V); prep -top $(TOP_MODULE); write_json $(DESIGN_JSON)"
$(DESIGN_SVG): $(DESIGN_JSON)
	@printf "\n $(GREEN) INFO: creating SVG file from JSON of source file $(DESIGN_SV) \n  if any labels are bad then edit the JSON file $(NC) \n\n"
	netlistsvg $(DESIGN_JSON) -o $(DESIGN_SVG)

clean:
	@printf "\n$(GREEN)  INFO: Cleaning up generated build files...$(NC)\n\n"
	rm -rf obj_dir *.vcd $(BUILD_DIR) $(TEST_DIR)/*.json $(TEST_DIR)/*.svg