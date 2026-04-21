function make_branch(branch, name)
    -- branches is a 4x2 tilemap

    local dx = name == 'left' and 4 or 1
    local flipped = not (name == 'left' and true or false)
    local wx = branch.x * 16 - (dx * 16)
    local wy = branch.y * 16 - (1 * 16)
    local sprite_data = Sprites.poi.branch[tostring(1)]

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        on_enter = function(frame, player, map, camera)
            local start_x = name == 'left' and 0 or 1
            for x = 0, 2 do
                map.set_colide(wx + (start_x + x) * 16, wy + 16, 11)
            end
        end,
        on_frame = function(frame, player, map, camera)
            ui.spr(sprite_data, wx, wy, flipped, false)
        end,
    }
end