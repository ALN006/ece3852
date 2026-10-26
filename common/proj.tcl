namespace eval proj {
    proc create {name dir part ip_repo} {
        file mkdir $ip_repo
        create_project -force $name $dir -part $part
        set_property ip_repo_paths $ip_repo [current_project]
        update_ip_catalog -rebuild
    }

    proc open_existing {xpr} {
        if {[llength [get_projects -quiet]] == 0} {
            open_project $xpr
        }
    }
}
