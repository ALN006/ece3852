# Entry point for the Vivado build system.
puts "Starting Vivado build..."

# Find the directory containing this script.
set root [file dirname [file normalize [info script]]]

source [file join $root common cfg.tcl]
source [file join $root common proj.tcl]
source [file join $root common src.tcl]
source [file join $root common constr.tcl]
source [file join $root common ip.tcl]

set target [lindex $argv 0]
if {$target eq "clean"} {
	set generated_dir [file join $root vivado $cfg::project_name]
	if {[file exists $generated_dir]} {
		file delete -force $generated_dir
		puts "Removed generated project: $generated_dir"
	} else {
		puts "Nothing to clean: $generated_dir does not exist"
	}

	return
}	
if {$target eq "help"} {
    puts "Usage: vivado -mode batch -source build.tcl -tclargs <target>"
    puts ""
    puts "Targets:"
    puts "  all    Run synthesis and implementation (default)"
    puts "  synth  Run synthesis only"
    puts "  clean  Remove generated project files"
    puts "  help   Display this message"
    return
}
if {$target eq ""} { set target "all" }
if {$target ni {all synth clean help sources}} {
    error "Unknown build target '$target'. Use: all, synth, clean, help"
}

set project_name [lindex $argv 1]
if {$project_name eq ""} { set project_name $cfg::project_name }

set jobs [lindex $argv 2]
if {$jobs eq ""} { set jobs $cfg::default_jobs }

set top_module [lindex $argv 3]
if {$top_module eq ""} { set top_module $cfg::top_module }

proj::open_prj $project_name
ip::register_repositories
set spec [ ip::load_spec [ file join $root lab7 ip hdmi_text_controller ] ]
ip::validate_dependencies $spec

set clk_wiz_dependency [lindex [dict get $spec dependencies] 1]
set clk_wiz [ ip::create_configured_ip $clk_wiz_dependency [file join $root vivado $project_name ip ] ]
ip::generate_ip $clk_wiz

set hdmi_def [get_ipdefs -all realdigital.org:realdigital:hdmi_tx:1.0]
report_property $hdmi_def

src::add_hdl $project_name
constr::add_xdc $project_name
proj::set_top $top_module

proj::run_target $target 4
