const std = @import("std");

// my problems with zig
// recursion doesn't seem to work
// meaning a fn can't call it's self
//  .... still hoping not to find more

// why i like zig
// not hell to understand
// no hidden memory allocation
// no hidden control flow as i know
// most of what is going on
// zig makes logic easily composable
// no boiler plating
// reasonably fast compiler

// my realisations with zig
// zig tells the mistake you made
// if you look properly at the error delux :p
// zig is absolutely fantastic (:

// unit of data type
// NOTE(Thomas): Types can be moved outside main() for easier reading
const Unit = struct {
    key: []const u8,
    value: []const u8,

    // NOTE(Thomas): Added print function for nicely printing units
    fn print(self: @This()) void {
        std.debug.print("\t{s}: {s}\n", .{ self.key, self.value });
    }
};

pub fn main() !void {

    // NOTE(Thomas): Switched to General Purpose Allocator
    // (more efficient, can detect memory leaks)
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // NOTE(Thomas): Use assert to detect leaks on end of main()
    defer std.debug.assert(!gpa.deinit());
    var allocator = gpa.allocator();

    // database container
    var database = std.ArrayList(Unit).init(allocator);
    // NOTE(Thomas): Free database memory on end of main()
    defer database.deinit();

    const data = Unit{
        .key = "lecture",
        .value = "learning zig",
    };

    try database.append(data);
    // NOTE(Thomas): Print each unit in the database
    std.debug.print("Database:\n", .{});
    for (database.items) |unit| unit.print();
}
