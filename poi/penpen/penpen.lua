function make_penpen(data)
    current_frame = 1
    local wx = data.x * 16
    local wy = data.y * 16
    local animations = {
        ["idle"] = {frames = 4, cadency = 12, sprite = "walk"},
        ["nearby"] = {frames = 4, cadency = 6, sprite = "walk"},
        ["slide"] = {frames = 2, cadency = 8, sprite = "slide"}
    }

    local state = "idle"
    
    return {
        update_relative_position = function() return true end,

        on_enter = function(frame, player, map, camera)
        
        end,

        before_frame = function(frame, player, map, camera)
            local dist = player.x - wx
            if dist < 64 and dist > -64 then
                state = "nearby"
            else
                state = "idle"
            end
        end,
        
        on_frame = function(frame, player, map, camera)
            local animation = animations[state]
            current_frame = (1 + ((frame // animation.cadency) % animation.frames)) // 1
            local sprite_data = Sprites.poi.penpen[animation.sprite .. "_" .. math.floor(current_frame)]
            ui.spr(sprite_data, wx, wy, false, false)
        end
    }
end 