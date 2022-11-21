const std = @import("std");
const expect = std.testing.expect;

// test "detect leak" {
// var list = std.ArrayList(u21).init(std.testing.allocator);
// defer list.deinit();
// try list.append('☔');
// try std.testing.expect(list.items.len == 1);
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

const Place = struct {
    lat: f64,
    long: f64,
};

const x = Place{
  .lat = 514,
  .long = -0.7,
};
 

test " serialization " {
var buf: [100]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buf);
var string = std.ArrayList(u8).init(fba.allocator());
try std.json.stringify(x, .{}, string.writer());
       std.debug.print("\n {s}", .{buf});
    const a =   std.json.validate(&buf);
       std.debug.print("\n {?}", .{a});

 var stream = std.json.TokenStream.init(&buf);
const parsedData = try std.json.parse(Place, &stream, .{});
  std.debug.print("\n ", .{});
  std.debug.print("\n {any}", .{parsedData});
  std.debug.print("\n ", .{});
}

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