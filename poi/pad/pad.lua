function make_pad(pad, start_frame) 
    local wx, wy = (pad.x - 1) * 16, (pad.y) * 16
    local state = 1
    local frame_counter = start_frame
    local states = {
        { frames = 80, tile = 0, collides = true},
        { frames = 3, tile = 1, collides = true},
        { frames = 3, tile = 2, collides = true},
        { frames = 80, tile = nil, collides = false},
        { frames = 3, tile = 2, collides = true},
        { frames = 3, tile = 1, collides = true},
    }
    
    local box = function()
        return {
            x = wx,
            y = wy,
            width = 16,
            height = 16
        }
    end

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        faraway = function() end,
        before_frame = function(frame, player, map, camera) 
            
            frame_counter = frame_counter + 1
            if frame_counter >= states[state].frames then
                state = state + 1
                if state > #states then
                    state = 1
                end
                frame_counter = 0
            end

            local collides = states[state].collides
            if collides then
                map.set_colide(wx, wy, 11)
            else
                map.set_colide(wx, wy, nil)
            end
        end,
        on_frame = function(frame, player, map, camera) 
            -- use state to find tile id
            local tile_id = states[state].tile
            if tile_id then
                ui.tile(Sprites.poi.pad.tiles, tile_id, wx, wy)
            end
        end,
    }
end
