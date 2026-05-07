function make_beetle(beetle)
    local tx, ty = (beetle.x - 1) * 16, (beetle.y - 1) * 16
    local rx, ry
    local bx = 0
    local acell = 0.4
    local dead = 0
    local tileset = nil
    local tile_frame = 0

    local smoke = (function()
        local out = {}
        for i = 1, 30, 1 do
            table.insert(out, { x = 0, y = 0, life = 0 })
        end
        return out
    end)()

    local draw_smoke = function(frame)
        for _, v in ipairs(smoke) do
            if v.life > 0 then
                ui.circfill((v.x) // 1, (v.y) // 1,
                    math.floor(v.life + 0.5), 60)
                v.life = v.life - 0.04
            end
        end
    end

    local make_smoke = function(frame)
        if frame % 10 ~= 0 then return end

        for _, v in ipairs(smoke) do
            if v.life <= 0 then
                v.life = 6
                v.x = tx + bx + (acell > 0 and 8 or 20)
                v.y = ty + 16 + math.random(6)
                return
            end
        end
    end

    local box = function()
        return {
            x = tx + bx // 1 + 6,
            y = ty + 14,
            width = 32 - 12,
            height = 32 - 18
        }
    end

    local function update_relative_position(camx, camy, map)
        if acell > 0 then
            local ix = (tx + bx // 1 + 32)
            local iy = (ty + 8 + 16)
            if map.colides(ix, iy, kColisionType.right) or map.colides(ix, iy, kColisionType.enemies)
                then acell = acell * -1 end
        else
            local ix = (tx + bx // 1)
            local iy = (ty + 8 + 16)
            if map.colides(ix, iy, kColisionType.left) or map.colides(ix, iy, kColisionType.enemies)
                then acell = acell * -1 end
        end

        rx, ry = tx + bx // 1, ty
        return true
    end

    return {
        update_relative_position = update_relative_position,
        faraway = function() dead = 0 end,
        before_frame = function(frame, player, map, camera)
            if player and dead == 0 then
                bx = bx + acell
                local pbox, tbox = player.box(), box()
                if check_collision(pbox, tbox) then
                    if pbox.y + pbox.height < tbox.y + tbox.height then
                        player.enemy_taken_jump()
                        dead = 1
                    else
                        player.mark_dead()
                        camera.set_target { box = function() return box() end }
                    end
                end

                make_smoke(frame)
            end

            if dead == 0 then
                tileset = Sprites.poi.beetle
                tile_frame = 1 + (frame // 3) % 6
            else
                dead = math.min(5, dead + 0.2)
                if dead < 5 then
                    tileset = Sprites.poi.explode
                    tile_frame = math.min(4, 1 + math.floor(dead // 1))
                end
            end
        end,
        on_frame = function(frame, player, map, camera)
            
            draw_smoke(frame)

            if tileset and dead < 5 then
                local flipped = (acell > 0) and true or false
                ui.spr(tileset[tostring(tile_frame)], rx, ry, flipped, false)
            end
        end,
    }
end
