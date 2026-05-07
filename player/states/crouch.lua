StateCrouch = {}

function StateCrouch.update(ctx, frame)
    ctx.velocity.x = 0
    
    if not ui.btn(DOWN, pad_1) then
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
