StateRoll = {}

function StateRoll.update(ctx, frame)
    if ctx.velocity.y > 0.6 then
        ctx.roll_direction = 0
        if ctx.velocity.y > 2.0 then
            ctx.on_ground = false
            call_event_listeners(ctx, kPlayerEvents.falling)
        end 
        return kPlayerStates.fall
    end

    local wall_ahead = false
    if ctx.roll_direction > 0 then
        wall_ahead = ctx.map_ref.colides(ctx.position.x + ctx.size.w - 8, ctx.position.y + ctx.size.h - 1, kColisionType.right)
    else
        wall_ahead = ctx.map_ref.colides(ctx.position.x + 8, ctx.position.y + ctx.size.h - 1, kColisionType.left)
    end

    if wall_ahead then
        local center_x = ctx.position.x + ctx.size.w / 2
        local head_y = ctx.position.y + 12
        local under_ceiling = ctx.map_ref.colides(center_x, head_y, kColisionType.top)
        
        if under_ceiling then
            ctx.roll_direction = -ctx.roll_direction
            ctx.looking_back = not ctx.looking_back
        else
            ctx.roll_direction = 0
            ctx.velocity.x = 0
            return kPlayerStates.idle
        end
    end

    ctx.velocity.x = ctx.roll_direction * kPlayerRollSpeed
    return nil
end
