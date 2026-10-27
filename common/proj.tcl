# common/proj.tcl -- Project Lifecycle & Hardware Platform Export Engine

namespace eval proj {

    proc init {proj_name} {
        cfg::init $proj_name

        if {[catch {current_project}] == 0} {
            set current_repos [get_property ip_repo_paths [current_project]]
            set all_repos     [lsort -unique [concat $current_repos [list $::cfg::root_dir $::cfg::ip_repo_dir]]]
            set_property ip_repo_paths $all_repos [current_project]
            update_ip_catalog -rebuild
        }

        puts "=== Project '$proj_name' Initialized ==="
    }

    proc create {proj_name} {
        init $proj_name
        util::close_all_open_projects

        set proj_dir [file join $::cfg::root_dir vivado $proj_name]
        create_project -force $proj_name $proj_dir -part $::cfg::part

        set_property ip_repo_paths [list $::cfg::root_dir $::cfg::ip_repo_dir] [current_project]
        update_ip_catalog -rebuild
    }

    proc export_hw {proj_name} {
        cfg::init $proj_name
        util::step "Building Bitstream and Exporting XSA Platform for Vitis"

        set prj_file [file join $::cfg::root_dir vivado $proj_name ${proj_name}.xpr]
        if {![file exists $prj_file]} {
            error "proj::export_hw: Project file '$prj_file' does not exist."
        }

        open_project $prj_file

        # Generate HDL wrapper for the Block Design if not present
        set bd_file [get_files *.bd]
        if {[llength $bd_file] > 0} {
            make_wrapper -files $bd_file -top
            set bd_dir [file dirname [lindex $bd_file 0]]
            set wrapper_files [glob -nocomplain [file join $::cfg::root_dir vivado $proj_name ${proj_name}.gen sources_1 bd * hdl *_wrapper.v]]
            if {[llength $wrapper_files] > 0} {
                add_files -norecurse $wrapper_files
            }
        }

        # Run Synthesis, Implementation, and Bitstream Generation
        launch_runs impl_1 -to_step write_bitstream -jobs 4
        wait_on_run impl_1

        if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
            error "proj::export_hw: Implementation run failed."
        }

        # Export fixed hardware archive (.xsa) with bitstream for Vitis
        set xsa_path [file join $::cfg::root_dir vivado ${proj_name}.xsa]
        write_hw_platform -fixed -include_bit -force -file $xsa_path

        puts "\n=== Successfully Exported Vitis Hardware Platform: $xsa_path ==="
    }
    # Add the top-level RTL and the pin constraints, and set the top module.
    proc add_sources {top_file xdc_file top_module} {
        foreach f [list $top_file $xdc_file] {
            if {![file exists $f]} { error "proj::add_sources: missing file $f" }
        }
        add_files -norecurse $top_file
        add_files -fileset constrs_1 -norecurse $xdc_file

        set_property top $top_module [current_fileset]
        update_compile_order -fileset sources_1
    }
}

proc proj_init {proj_name} {
    return [proj::init $proj_name]
}
