StateRun = {}

function StateRun.update(ctx, frame)
    if ui.btn(DOWN, pad_1) then
        ctx.roll_direction = ctx.looking_back and -1 or 1
        ctx.velocity.x = ctx.roll_direction * kPlayerSpeed
        return kPlayerStates.roll
    elseif ctx.on_ground and action_button_is(kState.pressed) then
        ctx.velocity.y = -kJumpForce
        ctx.on_ground = false
        call_event_listeners(ctx, kPlayerEvents.jumped)
        return kPlayerStates.jump
    elseif ui.btn(LEFT, pad_1) then
        ctx.velocity.x = -kPlayerSpeed
        ctx.looking_back = true
    elseif ui.btn(RIGHT, pad_1) then
        ctx.velocity.x = kPlayerSpeed
        ctx.looking_back = false
    else
        ctx.velocity.x = 0
        return kPlayerStates.idle
    end

    if ctx.velocity.y > 0.6 then
        if ctx.velocity.y > 2.0 then
            ctx.on_ground = false
            call_event_listeners(ctx, kPlayerEvents.falling)
        end 
        return kPlayerStates.fall
    elseif ctx.velocity.y < -0.6 then
        return kPlayerStates.jump
    end

    return nil
end
