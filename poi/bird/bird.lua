function make_bird(bird)
    local tx, ty = (bird.x - 1) * 16, (bird.y - 2) * 16
    local rx, ry
    local by, oby = 0, 0
    local dead = 0
    local tileset = nil
    local tile_frame = 0
    local flipped = false
    local box = function()
        return {
            x = tx + 6,
            y = ty + by // 1 + 14,
            width = 32 - 12,
            height = 32 - 18
        }
    end

    local function update_relative_position(camx, camy)
        rx, ry = tx, ty + by // 1
        return true
    end

    return {
        update_relative_position = update_relative_position,
        faraway = function() end,
        before_frame = function(frame, player, map, camera)
            if player and dead == 0 then
                by = (math.cos(ty + frame / 80) ^ 4) * 96
                local pbox, tbox = player.box(), box()
                if check_collision(pbox, tbox) then
                    if pbox.y + pbox.height < tbox.y + 8 then
                        player.enemy_taken_jump()
                        dead = 1
                    else
                        player.mark_dead()
                        camera.set_target { box = function() return box() end }
                    end
                end
            end

            if dead == 0 then
                tileset = Sprites.poi.bird
                if by < oby then
                    tile_frame = 1 + (frame // 2) % 4
                else
                    tile_frame = 1 + (frame // 12) % 4
                end
                oby = by
            else
                dead = math.min(5, dead + 0.2)
                if dead < 5 then
                    tileset = Sprites.poi.explode
                    tile_frame = math.min(4, 1 + math.floor(dead // 1))
                end
            end
        end,
        on_frame = function(frame, player, map, camera)
            if dead == 0 and player then
                flipped = (tx < player.box().x) and true or false
                ui.spr(tileset[tostring(tile_frame)], rx, ry, flipped, false)

                if frame % 10 == 0 then
                    P.add_particle(rx, ry, kParticles.smoke)
                end
            elseif dead < 5 then
                ui.spr(tileset[tostring(tile_frame)], rx, ry, flipped, false)
            end
        end
    }
end
