# common/cfg.tcl -- Configuration & Path Management

namespace eval cfg {
    variable root_dir
    variable proj_dir
    variable ip_repo_dir
    variable part "xc7s50csga324-1" ;# Default part for Urbana board (Spartan-7)

    proc init {proj_name {target_part ""}} {
        variable root_dir
        variable proj_dir
        variable ip_repo_dir
        variable part

        set script_dir  [file dirname [file normalize [info script]]]
        set root_dir    [file normalize [file join $script_dir ".."]]
        set proj_dir    [file join $root_dir $proj_name]
        set ip_repo_dir [file join $root_dir vivado ip_repo]

        if {$target_part ne ""} {
            set part $target_part
        }

        file mkdir $ip_repo_dir
    }
}
