const std = @import("std");
const print = std.debug.print;
const fields = std.meta.fields;
const ZigLogger = @import("logger.zig/src/main.zig");
const Logger = ZigLogger.Logger;
const log = ZigLogger.log;

fn toJson(comptime x: Todo, alloc: std.mem.Allocator) ![]const u8 {
    // serialisation
    const a = try std.json.stringifyAlloc(alloc, x, .{});
    return a;
}
fn fromJson( x: []const u8,alloc: std.mem.Allocator) !Todo {
    // desirialisation
    var stream = std.json.TokenStream.init(x);
    const parsedData = try std.json.parse(Todo, &stream, .{.allocator= alloc});
    return parsedData;
}

const Todo = struct {
    id: u64,
    name: []const u8,
    isOld: bool,
};

const todo = Todo{
    .id = 1,
    .name = "friday",
    .isOld = false,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const alloc = gpa.allocator();
    const str = try toJson(todo, alloc);
    defer alloc.free(str);
    print("\n ", .{});
    print("\n {s}", .{str});
    print("\n ", .{});
    print("\n ", .{});

  const struc =  try fromJson(str, alloc);
    defer std.json.parseFree(Todo, struc, .{.allocator= alloc});
    print("\n ", .{});
    print("\n {any}", .{struc});
    log(struc);
    print("\n ", .{});
    print("\n ", .{});
}
