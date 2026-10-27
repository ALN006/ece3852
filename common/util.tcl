namespace eval util {
    # for  known-benign messages: still printed, but as INFO instead of WARNING
    proc demote_msgs {ids} {
        foreach id $ids {
            set_msg_config -id $id -severity WARNING -new_severity INFO
        }
    }
    proc close_all_open_projects {} {
        foreach p [get_projects -quiet] {
            current_project $p
            close_project
        }
    }
}
