function draw_player(ctx, frame, camera)
    if ctx.should_reset then
        ctx.position.x = ctx.last_check.x
        ctx.position.y = ctx.last_check.y
        ctx.dead = false
        ctx.should_reset = false
        ctx.roll_direction = 0
        camera.set_target(ctx.player_api)
        ctx.state = kPlayerStates.idle
        ctx.reset_frames = 42
    end

    local x, y = math.floor(ctx.position.x + 0.5), math.floor(ctx.position.y + 0.5)
    
    if ctx.points ~= ctx.total_points then
        ui.spr(ctx.tileset, x, y, ctx.looking_back, false)
    end 
    
    -- Check if player is below screen (death condition)
    local camx, camy = camera.getxy()
    if y - camy > 270 then ctx.should_reset = true end
end

function overlay_before_player(ctx, frame, camera)
end

function overlay_frame_player(ctx, frame, camera)
    local delta = nil
    local camx, camy = camera.getxy()
    local y = math.floor(ctx.position.y + 0.5)
    local x = math.floor(ctx.position.x + 0.5) + 8
    local fx, fy = x - camx, math.min(270, y - camy)

    if ctx.points == ctx.total_points then
        if ctx.win_frame == 0 then ctx.win_frame = frame end

        ctx.win = math.max(20, math.min(480, ctx.win + (480 - ctx.win) / 40))
        ui.fillp(
            0b10101010,
            0b01010101,
            0b10101010,
            0b01010101,
            0b10101010,
            0b01010101,
            0b10101010,
            0b01010101
        )

        ui.circfill(fx + 10, fy + 10, math.min(80, ctx.win // 3), kColors.purple_dark)
        ui.fillp()
        ui.circfill(fx + 10, fy + 10, math.min(60, ctx.win // 6), kColors.purple_dark)

        local flipped_player = frame % 60 < 30 and true or false
        ui.spr(Sprites.player.win.f1, fx - 8, fy, flipped_player, false)

        local ff = 1 + math.floor(math.max(0, math.min(9, (ctx.win - 120) / 8)))
        ui.spr(Sprites.win["cwin" .. ff], math.max(0, fx - 38), math.max(-2, fy - 42))

    else
        if ctx.reset_frames > 0 then
            delta = math.min(ctx.reset_frames / 2, 8) // 1
            ctx.reset_frames = ctx.reset_frames - 1
        elseif fy > 270 - 32 then
            delta = (8 + math.min(8, 8 * ((fy - 240) / 30))) // 2
        elseif frame < 32 then
            delta = math.min((32 - frame) / 2, 8) // 1
        end

        if delta ~= nil then
            local dminus = 8 - delta
            local dplus  = 8 + delta
            for dx = 0, 480, 16 do
                for dy = 0, 270, 16 do
                    ui.rectfill(
                        dx + dminus, dy + dminus,
                        dx + dplus, dy + dplus,
                        kColors.purple_dark)
                end
            end
        end
    end
end
