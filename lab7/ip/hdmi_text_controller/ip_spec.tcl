set ip_dir [ file dirname [ file normalize [ info script ] ] ]

dict create \
	vendor	"xilinx.com" \
	library "user" \
	name 	"hdmi_text_controller" \
	version "1.0" \
	vlnv 	"xilinx.com:user:hdmi_text_controller:1.0" \
	dependencies {
		{
			vlnv realdigital.org:realdigital:hdmi_tx:1.0
			configurations {
				CONFIG.MODE {HDMI}
				CONFIG.C_RED_WIDTH {4}
				CONFIG.C_GREEN_WIDTH {4}
				CONFIG.C_BLUE_WIDTH {4}
			}
		}
		{
			vlnv xilinx.com:ip:clk_wiz:6.0
			configurations {
				CONFIG.PRIM_IN_FREQ {100.000}
				CONFIG.NUM_OUT_CLKS {2}
				CONFIG.CLKOUT2_USED {true}
				CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.000}
				CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125.000}
			}
		}
	} \
	sources [glob -nocomplain [file join $ip_dir src *.sv]] \
	ip_dir $ip_dir
