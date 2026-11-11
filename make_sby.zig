// usage : zig run make_sby.zig -- <TOP_MODULE> <BUILD_DIR> <SIM_SRC_DIR>
const max_args = 4; // including the zig executable name
const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator(); //arena allocator
    const args = try init.minimal.args.toSlice(arena); // Accessing command line arguments
    if (args.len > max_args) std.debug.print("\n INFO: max arguments of make_sby is {d}, but {d} arguments were provided\n\n", .{max_args, args.len});

    try make_sby(args[1..], init.io, init.gpa);
}


pub fn make_sby(args: []const [:0]const u8, io: std.Io, allocator: std.mem.Allocator) !void {
    const top = args[0];
    const build_dir = args[1];
    const sim_src_dir = args[2];

    const content = try sby_content(build_dir, top, allocator);
    defer allocator.free(content);

    const tb_name = try std.mem.Allocator.print(allocator, "{s}/{s}.sby", .{sim_src_dir, top}); 
    defer allocator.free(tb_name); 
    const tb_file = try std.Io.Dir.cwd().createFile(io, tb_name, .{});
    defer tb_file.close(io);

    try tb_file.writeStreamingAll(io, content);
} 

pub fn sby_content(build_dir: []const u8, top: []const u8, allocator: std.mem.Allocator) ![]u8 {
    
    const content = try std.fmt.allocPrint(
        allocator,
        \\[options]
        \\mode prove
        \\
        \\[engines]
        \\smtbmc
        \\
        \\[script]
        \\read -formal  {s}_flat.v
        \\prep -top {s}
        \\
        \\[files]
        \\{s}/{s}_flat.v
        \\
    ,
        .{ top, top, build_dir, top },
    );

    return content;
}