StateRoll = {}

function StateRoll.update(ctx, frame)
    if not ctx.on_ground then
        ctx.roll_direction = 0
        return kPlayerStates.fall
    end

    local wall_ahead = false
    if ctx.roll_direction > 0 then
        wall_ahead = ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 18, kColisionType.right)
                  or ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 1, kColisionType.right)
    else
        wall_ahead = ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 18, kColisionType.left)
                  or ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 1, kColisionType.left)
    end

    if wall_ahead then
        ctx.roll_direction = 0
        ctx.velocity.x = 0
        return kPlayerStates.idle
    end

    ctx.velocity.x = ctx.roll_direction * kPlayerSpeed
    return nil
end
