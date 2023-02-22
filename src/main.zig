const std = @import("std");
const print = std.debug.print;

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
    try database.append(data);
    try database.append(data);

    // fn printdb() void {
        // NOTE(Thomas): Print each unit in the database
    print("Database entries :\n", .{});
    for (database.items) |unit| unit.print();
    print("hello", .{});
// }
}
