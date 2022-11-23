const std = @import("std");
const expect = std.testing.expect;

// test "detect leak" {
// var list = std.ArrayList(u21).init(std.allocator);
// defer list.deinit();
// try list.append('☔');
// try std.expect(list.items.len == 1);
//  }

//  test "coerce to optionals" {
// const foo = struct {
//     x: ?u64 = 1234,
//     y: ?u64,
// };
// try expect(foo.x == 1234);
// try expect(foo.y == null);
// }

// const Vec4 = struct {
//     x: f32, y: f32, z: f32 = 0, w: f32 = undefined
// };

// test "struct defaults" {
//     const my_vector = Vec4{
//         .x = 25,
//         .y = -50,
//     };
//     _ = my_vector;
// }

// const Place = struct {
//     lat: u64,
//     long: u64,
// };

// const x = Place{
//     .lat = 514,
//     .long = 7,
// };

// test " serialization " {
    
//     // serialisation
//     var fba = std.allocator;
//     const a = try std.json.stringifyAlloc(fba,x, .{});
//     std.debug.print("\n {any}", .{a});

//     // desirialisation
//     var stream = std.json.TokenStream.init(a);
//     const parsedData = try std.json.parse(Place, &stream, .{});
//     std.debug.print("\n ", .{});
//     std.debug.print("\n {any}", .{parsedData});
//     std.debug.print("\n ", .{});

//     // freeing allocated memory 
//     defer std.allocator.free(a);
// }

// test " deserialization " {
// const Foo = struct { a: i32, b: bool };
// const s =
//     \\ {
//     \\   "a": 15, "b": true
//     \\ }
// ;
// var stream = std.json.TokenStream.init(s);
// const parsedData = try std.json.parse(Foo, &stream, .{});
//   std.debug.print("\n ", .{});
//   std.debug.print("\n {any}", .{parsedData});
//   std.debug.print("\n ", .{});
// }

    // var buf: [100]u8 = undefined;
    // var string = std.ArrayList(u8).init(fba.allocator());
    // , string.writer()
    // const b = std.json.validate(a);
    // std.debug.print("\n {any}", .{b});
const mem = std.mem;
 const Type = std.builtin.Type;

    pub fn fields(comptime T: type) switch (@typeInfo(T)) {
    .Struct => []const Type.StructField,
    .Union => []const Type.UnionField,
    .ErrorSet => []const Type.Error,
    .Enum => []const Type.EnumField,
    else => @compileError("Expected struct, union, error set or enum type, found '" ++ @typeName(T) ++ "'"),
} {
    return switch (@typeInfo(T)) {
        .Struct => |info| info.fields,
        .Union => |info| info.fields,
        .Enum => |info| info.fields,
        .ErrorSet => |errors| errors.?, // must be non global error set
        else => @compileError("Expected struct, union, error set or enum type, found '" ++ @typeName(T) ++ "'"),
    };
}

test "std.meta.fields" {
    const E1 = struct {
        A: u64,
        B: u64,
    };
    const e1 = E1{
        .A = 1,
        .B = 2,
    };
    const e1f = comptime fields(E1);
    std.debug.print("\n", .{});
    inline for (e1f) |er| {
    std.debug.print("\n key is {s} and value is {}", .{er.name,@field(e1, er.name)});
    } 
    std.debug.print("\n", .{});
    }
