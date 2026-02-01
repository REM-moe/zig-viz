const std = @import("std");
const raylib = @import("raylib"); // Need to import this here too!

// Use @This() to refer to "this file as a struct"
const Self = @This();

// --- State Variables ---
allocator: std.mem.Allocator,
width: i32,
height: i32,
music: raylib.Music,

pub fn init(allocator: std.mem.Allocator) !Self {
    const w = 800;
    const h = 450;

    raylib.initWindow(w, h, "Zig Visualizer - Split Files");
    raylib.setTargetFPS(60);

    raylib.initAudioDevice();

    const music = try raylib.loadMusicStream("song.mp3");

    raylib.playMusicStream(music);

    return Self{
        .allocator = allocator,
        .width = w,
        .height = h,
        .music = music,
    };
}

pub fn deinit(self: *Self) void {
    raylib.unloadMusicStream(self.music);

    // 2. Turn off the driver
    raylib.closeAudioDevice();
    raylib.closeWindow();
}

pub fn shouldClose(self: *Self) bool {
    _ = self;
    return raylib.windowShouldClose();
}

pub fn update(self: *Self) void {
    raylib.updateMusicStream(self.music);
}

pub fn draw(self: *Self) void {
    _ = self;
    raylib.beginDrawing();
    defer raylib.endDrawing();

    raylib.clearBackground(raylib.Color.black);
    raylib.drawText("Stage 2: Split Files Success!", 250, 200, 20, raylib.Color.white);
}
