# build.tcl -- Complete End-to-End Automation Pipeline for Lab 7

source common/lib.tcl

set proj_name "lab7"

# 1. Initialize Workspace Configuration
proj::init $proj_name

# 2. Package Custom IP Core(s) into vivado/ip_repo/
pack_ip $proj_name "hdmi_text_controller"

# 3. Create Vivado Implementation Project
proj::create $proj_name

# 4. Construct MicroBlaze Block Design & Wire Peripherals
bd::build $proj_name

# 5. Synthesize, Implement, Generate Bitstream & Export .xsa for Vitis
proj::export_hw $proj_name

puts "\n========================================================================"
puts "  Full build complete! Import 'vivado/lab7.xsa' into Vitis to begin SW."
puts "========================================================================"
