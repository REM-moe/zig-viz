const std = @import("std");

// we import our viz struct from visualizer.zig
const Visualizer = @import("visualizer.zig");

pub fn main() !void {
    // 1. Memory
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // 2. Init (Using the imported file-struct)
    var app = try Visualizer.init(allocator);
    defer app.deinit();

    // 3. Loop
    while (!app.shouldClose()) {
        app.update();
        app.draw();
    }
}
