# common/util.tcl -- Logging and Project Utilities

namespace eval util {

    proc step {msg} {
        puts "\n------------------------------------------------------------------------"
        puts "   $msg"
        puts "------------------------------------------------------------------------\n"
    }

    proc close_all_open_projects {} {
        while {[catch {current_project}] == 0} {
            catch {close_project -no_save}
        }
    }
}
