const std = @import("std");
const comp = @import("comp");

const Vec3 = @Vector(3, f32);

const Position = struct {
    pos: Vec3 = .{ 0, 0, 0 },
};

const Velocity = struct {
    vel: Vec3 = .{ 0, 0, 0 },
};

const Acceleration = struct {
    acc: Vec3 = .{ 0, 0, 0 },
};

const Health = struct {
    hp: f32,
};

const Stamina = struct {
    stamina: f32,
};

const Mana = struct {
    mana: f32,
};

const Attack = struct {
    atk: f32,
};

const Enemy = struct {};

pub fn movement(world: *comp.World) void {
    comp.register(.{ Position, Velocity });
    world.schedule(&movement, .Update);
}

pub fn physics(world: *comp.World) void {
    comp.register(.{ Position, Velocity, Acceleration });
    world.schedule(&movement, .Update);
}

pub fn enemy(world: *comp.World) void {
    comp.register(.{ Health, Stamina, Attack });
    world.schedule(&movement, .Update);
}

pub fn wizard(world: *comp.World) void {
    comp.register(.{ Health, Stamina, Mana, Attack });
    world.schedule(&movement, .Update);
}

pub fn main() !void {
    var world = comp.World.init();

    movement(&world);
    physics(&world);
    enemy(&world);
    wizard(&world);
}
