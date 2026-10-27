# common/ip.tcl -- IP Packaging Engine

namespace eval ip {

    proc dir_name {name ver} {
        return ${name}_[string map {. _} $ver]
    }

    proc generate_stock_peripheral {name ver vendor library} {
        set folder  [dir_name $name $ver]
        set ip_root [file join $::cfg::ip_repo_dir $folder]
        set tmp_dir [file join $::cfg::root_dir vivado ip_tmp $name]

        file delete -force $ip_root $tmp_dir
        file mkdir $tmp_dir

        create_project -force tmp_ip_gen_prj [file join $tmp_dir tmp_ip_gen_prj] -part $::cfg::part
        create_peripheral $vendor $library $name $ver -dir $::cfg::ip_repo_dir
        set ip_ref [ipx::find_open_core $vendor:$library:$name:$ver]

        add_peripheral_interface AXI -interface_mode slave -axi_type lite $ip_ref
        generate_peripheral -driver $ip_ref
        write_peripheral $ip_ref
        close_project

        return [list $ip_root $tmp_dir]
    }

    proc open_edit {name ip_root tmp_dir} {
        create_project -force tmp_ip_edit_prj_host [file join $tmp_dir tmp_ip_edit_prj_host] -part $::cfg::part
        ipx::edit_ip_in_project -name tmp_ip_edit_prj -upgrade true -directory $tmp_dir [file join $ip_root component.xml]
        current_project tmp_ip_edit_prj

        set_property ip_repo_paths [list $::cfg::root_dir $::cfg::ip_repo_dir] [current_project]
        update_ip_catalog -rebuild
    }

    proc add_nested {nested} {
        if {![dict size $nested]} { return }

        foreach {module_name spec} $nested {
            set vlnv [dict get $spec vlnv]
            set match [get_ipdefs -all -filter "VLNV == $vlnv"]
            if {[llength $match] == 0} {
                error "ip::add_nested: VLNV '$vlnv' ($module_name) not found in IP catalog."
            }

            lassign [split $vlnv :] vendor library name ver
            if {$ver ne ""} {
                create_ip -name $name -vendor $vendor -library $library -version $ver -module_name $module_name
            } else {
                create_ip -name $name -vendor $vendor -library $library -module_name $module_name
            }

            if {[dict exists $spec config]} {
                set_property -dict [dict get $spec config] [get_ips $module_name]
            }

            generate_target all [get_ips $module_name]
        }
    }

    proc swap_sources {top ip_root ip_dir} {
        set src_dir [file join $ip_dir src]
        if {![file isdirectory $src_dir]} {
            error "ip::swap_sources: Missing HDL directory '$src_dir'"
        }

        set sources [glob -nocomplain -directory $src_dir *.sv *.v *.vh *.vhdl *.vhd]
        if {[llength $sources] == 0} {
            error "ip::swap_sources: No HDL source files (*.sv/*.v) found in $src_dir"
        }

        remove_files [get_files */hdl/*.v]
        file delete -force [file join $ip_root hdl]

        set target_src [file join $ip_root src]
        file mkdir $target_src
        foreach f $sources {
            file copy -force $f $target_src
        }

        add_files -norecurse [glob -nocomplain -directory $target_src *]

        set_property top $top [current_fileset]
        update_compile_order -fileset sources_1

        ipx::merge_project_changes files [ipx::current_core]
        ipx::merge_project_changes ports [ipx::current_core]
    }

    proc import_driver {name ip_root ip_dir} {
        set drv_dir [file join $ip_dir drivers]
        if {![file isdirectory $drv_dir]} { return }

        set drv_files [glob -nocomplain -directory $drv_dir *]
        if {![llength $drv_files]} { return }

        set target_drv [lindex [glob -nocomplain -directory [file join $ip_root drivers] */src] 0]
        if {$target_drv eq ""} { return }

        foreach f $drv_files {
            if {[file isfile $f]} {
                file copy -force $f $target_drv
            }
        }

        set selftest_file [file join $target_drv ${name}_selftest.c]
        if {[file exists $selftest_file]} {
            set rel_path [string range $target_drv [expr {[string length $ip_root] + 1}] end]
            catch {
                ipx::remove_file [file join $rel_path ${name}_selftest.c] \
                    [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
            }
            file delete -force $selftest_file
        }
    }

    proc add_interfaces {interfaces} {
        set core [ipx::current_core]
        foreach {if_name spec} $interfaces {
            set map [dict get $spec map]

            foreach {logical physical} $map {
                if {[llength [ipx::get_ports $physical -of_objects $core]] == 0} {
                    error "ip::add_interfaces: Port '$physical' not found in IP top-level HDL"
                }
            }

            if {[llength [ipx::get_bus_interfaces $if_name -of_objects $core]] > 0} {
                ipx::remove_bus_interface $if_name $core
            }

            foreach physical [dict values $map] {
                foreach bi [ipx::get_bus_interfaces -of_objects $core] {
                    if {[get_property name $bi] eq $physical} {
                        ipx::remove_bus_interface $physical $core
                    }
                }
            }

            ipx::add_bus_interface $if_name $core
            set bi [ipx::get_bus_interfaces $if_name -of_objects $core]
            set_property abstraction_type_vlnv [dict get $spec abstraction] $bi
            set_property bus_type_vlnv         [dict get $spec bus_type]    $bi
            set_property interface_mode        [dict get $spec mode]        $bi

            if {[dict exists $spec description]} {
                set_property description [dict get $spec description] $bi
            }

            foreach {logical physical} $map {
                ipx::add_port_map $logical $bi
                set_property physical_name $physical [ipx::get_port_maps $logical -of_objects $bi]
            }
        }
    }

    proc repackage {rev} {
        set core [ipx::current_core]
        set_property core_revision $rev $core
        ipx::update_source_project_archive -component $core
        ipx::create_xgui_files $core
        ipx::update_checksums $core
        ipx::check_integrity $core
        ipx::save_core $core
    }
<<<<<<< HEAD

    proc build_dir {ip_dir} {
        set spec_file [file join $ip_dir ip_spec.tcl]
        if {![file exists $spec_file]} {
            set spec_file [file join $ip_dir ip.tcl]
        }
        if {![file exists $spec_file]} {
            error "ip::build_dir: Missing manifest (ip_spec.tcl) in $ip_dir"
        }

        catch {unset ::ip_spec}
        catch {unset ::manifest}
        source $spec_file

        if {[info exists ::ip_spec]} {
            set s $::ip_spec
        } elseif {[info exists ::manifest]} {
            set s $::manifest
        } else {
            error "ip::build_dir: $spec_file must define 'ip_spec' or 'manifest'"
        }

        set required_keys {name version revision vendor library top nested interfaces}
        foreach key $required_keys {
            if {![dict exists $s $key]} {
                error "ip::build_dir: Manifest '$spec_file' missing required key '$key'"
            }
        }

        unset -nocomplain ::ip_spec ::manifest

        set name    [dict get $s name]
        set ver     [dict get $s version]
        set vendor  [dict get $s vendor]
        set library [dict get $s library]

        util::step "ip $name $ver: Generating Base Peripheral"
        lassign [generate_stock_peripheral $name $ver $vendor $library] ip_root tmp_dir

        util::step "ip $name: Opening Host Edit Project"
        open_edit $name $ip_root $tmp_dir

        add_nested [dict get $s nested]
        swap_sources [dict get $s top] $ip_root $ip_dir
        add_interfaces [dict get $s interfaces]
        import_driver $name $ip_root $ip_dir

        util::step "ip $name: Finalizing Core Repackaging"
        repackage [dict get $s revision]
    }

    proc pack {proj_name {target_ip ""}} {
        cfg::init $proj_name

        set ip_root_dir [file join $::cfg::proj_dir ip]
        if {![file isdirectory $ip_root_dir]} {
            error "ip::pack: Directory '$ip_root_dir' does not exist."
        }

        if {$target_ip ne ""} {
            set ip_dirs [list [file join $ip_root_dir $target_ip]]
        } else {
            set ip_dirs [glob -nocomplain -type d [file join $ip_root_dir *]]
        }

        util::close_all_open_projects

        set packaged_count 0
        foreach ip_dir $ip_dirs {
            if {[file exists [file join $ip_dir ip_spec.tcl]] || [file exists [file join $ip_dir ip.tcl]]} {
                util::step "Packaging IP core: [file tail $ip_dir]"
                build_dir $ip_dir
                incr packaged_count
            } else {
                puts "Skipping '[file tail $ip_dir]': No manifest (ip_spec.tcl) found."
            }
        }

        puts "\n=== Successfully Packaged $packaged_count IP Core(s) into $::cfg::ip_repo_dir ==="
        return $packaged_count
    }
}

proc pack_ip {proj_name {target_ip ""}} {
    return [ip::pack $proj_name $target_ip]
}
=======
}

>>>>>>> cb661fda3c815add44122896a954d93327282313
