const std = @import("std");
const print = std.debug.print;
const fields = std.meta.fields;
const ZigLogger = @import("logger.zig/src/main.zig");
const Logger = ZigLogger.Logger;
const log = ZigLogger.log;

fn toJson(comptime x: Todo, fba: std.mem.Allocator) ![]const u8 {
    // serialisation
    const a = try std.json.stringifyAlloc(fba, x, .{});
    return a;
}
fn fromJson( x: []const u8,fba: std.mem.Allocator) !Todo {
    // desirialisation
    var stream = std.json.TokenStream.init(x);
    const parsedData = try std.json.parse(Todo, &stream, .{.allocator= fba});
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
    //  defer gpa.deinit();
    defer std.debug.assert(!gpa.deinit());
    const fba = gpa.allocator();
    const str = try toJson(todo, fba);
    defer fba.free(str);
    print("\n ", .{});
    print("\n {s}", .{str});
    print("\n ", .{});
    print("\n ", .{});

  const struc =  try fromJson(str, fba);
    print("\n ", .{});
    print("\n {any}", .{struc});
    print("\n ", .{});
    print("\n ", .{});
}
