return function make_branch(branch, name)
    local wx = branch.x
    local wy = branch.y
    local sprite_data = Sprites.poi.branch[tostring(1)]

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        before_frame = function(frame, player, map, camera) end,
        on_frame = function(frame, player, map, camera)
            ui.spr(sprite_data, wx, wy)
        end,
    }
end