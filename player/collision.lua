function check_v_colisions(ctx)
    if ctx.map_ref.colides(ctx.position.x + ctx.size.w / 2 - 4, ctx.position.y + ctx.size.h, kColisionType.bottom)
        or ctx.map_ref.colides(ctx.position.x + ctx.size.w / 2 + 4, ctx.position.y + ctx.size.h, kColisionType.bottom) then
        if ctx.velocity.y > 0 then
            ctx.position.y = (((ctx.position.y + ctx.size.h) // 16) * 16) - ctx.size.h - 0.001
            ctx.velocity.y = 0
            ctx.on_ground = true
            ctx.map_ref.on_colide_event(ctx.position.x + ctx.size.w / 2, ctx.position.y + ctx.size.h + 8, "touching")
        end
    elseif ctx.map_ref.colides(ctx.position.x + ctx.size.w / 2 - 4, ctx.position.y + 12, kColisionType.top)
        or ctx.map_ref.colides(ctx.position.x + ctx.size.w / 2 + 4, ctx.position.y + 12, kColisionType.top) then
        if ctx.velocity.y < 0 then
            ctx.position.y = (((ctx.position.y + ctx.size.h) // 16) * 16) - (ctx.size.h - 4)
            ctx.velocity.y = 0
        end
    end
end

function check_h_colisions(ctx)
    -- two sensors, in front of me, to the right
    if ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 18, kColisionType.right)
        or ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 1, kColisionType.right) then
        if ctx.velocity.x > 0 then
            ctx.position.x = ctx.position.x // 1
            ctx.velocity.x = 0
            ctx.state = kPlayerStates.idle
        end
    elseif ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 18, kColisionType.left)
        or ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 1, kColisionType.left) then
        if ctx.velocity.x < 0 then
            ctx.position.x = ctx.position.x // 1
            ctx.velocity.x = 0
            ctx.state = kPlayerStates.idle
        end
    end
end
