function make_branch(branch, name)
    -- branches is a 4x2 tilemap
    local wx = branch.x * 16 - (4 * 16)
    local wy = branch.y * 16 - (2 * 16)
    local sprite_data = Sprites.poi.branch[tostring(1)]

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        before_frame = function(frame, player, map, camera)
            for x = 0, 3 do
                map.set_colide(wx + x * 16, wy, 11)
            end
        end,
        on_frame = function(frame, player, map, camera)
            ui.spr(sprite_data, wx, wy)
        end,
    }
end