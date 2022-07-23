const std = @import("std");
const print = std.debug.print;

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

pub fn main() !void {
    //   const stdin = std.io.getStdIn();
    // unit of data type
    const Unit = struct { key: [50]u8, value: [1000]u8 };

    const allocator = std.heap.page_allocator;
    // database container
    const database = std.ArrayList(Unit).init(allocator);
    const data = Unit{
        .key = "lecture",
        .value = "learning zig",
    };

    try database.append(data);
    // explanations
    print("\n \n \n", .{});
}
