function make_decal(decal, name)
    local rx = ((decal.x + (kPoiOrigin[decal.poi][1])) * 16)
    local ry = ((decal.y + (kPoiOrigin[decal.poi][2])) * 16)
    local sprite_data = Sprites.poi[name].decal

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        before_frame = function(frame, player, map, camera) end,
        on_frame = function(frame, player, map, camera)
            ui.spr(sprite_data, rx, ry)
        end,
    }
end
