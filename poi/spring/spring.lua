function make_spring(data)
    local spring = data
    local jump_frames = 0
    local tileset = Sprites.poi.spring.tiles
    local rx = (spring.x - 1) * 16
    local ry = (spring.y) * 16

    local function box()
        return {
            x = rx,
            y = ry,
            width = 16,
            height = 16
        }
    end

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        before_frame = function(frame, player, map, camera)
            jump_frames = math.max(jump_frames - 1, 0)

            if player and check_collision(box(), player.box()) then
                player.spring_jump()
                jump_frames = 12
            end
        end,
        on_frame = function(frame, player, map, camera)
            ui.tile(tileset, jump_frames == 0 and 0 or 1, rx, ry)
        end,
    }
end
