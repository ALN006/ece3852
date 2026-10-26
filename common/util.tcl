namespace eval util {
    # known-benign messages: still printed, but as INFO instead of WARNING
    proc demote_msgs {ids} {
        foreach id $ids {
            set_msg_config -id $id -severity WARNING -new_severity INFO
        }
    }
}
