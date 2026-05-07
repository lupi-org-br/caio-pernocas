function make_cherry(cherry)
    local taken = 0
    local rx, ry
    local tile_frame = 0

    local box = function()
        return {
            x = (cherry.x - 1) * 16,
            y = (cherry.y) * 16 + 2,
            width = 16,
            height = 16
        }
    end

    local function update_relative_position(camx, camy)
        rx, ry = (cherry.x * 16 - 22), (cherry.y * 16)
        return taken < 7 
    end

    local function check_pick(player)
        if player and check_collision(box(), player.box()) then
            player.mark_point(box().x, box().y)
            taken = 1
        end
    end

    return {
        update_relative_position = update_relative_position,
        before_frame = function(frame, player, map, camera)
            if taken == 0 then
                check_pick(player)
                tile_frame = 1 + (frame // 4 + cherry.x) % 7
            else
                tile_frame = 8 + math.floor((taken // 1) % 7)
                taken = math.min(taken + 0.2, 7)
            end
        end,
        on_frame = function(frame, player, map, camera)
            ui.spr(Sprites.poi.cherry[tostring(tile_frame)], rx, ry)
        end,
    }
end
