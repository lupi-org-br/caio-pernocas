function make_branch(branch, name)
    -- branches is a 4x2 tilemap
    local dx = name == 'left' and 58 or 18
    local flipped = not (name == 'left' and true or false)
    local wx = branch.x * 16 - dx
    local wy = branch.y * 16 - (1 * 16)
    
    local target_frame = 1
    local current_frame = 1
    local frame_increment_speed = 0.25

    local function update_relative_position(camx, camy)
        return true
    end

    return {
        update_relative_position = update_relative_position,
        on_enter = function(frame, player, map, camera)
            player.add_listener(kPlayerEvents.falling, function()
                target_frame = 1
            end)

            player.add_listener(kPlayerEvents.jumped, function()
                target_frame = 1
            end)
            
            local start_x = name == 'left' and 0 or 1
            for x = 1, 2 do
                map.set_colide(wx + (start_x + x) * 16, wy + 16, 11, function(event)
                    if event == "touching" then
                        target_frame = 5
                    end
                end)
            end
        end,
        before_frame = function(frame, player, map, camera)
            if current_frame < target_frame then
                current_frame = current_frame + frame_increment_speed
            elseif current_frame > target_frame then
                current_frame = current_frame - frame_increment_speed
            end
        end,
        on_frame = function(frame, player, map, camera)
            local sprite_data = Sprites.poi.branch[tostring(math.floor(current_frame))]
            ui.spr(sprite_data, wx, wy, flipped, false)
        end,
    }
end