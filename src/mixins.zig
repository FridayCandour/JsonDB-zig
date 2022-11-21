const std = @import("std");
const builtin = @import("builtin");
const print = std.debug.print;

pub const Term = struct {
    pub fn start(comptime c: u8) []const u8 {
        return "\u{001b}[" ++ std.fmt.comptimePrint("{}", .{c}) ++ "m";
    }
    pub fn end() []const u8 {
        return "\u{001b}[0m";
    }
    pub fn code(comptime c: u8, comptime str: []const u8) []const u8 {
        if (builtin.os.tag == .windows) return str;
        return start(c) ++ str ++ end();
    }
    pub fn green(comptime str: []const u8) []const u8 {
        return code(32, str);
    }
    pub fn yellow(comptime str: []const u8) []const u8 {
        return code(33, str);
    }
    pub fn purple(comptime str: []const u8) []const u8 {
        return code(35, str);
    }
    pub fn cyan(comptime str: []const u8) []const u8 {
        return code(36, str);
    }
};

pub fn ext(comptime str: []const u8) []const u8 {
    if (std.mem.indexOf(u8, str, ".")) |i| {
        return str[i + 1 ..];
    }
    return str;
}

pub fn logAny(x: anytype, comptime indent: usize) void {
    const T = @TypeOf(x);
    const info = @typeInfo(T);
    switch (info) {
        .Struct => |s| {
            logName(ext(@typeName(T)));
            print("{{\n", .{});
            inline for (s.fields) |f| {
                print(("  " ** indent) ++ "." ++ Term.cyan("{s}") ++ " = ", .{f.name});
                switch (@typeInfo(f.field_type)) {
                    .Int => {
                        print(Term.purple("@as") ++ "(", .{});
                        logName(@typeName(f.field_type));
                        print(", ", .{});
                        print(Term.start(33), .{});
                        print("{}", .{@field(x, f.name)});
                        print(Term.end(), .{});
                        print(")", .{});
                    },
                    .Pointer => switch (f.field_type) {
                        []const u8 => {
                            print(Term.start(32), .{});
                            print("\"{s}\"", .{@field(x, f.name)});
                            print(Term.end(), .{});
                        },
                        else => {
                            logName(ext(@typeName(f.field_type)));
                            logAny(@field(x, f.name), indent + 1);
                        },
                    },
                    else => {
                        logAny(@field(x, f.name), indent + 1);
                    },
                }
                print(",\n", .{});
            }
            print(("  " ** (indent - 1)) ++ "}}", .{});
        },
        else => print("{any}", .{x}),
    }
}

pub fn logName(comptime name: []const u8) void {
    print(Term.green("{s}"), .{name});
}

pub fn log(x: anytype) void {
    return logAny(x, 1);
}

fn Log(comptime Self: type) type {
    return struct {
        pub fn log(self: Self) void {
            return logAny(self, 1);
        }
    };
}

const SadStruct = struct {
    some: u32,
    stuff: []const u8,
};

const Thing = struct {
    that: SadStruct,
    this: SadStruct,

    pub usingnamespace Log(@This());
};

test "mixin" {
    var x: Thing = .{
        .that = .{ .some = 4, .stuff = "ziguanas" },
        .this = .{ .some = 0, .stuff = "safety" },
    };
    print("\n", .{});
    x.log();
    print("\n", .{});
}