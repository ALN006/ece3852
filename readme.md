# Doc keys:
1. <var> is a required variable 
2. [var] is a variable that is not required 
# conventions:
1. all .sv files are named either <top_module>.sv for design source files or test_<top_module>.sv
2. messages authored by us from the build system start with " INFO:"
3. clock is always "clk"
4. all signals are active high unless their name ends in _n
5. all signals are synchronous unless their name ends in _a
6. all signals are free of random bounces unless their name ends in _b
7. from lab4 onwards reset is always asynchronous and active low so that a cut to power will cause a reset

# debug help:
1. this project uses GNU make, to debug errors one may in the appropriate place add echo $? to output the exit status of the last program run
2. some zig files are used in the build system of this project, it may be helpful to know that in the event of an error handles with the "try" keyword
   a stack trace is dumped into stderr.
3. Inferred latches can be more easily caught by setting set_msg_config -id {Synth 8-87} -new_severity {ERROR} in Tcl Console
4. The local directory to Vivado's batch file is located at C:/Xilinx/Vivado/2022.2/bin/vivado.bat

# externel documentation:
1. Urbana Board Documentation (XC7S50CSGA324-1): https://www.realdigital.org/doc/496fed57c6b275735fe24c85de5718c2

# final project research material:
1. working fpga 3d renderer: https://community.element14.com/challenges-projects/element14-presents/project-videos/w/documents/27700/3d-object-rendering-using-an-fpga----episode-558?CMP=SOM-YOUTUBE-PRG-E14PRESENTS-e14Presents-558
2. kinda useless tangent: https://www.youtube.com/watch?v=VzGw7CiEiJY
3. common bg cc cs vid: https://www.youtube.com/watch?v=TEAtmCYYKZA
