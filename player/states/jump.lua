StateJump = {}

function StateJump.update(ctx, frame)
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

    if ctx.velocity.y > 0.6 then
        if ctx.velocity.y > 2.0 then
            ctx.on_ground = false
            call_event_listeners(ctx, kPlayerEvents.falling)
        end 
        return kPlayerStates.fall
    end

    return nil
end
