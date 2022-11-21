const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;
const log = @import("mixins.zig").log;
fn Store(comptime K: type, comptime V: type) type {
    return struct {
        ptr: *anyopaque,
        getFn: GetProto,
        setFn: SetProto,
        const GetProto = *const fn (*anyopaque, K) ?V;
        const SetProto = *const fn (*anyopaque, K, V) anyerror!void;
        const Self = @This();
        fn get(self: Self, k: K) ?V {
            return self.getFn(self.ptr, k);
        }
        fn set(self: Self, k: K, v: V) !void {
            return self.setFn(self.ptr, k, v);
        }
    };
}

const Todo = struct {
    id: u64,
    title: ?[]const u8 = null,
    name: ?[]const u8 = null,
    age: ?u64 = null,
    isAdult: ?bool = null,
    // pub usingnamespace Log("Todo", @This());
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
        if(item == null) {
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
        const item =  self.map.get(id);
        if(item != null) {
        return self.map.put(id, v);
        }
    }
     fn print(self: *Self) void {
        var it = self.map.iterator();
        while (it.next()) |item| {
        const logr = struct {
            id:u64,
            data: *DBUnit,
        };
     const data: logr = .{.id = item.value_ptr.id, .data = item.value_ptr, };
       std.debug.print("\n", .{});
            log(@TypeOf(item.value_ptr));
            // log(item.value_ptr);
            log(data.data);
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
    try store.set( .{
        .id = 42,
        .title = "Fix kitchen sink",
        .name = "hello",
        .age = 12
    });

    try store.set(.{
        .id = 13,
        .age = 12,
        .name = "hello",
        .title = "Be 3p1c h4x0r",
    });

   try store.set(.{
        .id = 42,
        .isAdult = true
    });

 try store.update(.{
        .id = 13,
        .age = 12,
        .name = "hello",
        .title = "Be 3p1c h4x0r",
        .isAdult = true
    });
  store.print();
}