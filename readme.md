# Overview:
Welcome to the ECE 385 final project Repo of Aditya LN and Nick S. Here we have attempted to implement 3D polar pong on the spartan 7!

The cool stuff is in /final_project, other tangential code and convetions are documented bellow.

## The TCL library:
the tcl library lives in /common at the moment, it is still in a nacent stage. This is a vibecoded library capable of automating all vivado usage pre lab6 of ece 385. It Has some potential to be quite useful, imagine never having to open the vivado GUI agian (unless its for actually useful things like looking at a block diagram).

Contributions, feedback... All Welcome! 

## Doc keys:
1. < var > is a required variable 
2. [ var ] is a variable that is not required 

## conventions:
1. all .sv files are named either < top_module >.sv for design source files or test_< top_module >.sv
2. messages authored by us from the build system start with " INFO:"
3. clock is always "clk"
4. all signals are active high unless their name ends in _n
5. all signals are synchronous unless their name ends in _a
6. all signals are free of random bounces unless their name ends in _b
7. in module instantiation, we always specify inputs before outputs in chunks with clear empty line sepration

## debug help:
1. this project uses GNU make, to debug errors one may in the appropriate place add echo $? to output the exit status of the last program run
2. some zig files are used in the build system of this project, it may be helpful to know that in the event of an error handles with the "try" keyword
   a stack trace is dumped into stderr.
3. Inferred latches can be more easily caught by setting set_msg_config -id {Synth 8-87} -new_severity {ERROR} in Tcl Console
4. The local directory to Vivado's batch file is located at C:/Xilinx/Vivado/2022.2/bin/vivado.bat

## externel documentation:
1. Urbana Board Documentation (XC7S50CSGA324-1): https://www.realdigital.org/doc/496fed57c6b275735fe24c85de5718c2

## final project research material:
1. working fpga 3d renderer: https://community.element14.com/challenges-projects/element14-presents/project-videos/w/documents/27700/3d-object-rendering-using-an-fpga----episode-558?CMP=SOM-YOUTUBE-PRG-E14PRESENTS-e14Presents-558
2. kinda useless tangent: https://www.youtube.com/watch?v=VzGw7CiEiJY
3. common bg cc cs vid: https://www.youtube.com/watch?v=TEAtmCYYKZA
4. how to draw a sphere: https://www.youtube.com/watch?v=zuOjwGa1Ozo
