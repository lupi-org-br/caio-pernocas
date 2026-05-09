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
    local check_top = (ctx.state ~= kPlayerStates.roll and ctx.state ~= kPlayerStates.crouch)
    
    local right_col = ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 1, kColisionType.right)
    if check_top then
        right_col = right_col or ctx.map_ref.colides(ctx.position.x + ctx.size.w - 6, ctx.position.y + ctx.size.h - 18, kColisionType.right)
    end

    local left_col = ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 1, kColisionType.left)
    if check_top then
        left_col = left_col or ctx.map_ref.colides(ctx.position.x + 6, ctx.position.y + ctx.size.h - 18, kColisionType.left)
    end

    if right_col then
        if ctx.velocity.x > 0 then
            ctx.position.x = ctx.position.x // 1
            ctx.velocity.x = 0
            if ctx.on_ground and check_top then ctx.state = kPlayerStates.idle end
        end
    elseif left_col then
        if ctx.velocity.x < 0 then
            ctx.position.x = ctx.position.x // 1
            ctx.velocity.x = 0
            if ctx.on_ground and check_top then ctx.state = kPlayerStates.idle end
        end
    end
end

function check_edge_colisions(ctx)
    if not ctx.on_ground then return false, false end
    
    local check_y = ctx.position.y + ctx.size.h + 2
    local left_foot = ctx.map_ref.colides(ctx.position.x + 5, check_y, kColisionType.bottom)
    local right_foot = ctx.map_ref.colides(ctx.position.x + 27, check_y, kColisionType.bottom)
    local center = ctx.map_ref.colides(ctx.position.x + 16, check_y, kColisionType.bottom)

    if not left_foot and center then
        return true, true
    elseif not right_foot and center then
        return true, false
    end
    return false, false
end
