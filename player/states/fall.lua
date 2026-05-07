StateFall = {}

function StateFall.update(ctx, frame)
    ctx.roll_direction = 0

    if ui.btn(LEFT, pad_1) then
        ctx.velocity.x = -kPlayerSpeed
        ctx.looking_back = true
    elseif ui.btn(RIGHT, pad_1) then
        ctx.velocity.x = kPlayerSpeed
        ctx.looking_back = false
    else
        ctx.velocity.x = 0
    end

    if ctx.velocity.y <= 0.6 and ctx.velocity.y >= -0.6 then
        if ctx.velocity.x == 0 then
            return kPlayerStates.idle
        else
            return kPlayerStates.run
        end
    end

    return nil
end
