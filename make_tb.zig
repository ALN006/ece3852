// usage : zig run make_tb.zig -- <TOP_MODULE> <SRC_DIR> <SIM_SRC_DIR>
const max_args = 4; // including the zig executable name
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator(); //arena allocator
    const args = try init.minimal.args.toSlice(arena); // Accessing command line arguments
    if (args.len > max_args) std.debug.print("\n INFO: max arguments of make_tb is {d}, but {d} arguments were provided\n\n", .{max_args, args.len});

    try make_tb(args[1..], init.io, init.gpa);
}


pub fn make_tb(args: []const [:0]const u8, io: std.Io, allocator: std.mem.Allocator) !void {
    const top = args[0];
    const src_dir = args[1];
    const sim_src_dir = args[2];

    const src_name = try std.mem.Allocator.print(allocator, "{s}/{s}.sv", .{src_dir, top}); 
    defer allocator.free(src_name); 
    const src_file = try std.Io.Dir.cwd().openFile(io, src_name, .{ .mode = .read_only});
    defer src_file.close(io);

    const src_content = try allocator.alloc(u8, @intCast(try src_file.length(io)));
    defer allocator.free(src_content);
    _ = try src_file.readPositionalAll(io, src_content, 0);

    const content = try tb_content(src_content, src_dir, top, allocator);
    defer allocator.free(content);

    const tb_name = try std.mem.Allocator.print(allocator, "{s}/test_{s}.sv", .{sim_src_dir, top}); 
    defer allocator.free(tb_name); 
    const tb_file = try std.Io.Dir.cwd().createFile(io, tb_name, .{});
    defer tb_file.close(io);

    try tb_file.writeStreamingAll(io, content);
} 

pub fn tb_content(src_content: []const u8, src_dir: []const u8,  top: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const module_start = std.mem.indexOf(u8, src_content, "module") orelse return error.Unparsable;
    const abs_search_offset = module_start + 6;
    
    const ports_start_rel = std.mem.indexOf(u8, src_content[abs_search_offset..], "(") orelse return error.Unparsable;
    const ports_start = abs_search_offset + ports_start_rel;

    const ports_end_rel = std.mem.indexOf(u8, src_content[ports_start + 1 ..], ");") orelse return error.Unparsable;
    const ports_end = ports_start + 1 + ports_end_rel;

    const raw_ports = src_content[ports_start + 1 .. ports_end];

    var ports = std.mem.tokenizeAny(u8, raw_ports, std.ascii.whitespace ++ ",");
    
    var port_vars: std.ArrayList(u8) = .empty;
    defer port_vars.deinit(allocator);
    while(ports.next()) |word| {
        if (!std.mem.eql(u8, word, "input") and !std.mem.eql(u8, word, "output") and !std.mem.eql(u8, word, "inout")) {
            if (std.mem.eql(u8, word, "logic") or std.mem.eql(u8, word, "//")) {
                try port_vars.appendSlice(allocator, ";\n\t");
            } else {
                try port_vars.appendSlice(allocator, " ");
            }
            try port_vars.appendSlice(allocator, word);
        }
    }

    const content = try std.fmt.allocPrint(
        allocator,
        \\/* verilator lint_off UNUSEDSIGNAL */
        \\`include "{s}/{s}.sv"
        \\`define check(signal, value) \
        \\    assert ((signal) == (value)) else \
        \\        $error("%s Fail -> Expected: %h, Found: %h", `"signal`", (value), (signal));
        \\
        \\timeunit 10ns;
        \\timeprecision 10ns;
        \\
        \\module test_{s};
        \\// :) {s};
        \\
        \\    initial begin // clock init
        \\        clk = 1;
        \\    end
        \\
        \\    always begin 
        \\        #1 clk = ~clk; // a clock cycle is 2 time units
        \\    end
        \\
        \\    {s} dut(.*);
        \\
        \\    initial begin
        \\        $dumpfile("test_{s}.vcd");
        \\        $dumpvars(0, test_{s});
        \\
        \\        @(posedge clk);
        \\            // Testbench logic
        \\
        \\        $display("done simulating {s}");
        \\        $finish();
        \\    end
        \\
        \\endmodule
        \\
    ,
        .{ src_dir, top, top, port_vars.items, top, top, top, top},
    );

    return content;
}
