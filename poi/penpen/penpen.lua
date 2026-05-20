function make_penpen(data)
    current_frame = 1
    local wx = data.x * 16 - 16
    local wy = data.y * 16
    local animations = {
        ["idle"] = {frames = 4, cadency = 16, sprite = "walk"},
        ["nearby"] = {frames = 4, cadency = 6, sprite = "walk"},
        ["slide"] = {frames = 2, cadency = 8, sprite = "slide"}
    }

    local state = "idle"
    local player_to_the_left = false
    
    return {
        update_relative_position = function() return true end,

        on_enter = function(frame, player, map, camera)
        
        end,

        before_frame = function(frame, player, map, camera)
            local pw = player.box()
            local dist = math.abs(pw.x - wx)

            if state == "slide" or dist < 32 then
                state = "slide"
            elseif dist < 128 then
                player_to_the_left = pw.x < wx
                state = "nearby"
            else
                player_to_the_left = pw.x < wx
                state = "idle"
            end
        end,
        
        on_frame = function(frame, player, map, camera)
            local animation = animations[state]
            current_frame = (1 + ((frame // animation.cadency) % animation.frames)) // 1
            local sprite_data = Sprites.poi.penpen[animation.sprite .. "_" .. math.floor(current_frame)]
            ui.spr(sprite_data, wx, wy, not player_to_the_left, false)
        end
    }
end 