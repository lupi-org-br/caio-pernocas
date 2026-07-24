require "sprites"

function lerp(start, ending, amount)
    return (1 - amount) * start + amount * ending
end

function ping_pong(current_frame, max_value)
    local cycle_length = 2 * (max_value - 1)
    local position_in_cycle = current_frame % cycle_length

    if position_in_cycle < max_value then
        return position_in_cycle + 1
    else
        return 2 * max_value - position_in_cycle - 1
    end
end

kGravity = 0.3
kMaxGravity = 4
kJumpForce = 5.2
kPlayerSpeed = 2
kPlayerRollSpeed = 4

kState = {
    idle = 0,
    press = 1,
    pressed = 2
}

kPlayerStates = {
    climb = { asset = 'climb', frames = 3, cadency = 12 },
    crouch = { asset = 'crouch', frames = 2, cadency = 12 },
    hurt = { asset = 'hurt', frames = 2, cadency = 12 },
    idle = { asset = 'idle', frames = 4, cadency = 8 },
    jump = { asset = 'jump', frames = 1, cadency = 12 },
    fall = { asset = 'fall', frames = 1, cadency = 12 },
    run = { asset = 'run', frames = 5, cadency = 4 },
    dead = { asset = 'hurt', frames = 2, cadency = 6 },
    roll = { asset = 'roll', frames = 4, cadency = 4 },
    edge = { asset = 'edge', frames = 4, cadency = 8 },
}

kMapID = {
    tile = 1,
    colision = 2,
    poi = 3,
    overlay = 4,
}

kColisionType = {
    top = 1,
    bottom = 2,
    left = 3,
    right = 4,
    enemies = 5
}

kColisionTile = {
    [8] = { kColisionType.enemies },
    [9] = { kColisionType.top, kColisionType.bottom, kColisionType.left, kColisionType.right },
    [10] = { kColisionType.top, kColisionType.left, kColisionType.right },
    [11] = { kColisionType.bottom }
}

kPoiType = {
    cherry = 2,
    spike = 1,
    spring = 3,
    beetle = 4,
    palm = 18,
    pine = 16,
    bird = 6,
    house = 20,
    bigtree = 22,
    rock = 32,
    pad_a = 34,
    pad_b = 35,
    pad_c = 36,
    pad_d = 37,
    penpen = 38,
    snowy_pine = 48,
    branch_left = 42,
    branch_right = 43,
}

kPoiOrigin = {
    [kPoiType.palm]  = {-2, -6},
    [kPoiType.pine]  = {-2, -6},
    [kPoiType.snowy_pine]  = {-2, -6},
    [kPoiType.house] = {-3, -4},
    [kPoiType.bigtree] = {-3, -4},
    [kPoiType.rock] = {-1, -1},
}

kColors = {
    black = Palette.hex(0x000000),
    purple_light = Palette.hex(0x9C63A5),
    purple_dark = Palette.hex(0x392142),
    green_dark = Palette.hex(0x083918),
    green_light = Palette.hex(0x528410),
    green_bg = Palette.hex(0x185A21),
    gray_light = Palette.hex(0xCED6DE),
    red_light = Palette.hex(0xAD2121),
    blue_light = Palette.hex(0x29BDFF),
    yellow = Palette.hex(0xE7CE9C),
    sunrise = Palette.hex(0xFF7B73),
}

kPlayerEvents = {
    falling = 1,
    jumped = 2,
}

kStages = {

    {
        map_location = { x = 42, y = 42 },
        player_start = { x = 7, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.snowy_top,
        bg_down      = Sprites.tilemap.snowy_bot,
        cherries     = 2,
        bg_tint      = kColors.sunrise,
        display_name = "X 2-1",
        map_name     = "maps.stages.w2s1"
    },{
        map_location = { x = 41, y = 44 },
        player_start = { x = 7, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.snowy_b_top,
        bg_down      = Sprites.tilemap.snowy_b_bot,
        cherries     = 2,
        bg_tint      = Palette.hex(0x52294a),
        display_name = "X 2-2",
        map_name     = "maps.stages.w2s2"
    },
    {
        map_location = { x = 31, y = 36 },
        player_start = { x = 7, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.clouds,
        bg_down      = Sprites.tilemap.ocean,
        cherries     = 2,
        bg_tint      = kColors.blue_light,
        display_name = "X 1-1",
        map_name     = "maps.stages.w1s1"
    },
    {
        map_location = { x = 35, y = 36 },
        player_start = { x = 7, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.clouds,
        bg_down      = Sprites.tilemap.ocean,
        cherries     = 2,
        bg_tint      = kColors.blue_light,
        display_name = "X 1-2",
        map_name     = "maps.stages.w1s2"
    },
    {
        map_location = { x = 35, y = 39 },
        player_start = { x = 9, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.clouds,
        bg_down      = Sprites.tilemap.ocean,
        cherries     = 2,
        bg_tint      = kColors.blue_light,
        display_name = "X 1-3",
        map_name     = "maps.stages.w1s3"
    },
    {
        map_location = { x = 38, y = 36 },
        player_start = { x = 7, y = 14 },
        looking_back = false,
        bg_up        = Sprites.tilemap.clouds,
        bg_down      = Sprites.tilemap.ocean,
        cherries     = 2,
        bg_tint      = kColors.blue_light,
        display_name = "X 1-4",
        map_name     = "maps.stages.w1s4"
    },
    {
        map_location = { x = 40, y = 36 },
        player_start = { x = 7, y = 11 },
        looking_back = false,
        bg_up        = Sprites.tilemap.clouds,
        bg_down      = Sprites.tilemap.ocean,
        cherries     = 2,
        bg_tint      = kColors.blue_light,
        display_name = "X 1-5",
        map_name     = "maps.stages.w1s5"
    }
    
    
    
    -- {
    --     map_location = { x = 33, y = 30 },
    --     player_start = { x = 3, y = 4 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.leaves,
    --     bg_down      = Sprites.tilemap.forest,
    --     cherries     = 1,
    --     bg_tint      = kColors.green_bg,
    --     display_name = "X 1-4",
    --     map_name     = "new_w1s4"
    -- },{
    --     map_location = { x = 48, y = 31 },
    --     player_start = { x = 3, y = 6 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.deep,
    --     bg_down      = Sprites.tilemap.rocks,
    --     cherries     = 2,
    --     bg_tint      = 58,
    --     display_name = "X 1-5",
    --     map_name     = "new_w1s5"
    -- },{
    --     map_location = { x = 52, y = 26 },
    --     player_start = { x = 3, y = 6 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.deep,
    --     bg_down      = Sprites.tilemap.rocks,
    --     cherries     = 1,
    --     bg_tint      = 58,
    --     display_name = "X 1-6",
    --     map_name     = "new_w1s6"
    -- },{
    --     map_location = { x = 51, y = 22 },
    --     player_start = { x = 2, y = 5 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.deep,
    --     bg_down      = Sprites.tilemap.rocks,
    --     cherries     = 1,
    --     bg_tint      = 58,
    --     display_name = "X 1-7",
    --     map_name     = "new_w1s7"
    -- },{
    --     map_location = { x = 55, y = 24 },
    --     player_start = { x = 4, y = 45 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.clouds,
    --     bg_down      = Sprites.tilemap.ocean,
    --     cherries     = 5,
    --     bg_tint      = kColors.blue_light,
    --     display_name = "X 1-8",
    --     map_name     = "new_w1s8"
    -- },{
    --     map_location = { x = 44, y = 23 },
    --     player_start = { x = 5, y = 14 },
    --     looking_back = false,
    --     bg_up        = Sprites.tilemap.clouds,
    --     bg_down      = Sprites.tilemap.ocean,
    --     cherries     = 5,
    --     bg_tint      = kColors.blue_light,
    --     display_name = "X 1-9",
    --     map_name     = "new_w1s9"
    -- }
}

CurrentStage = kStages[2]
