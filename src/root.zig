const std = @import("std");

pub const EntityID = u32;

pub const Stage = enum {
    Start,
    Update,
    End,
};

/// the types sent into register come out with file prefixes: main.Position, main.Velocity
/// this function removes those prefixes to have clearer names
fn stripPrefix(comptime name: [:0]const u8) []const u8 {
    _, const after =
        std.mem.cutScalarLast(u8, name, '.') orelse return name;

    return after;
}

/// at comptime registers the components as a new archetype
/// at runtime returns the data stored in that archetype
/// components is a tuple of struct types
pub fn register(comptime components: anytype) void {
    comptime {
        const Components = @TypeOf(components);
        const names = @typeInfo(Components).@"struct".field_names;

        var field_names: [names.len][]const u8 = undefined;
        var field_types: [names.len]type = undefined;
        var field_attrs: [names.len]std.builtin.Type.Struct.FieldAttributes = undefined;

        // NOTE: test for two colliding component names like a.Health, b.Health
        for (names, 0..) |name, i| {
            const ComponentType: type = @field(components, name);

            field_names[i] = stripPrefix(@typeName(ComponentType));
            field_types[i] = ComponentType;
            field_attrs[i] = std.builtin.Type.Struct.FieldAttributes{};
        }

        const Template = @Struct(.auto, null, &field_names, &field_types, &field_attrs);

        @compileLog(@typeInfo(Template).@"struct".field_names);
    }
}

pub const World = struct {
    pub fn init() @This() {
        return .{};
    }

    pub fn schedule(self: *@This(), comptime func: *const fn (*@This()) void, stage: Stage) void {
        _ = self;
        _ = func;
        _ = stage;
    }
};
