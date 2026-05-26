StateIdle = {}

function StateIdle.update(ctx, frame)
    ctx.velocity.x = 0
    
    if ui.btn(DOWN, pad_1) then
        return kPlayerStates.crouch
    elseif ctx.on_ground and action_button_is(kState.pressed) then
        ctx.velocity.y = -kJumpForce
        ctx.on_ground = false
        call_event_listeners(ctx, kPlayerEvents.jumped)
        return kPlayerStates.jump
    elseif ui.btn(LEFT, pad_1) then
        ctx.velocity.x = -kPlayerSpeed
        ctx.looking_back = true
        return kPlayerStates.run
    elseif ui.btn(RIGHT, pad_1) then
        ctx.velocity.x = kPlayerSpeed
        ctx.looking_back = false
        return kPlayerStates.run
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

    local is_edge, looking_left = check_edge_colisions(ctx)
    if is_edge then
        ctx.edge_grace = ctx.edge_grace + 1
        if ctx.edge_grace >= 6 then
            ctx.looking_back = looking_left
            return kPlayerStates.edge
        end
    else
        ctx.edge_grace = 0
    end

    return nil
end
