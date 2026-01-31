const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    // 1. Setup Window
    const screenWidth = 800;
    const screenHeight = 450;
    rl.initWindow(screenWidth, screenHeight, "Zig Visualizer - Stage 1");
    defer rl.closeWindow(); // Close window when main() finishes

    rl.setTargetFPS(60); // Lock to 60 FPS

    // 2. The Game Loop
    while (!rl.windowShouldClose()) {
        // Update
        const time = rl.getTime();
        // Simple math to make the circle pulse (sine wave)
        const radius = 50.0 + (std.math.sin(time * 5.0) * 20.0);

        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawCircle(screenWidth / 2, screenHeight / 2, @floatCast(radius), rl.Color.ray_white);
        rl.drawText("It works!", 350, 200, 20, rl.Color.light_gray);
    }
}
