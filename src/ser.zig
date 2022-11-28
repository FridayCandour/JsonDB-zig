const std = @import("std");
const print = std.debug.print;
const fields = std.meta.fields;
const ZigLogger = @import("logger.zig/src/main.zig");
const Logger = ZigLogger.Logger;
const log = ZigLogger.log;

fn toJson(comptime x: Todo) ![]const u8 {
    // serialisation
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var fba = allocator;
    const a = try std.json.stringifyAlloc(fba, x, .{});
    // std.debug.print("\n {s}", .{a});
    // std.debug.print("\n ", .{});
    // std.debug.print("\n ", .{});
    return a;
}

fn fromJson(comptime x: type, comptime typ: type) !void {
    // serialisation
    // var fba = std.testing.allocator;
    // const a = try std.json.stringifyAlloc(fba,x, .{});
    // std.debug.print("\n {any}", .{a});

    // desirialisation
    var stream = std.json.TokenStream.init(x);
    const parsedData = try std.json.parse(typ, &stream, .{});
    std.debug.print("\n ", .{});
    std.debug.print("\n {any}", .{parsedData});
    std.debug.print("\n ", .{});

    // // freeing allocated memory
    // defer std.testing.allocator.free(a);
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
    const str = try toJson(todo);
    print("\n ", .{});
    print("\n {s}", .{str});
    print("\n ", .{});
    print("\n ", .{});
}
