function make_ui(player_ref)
    return {
        before_frame = function(frame, camera, player, map)
            -- No setup needed for UI
        end,
        on_frame = function(frame, camera, player, map)
            -- Timer display
            local timer = string.format("%02d:%02d", (frame // 60) // 60, (frame // 60) % 60)
            ui.print(timer, 1, 1, kColors.black)
            ui.print(timer, 0, 0, kColors.yellow)
            
            -- Cherries collected bar
            local points = player_ref.get_points()
            local total_points = player_ref.get_total_points()
            
            if total_points <= 0 then return end 
            
            local top = 16 + 40 - (40 * points / total_points) // 1
            ui.rect(3, 15, 11, 59, kColors.black)
            ui.rect(2, 14, 10, 58, kColors.yellow)
            ui.rectfill(3, 15, 9, 57, kColors.purple_dark)
            
            if points > 0 and points ~= total_points then
                ui.circfill(6 + math.floor(math.cos(frame / 12) + 0.5), top, 2, kColors.purple_light)
                ui.circfill(6 + math.floor(math.sin(frame / 12) + 0.5), top, 2, kColors.red_light)
            end
            
            ui.rectfill(4, top // 1, 8, 16 + 40, kColors.red_light)
        end
    }
end