function make_ui(player_ref)
    local current_points = 0
    return {
        before_frame = function(frame, camera, player, map) end,
        on_frame = function(frame, camera, player, map)
            local timer = string.format("%02d:%02d", (frame // 60) // 60, (frame // 60) % 60)
            ui.print(timer, 1, 1, kColors.black)
            ui.print(timer, 0, 0, kColors.yellow)
            
            local target_points = player_ref.get_points()
            local total_points = player_ref.get_total_points()
            
            if total_points <= 0 then return end 
            
            current_points = current_points + (target_points - current_points) * 0.1
            if math.abs(target_points - current_points) < 0.01 then
                current_points = target_points
            end
            
            local top = 16 + 40 - (40 * current_points / total_points) // 1
            ui.rect(3, 15, 11, 59, kColors.black)
            ui.rect(2, 14, 10, 58, kColors.yellow)
            ui.rectfill(3, 15, 9, 57, kColors.purple_dark)
            
            if current_points > 0 and current_points < total_points then
                ui.circfill(6 + math.floor(math.cos(frame / 12) + 0.5), top, 2, kColors.purple_light)
                ui.circfill(6 + math.floor(math.sin(frame / 12) + 0.5), top, 2, kColors.red_light)
            end
            
            ui.rectfill(4, top // 1, 8, 16 + 40, kColors.red_light)
        end
    }
end