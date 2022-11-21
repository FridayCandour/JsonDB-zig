
fn jsonizer(comptime type) {
    var buf: [100]u8 = undefined; // TODO: it could be more than 100 bytes
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    var string = std.ArrayList(u8).init(fba.allocator());
    try std.json.stringify(x, .{}, string.writer());
    std.debug.print("\n {s}", .{string.items});
    const a = std.json.validate(string.items);
    std.debug.print("\n {?}", .{a});
    var stream = std.json.TokenStream.init(string.items);
    const parsedData = try std.json.parse(Place, &stream, .{});
    std.debug.print("\n ", .{});
    std.debug.print("\n {any}", .{parsedData});
    std.debug.print("\n ", .{});

}