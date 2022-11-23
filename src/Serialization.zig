
const jax = struct {
fn toJson(comptime type) {
    // serialisation
    var fba = std.testing.allocator;
    const a = try std.json.stringifyAlloc(fba,x, .{});
    std.debug.print("\n {any}", .{a});
    // freeing allocated memory 
    defer std.testing.allocator.free(a);
}

fn fromJson(comptime type) {
    // serialisation
    var fba = std.testing.allocator;
    const a = try std.json.stringifyAlloc(fba,x, .{});
    std.debug.print("\n {any}", .{a});

    // desirialisation
    var stream = std.json.TokenStream.init(a);
    const parsedData = try std.json.parse(Place, &stream, .{});
    std.debug.print("\n ", .{});
    std.debug.print("\n {any}", .{parsedData});
    std.debug.print("\n ", .{});

    // freeing allocated memory 
    defer std.testing.allocator.free(a);
}

}

