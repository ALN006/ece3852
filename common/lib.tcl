# common/lib.tcl -- Dynamically sources all .tcl modules in common/

set _self   [file normalize [info script]]
set lib_dir [file dirname $_self]

foreach f [glob -nocomplain -type f [file join $lib_dir *.tcl]] { 
    set f_norm [file normalize $f]
    if {$f_norm eq $_self} { continue }
    if {[catch {source -notrace $f_norm}]} {
        source $f_norm
    }
}

unset lib_dir _self f f_norm
