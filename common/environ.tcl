# All configuration lives in namespace cfg. Read it as $cfg::<name>.
namespace eval cfg {

    # ---- from the command line ---- 
    if {$::argc < 1} {
        error "usage: vivado -mode batch -source common/build.tcl -tclargs <proj_name>"
    }
    variable proj_name [lindex $::argv 0]

    # ---- paths (derived from this file's location) ----
    variable root            [file normalize [file join [file dirname [info script]] ..]]
    variable design_src_dir  $root/$proj_name
    variable vivado_proj_dir $root/vivado/$proj_name
    variable ip_dir          $root/vivado/ip_repo
    variable ip_tmp_dir      $root/vivado/ip_tmp

    # ---- target hardware ----
    variable part            xc7s50csga324-1

    proc dump {} {
        puts "\n ALNs common tcl var config info:"
        foreach v [lsort [info vars ::cfg::*]] {
            puts [format "  %-16s = %s" [namespace tail $v] [set $v]]
        }
        puts ""
    }
}

