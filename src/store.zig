const std = @import("std");
const printOut = std.debug.print;
const fields = std.meta.fields;
const ZigLogger = @import("logger.zig/src/main.zig");
const Logger = ZigLogger.Logger;
const log = ZigLogger.log;

const Todo = struct {
    id: ?u64 = null,
    title: ?[]const u8 = null,
    name: ?[]const u8 = null,
    age: ?u64 = null,
    isAdult: ?bool = null,
};
// const JsonDBPropsType = struct { log: ?bool = false, name: []const u8, lastID: ?u64 = 0 };
const setup = struct {
    name: []const u8,
    log: bool,
};
fn JsonDB(comptime DBUnit: type) type {
    // TODO
    return struct {
        allocator: std.mem.Allocator,
        name: ?[]const u8 = null,
        log: ?bool = null,
        lastID: ?u64 = null,
        map: std.AutoArrayHashMap(u64, DBUnit),
        const Self = @This();
        fn init(allocator: std.mem.Allocator, JsonDBProps: setup) !*Self {
            var todos = try allocator.create(Self);
            todos.* = .{
                .lastID = 0,
                .name = JsonDBProps.name,
                .log = JsonDBProps.log,
                .allocator = allocator,
                .map = std.AutoArrayHashMap(u64, DBUnit).init(allocator),
            };
            return todos;
        }
        fn deinit(self: *Self) void {
            self.map.deinit();
            self.allocator.destroy(self);
        }
        fn get(self: *Self, k: ?u64) ?DBUnit {
            if (k) |key| {
                return self.map.get(key);
            }
            return null;
        }
        fn set(self: *Self, v: DBUnit) !void {
            var k: u64 = self.map.count() + 1;
            if (self.map.count() == 0) {
                k = 0;
            } else {
                k = k - 1;
            }
            try self.map.put(k, v);
            return self.update(.{ .id = k });
        }
        fn save(self: *Self) void {
            log(.{ .name = "wow" });
            // TODO: write a fn to save to disk
            self.print();
        }
        fn drop(self: *Self) void {
            log(.{ .name = "wow" });
            // TODO: write a fn to save to disk
            self.print();
        }
        fn update(self: *Self, v: DBUnit) !void {
            const id = v.id orelse return;
            var item = self.map.get(id) orelse return;
            const e1f = comptime fields(DBUnit);
            inline for (e1f) |er| {
                if (@field(v, er.name)) |val| {
                    @field(item, er.name) = val;
                }
            }
            if (self.log) |lo| {
                printOut("\n ", .{});
                if (lo) {
                    printOut(" updated as => ", .{});
                    log(item);
                }
            }
            return self.map.put(id, item);
        }
        fn print(self: *Self) void {
            var it = self.map.iterator();
            while (it.next()) |item| {
                const logr = struct {
                    id: ?u64,
                    data: *DBUnit,
                    pub usingnamespace Logger(.{});
                };
                var data: logr = .{
                    .id = item.value_ptr.id,
                    .data = item.value_ptr,
                };
                printOut("\n", .{});
                data.log();
                // log(@TypeOf(item.value_ptr));
                // log(item.value_ptr);
                printOut("\n", .{});
            }
        }
        fn find(self: *Self, Alloc: std.mem.Allocator, v: DBUnit) ![]const DBUnit {
            var findList = std.ArrayList(Todo).init(Alloc);
            errdefer findList.deinit();
            var it = self.map.iterator();
            const e1f = comptime fields(DBUnit);
            mainLoop: while (it.next()) |item| {
                inline for (e1f) |er| {
                    const field = @field(v, er.name);
                    const A = @TypeOf(field);
                    switch (@typeInfo(A)) {
                        .Optional => {
                            const B = @field(@typeInfo(A), "Optional");
                            switch (@typeInfo(B.child)) {
                                .Pointer => {
                                    if (@field(v, er.name) != null and std.meta.eql(@field(v, er.name), @field(item.value_ptr, er.name))) {
                                        try findList.append(item.value_ptr.*);
                                        continue :mainLoop;
                                    }
                                },
                                else => {
                                    if (@field(v, er.name) != null and @field(v, er.name) == @field(item.value_ptr, er.name)) {
                                        try findList.append(item.value_ptr.*);
                                        continue :mainLoop;
                                    }
                                },
                            }
                        },
                        .Pointer => {
                            if (@field(v, er.name) != null and std.meta.eql(@field(v, er.name), @field(item.value_ptr, er.name))) {
                                try findList.append(item.value_ptr.*);
                                continue :mainLoop;
                            }
                        },
                        else => {
                            if (@field(v, er.name) != null and @field(v, er.name) == @field(item.value_ptr, er.name)) {
                                try findList.append(item.value_ptr.*);
                                continue :mainLoop;
                            }
                        },
                    }
                }
            }
            return findList.toOwnedSlice();
        }
    };
}

pub fn main() !void {
    // for DB
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const databaseParams = .{ .name = "TodoDB", .log = false };
    var store = try JsonDB(Todo).init(allocator, databaseParams);
    defer store.deinit();

    // for DB.find
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    var findListallocator = gpa.allocator();

    try store.set(.{ .title = "Fix kitchen sink", .name = "choir", .age = 1 });
    try store.set(.{ .age = 8, .name = "zig" });
    try store.set(.{
        .age = 22,
        .name = "friday",
        .isAdult = true,
    });
    try store.set(.{
        .age = 9,
        .name = "peter",
        .isAdult = false,
    });
    try store.update(.{ .id = 0, .age = 12, .name = "friday", .title = "Believe", .isAdult = true });
    store.print();
    log(store.get(0));
    const items = try store.find(findListallocator, .{ .age = 9, .name = "friday" });
    defer findListallocator.free(items);
    for (items) |item| {
        log(item);
    }
    printOut("\n \n\n", .{});
}
