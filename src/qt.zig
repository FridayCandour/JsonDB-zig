const std = @import("std");
const expect = std.testing.expect;
const print = @import("std").debug.print;
const mem = @import("std").mem;

pub fn main() void {
  const isSlice = fn (comptime varType) void {
    varType.id == .Slice
    };
     const a = 12;
     const b = "hello";
     const c = "";
     print("{any}\n", .{@TypeOf(b)});
     print("{any}\n", .{@TypeOf(a)});
     print("{any}\n", .{@TypeOf(b) == *const [b.len:0]u8});
        if(mem.eql(u8,b, c)) {
      std.debug.print("\n {s} \n \n", .{"we are done! Lmao"}); 
        }
}
