function make_title()
    local move_to_next = 0
    return {
        name = function() return "title" end,
        update = function() end,
        is_finished = function()
            return move_to_next == 18
        end,
        draw = function(current_frame)
            frame = current_frame

            for i = 1, #Palette do
                ui.palset(i - 1, Palette[i])
            end

            pad_1, pad_2 = 0, 0

            if move_to_next > 0 then
                move_to_next = move_to_next + 1
            end

            if ui.btn(BTN_Z, pad_1) then
                move_to_next = 1
            end

            ui.rectfill(0, 0, 480, 270, 31)

            local delta = (current_frame // 2) % 32
            for x = 0, 21, 1 do
                for y = 0, 12, 1 do
                    local next_x = x * 16
                    local next_y = y * 16 + 8 - delta
                    local next_radius = ((x + y) % 2 == 0) and 8 or 4
                    if next_y >= -16 and next_y < 270 + 16 then
                        ui.circfill(next_x, next_y, next_radius, 32)
                    end
                end
            end

            ui.rectfill(22, 22, 302, 162, 8)
            ui.rectfill(20, 20, 300, 160, 7)

            ui.print("Encontre as cerejas !", 112, 50, kColors.yellow)
            ui.print("15 x", 138, 80, kColors.yellow)
            local cherry_frame = (frame // 4) % 7
            ui.tile(Sprites.poi.cherry, cherry_frame, 160, 70)

            local delta = nil
            if move_to_next > 0 then
                delta = math.min(move_to_next / 2, 8) // 1
            elseif frame < 32 then
                delta = math.min((32 - frame) / 2, 8) // 1
            end

            if delta ~= nil then
                for x = 0, 21, 1 do
                    for y = 0, 12, 1 do
                        local next_x = x * 16
                        local next_y = y * 16
                        ui.rectfill(
                            next_x + 8 - delta,
                            next_y + 8 - delta,
                            next_x + 8 + delta,
                            next_y + 8 + delta,
                            8)
                    end
                end
            end
        end
    }
end
