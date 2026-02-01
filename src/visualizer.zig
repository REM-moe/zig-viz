const std = @import("std");
const raylib = @import("raylib"); // Need to import this here too!

// Use @This() to refer to "this file as a struct"
const Self = @This();

// --- State Variables ---
allocator: std.mem.Allocator,
width: i32,
height: i32,

pub fn init(allocator: std.mem.Allocator) !Self {
    const w = 800;
    const h = 450;

    raylib.initWindow(w, h, "Zig Visualizer - Split Files");
    raylib.setTargetFPS(60);

    return Self{
        .allocator = allocator,
        .width = w,
        .height = h,
    };
}

pub fn deinit(self: *Self) void {
    _ = self;
    raylib.closeWindow();
}

pub fn shouldClose(self: *Self) bool {
    _ = self;
    return raylib.windowShouldClose();
}

pub fn update(self: *Self) void {
    _ = self;
}

pub fn draw(self: *Self) void {
    _ = self;
    raylib.beginDrawing();
    defer raylib.endDrawing();

    raylib.clearBackground(raylib.Color.black);
    raylib.drawText("Stage 2: Split Files Success!", 250, 200, 20, raylib.Color.white);
}
