const std = @import("std");
const raylib = @import("raylib");

const Self = @This();

// --- 1. GLOBAL VARIABLE (The Bridge) ---
// This sits at the top of the file so both the Callback and the Struct can see it.
var current_volume: f32 = 0.0;

// --- 2. STRUCT DEFINITION ---
allocator: std.mem.Allocator,
width: i32,
height: i32,
music: raylib.Music, // Store the music object

pub fn init(allocator: std.mem.Allocator) !Self {
    const w = 800;
    const h = 450;

    raylib.initWindow(w, h, "Zig Visualizer - Stage 3");
    raylib.setTargetFPS(60);

    // Audio Setup
    raylib.initAudioDevice();

    // LOAD YOUR SONG HERE: Make sure "song.mp3" is in the project folder!
    const music = try raylib.loadMusicStream("song.mp3");
    raylib.playMusicStream(music);

    // ATTACH THE SPY: Connect our callback function to this music stream
    raylib.attachAudioStreamProcessor(music.stream, processAudio);

    return Self{
        .allocator = allocator,
        .width = w,
        .height = h,
        .music = music,
    };
}

pub fn deinit(self: *Self) void {
    // DETACH THE SPY: Must happen before unloading!
    raylib.detachAudioStreamProcessor(self.music.stream, processAudio);

    raylib.unloadMusicStream(self.music);
    raylib.closeAudioDevice();
    raylib.closeWindow();
}

pub fn shouldClose(self: *Self) bool {
    _ = self;
    return raylib.windowShouldClose();
}

pub fn update(self: *Self) void {
    // Keep the music buffer filled
    raylib.updateMusicStream(self.music);
}

pub fn draw(self: *Self) void {
    raylib.beginDrawing();
    defer raylib.endDrawing();

    raylib.clearBackground(raylib.Color.black);

    // LOGIC: Map Volume (0.0 to 1.0) to Radius (50 to 250)
    const base_radius: f32 = 50.0;
    const max_added_radius: f32 = 200.0;
    const radius = base_radius + (current_volume * max_added_radius);

    // Draw the pulsing circle
    raylib.drawCircle(@divTrunc(self.width, 2), @divTrunc(self.height, 2), radius, raylib.Color.red);

    // Debug Text
    raylib.drawText("Playing song.mp3", 10, 10, 20, raylib.Color.white);
}

// --- 3. THE CALLBACK FUNCTION (The Spy) ---
// This sits outside the struct methods at the bottom of the file.
export fn processAudio(buffer: ?*anyopaque, frames: c_uint) callconv(.c) void {
    // Safety check
    if (buffer == null) return;

    // Cast void pointer to Float pointer
    const samples: [*]f32 = @ptrCast(@alignCast(buffer));

    var temp_max: f32 = 0.0;
    var i: usize = 0;

    // Loop through all samples (Frames * 2 because Stereo)
    while (i < frames * 2) : (i += 1) {
        const sample = @abs(samples[i]);
        if (sample > temp_max) {
            temp_max = sample;
        }
    }

    // Update the global variable
    current_volume = temp_max;
}
