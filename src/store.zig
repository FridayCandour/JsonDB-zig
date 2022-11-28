const std = @import("std");
const print = std.debug.print;
const fields = std.meta.fields;
const log = @import("mixins.zig").log;
const Log = @import("mixins.zig").Log;

const Todo = struct {
    id: u64,
    title: ?[]const u8 = null,
    name: ?[]const u8 = null,
    age: ?u64 = null,
    isAdult: ?bool = null,
};

fn JsonDB(comptime DBUnit: type) type {
    // TODO
    return struct {
        allocator: std.mem.Allocator,
        map: std.AutoArrayHashMap(u64, DBUnit),
        const Self = @This();
        fn init(allocator: std.mem.Allocator) !*Self {
            var todos = try allocator.create(Self);
            todos.* = .{
                .allocator = allocator,
                .map = std.AutoArrayHashMap(u64, DBUnit).init(allocator),
            };
            return todos;
        }
        fn deinit(self: *Self) void {
            self.map.deinit();
            self.allocator.destroy(self);
        }
        fn get(self: *Self, k: u64) ?DBUnit {
            return self.map.get(k);
        }
        fn set(self: *Self, v: DBUnit) !void {
            const k = v.id;
            const item = self.map.get(k);
            if (item == null) {
                return self.map.put(k, v);
            }
            return;
        }
        fn save(self: *Self) !void {
            // TODO: write a fn to save to disk
            return self.map;
        }
        fn update(self: *Self, v: DBUnit) !void {
            const id = v.id;
            var item = self.map.get(id) orelse return;
            const e1f = comptime fields(DBUnit);
            std.debug.print("\n DBunit len is {any}", .{e1f.len});
            // std.debug.print("\n DBunit len is {any}", .{e1f});
            // std.debug.print("\n field is {s} ", .{er.name});
            inline for (e1f) |er| {
                if (comptime std.mem.eql(u8, er.name, "id")) {
                    continue;
                }
                std.debug.print("\n incoming values --- {s} {?any} ", .{ er.name, @field(v, er.name) });
                if (@field(v, er.name)) |val| {
                    std.debug.print("\n updating key {s} with value {any}", .{ er.name, @field(v, er.name) });
                    @field(item, er.name) = val;
                    std.debug.print("\n updated as {any}", .{@field(item, er.name)});
                }
                std.debug.print("\n ", .{});
            }
            std.debug.print("\n updated => {any}", .{item});
            std.debug.print("\n ", .{});
            return self.map.put(id, item);
        }
        fn print(self: *Self) void {
            var it = self.map.iterator();
            while (it.next()) |item| {
                const logr = struct {
                    id: u64,
                    data: *DBUnit,
                    pub usingnamespace Log(@This());
                };

                var data: logr = .{
                    .id = item.value_ptr.id,
                    .data = item.value_ptr,
                };

                std.debug.print("\n", .{});
                data.log();
                // log(@TypeOf(item.value_ptr));
                // log(item.value_ptr);
                // log(data.data);
                std.debug.print("\n", .{});
                std.debug.print("\n", .{});
            }
        }
    };
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var store = try JsonDB(Todo).init(allocator);
    defer store.deinit();
    //     try store.set( .{
    //         .id = 42,
    //         .title = "Fix kitchen sink",
    //         .name = "hello",
    //         .age = 12
    //     });

    //    try store.set(.{
    //         .id = 13,
    //         .isAdult = true
    //     });

    // store.print();
    try store.set(.{
        .id = 13,
        .age = 22,
        .name = "friday",
        .isAdult = true,
    });
    // try store.update(.{ .id = 13, .age = 12 });
    // store.print();
    // try store.update(.{ .id = 13, .age = 12, .name = "hello", .title = "Be 3p1c h4x0r", .isAdult = true });
    store.print();
}
