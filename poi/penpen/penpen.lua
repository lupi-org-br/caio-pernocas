function make_penpen(data)
    current_frame = 1
    local wx = data.x * 16
    local wy = data.y * 16
    
    return {
        update_relative_position = function() return true end,

        on_enter = function(frame, player, map, camera)
        
        end,

        before_frame = function(frame, player, map, camera)
        
        end,
        
        on_frame = function(frame, player, map, camera)
            local sprite_data = Sprites.poi.penpen["walk_" .. tostring(math.floor(current_frame))]
            ui.spr(sprite_data, wx, wy, false, false)
        end
    }
end 