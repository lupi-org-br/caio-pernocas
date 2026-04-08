function make_camera(map_ref)
    local position = {
        x = CurrentStage.player_start.x * 16,
        y = CurrentStage.player_start.y * 16
    }
    local size = map_ref.size
    local target = nil
    local camera_applied = false

    local deadZone = {
        x = (480 - 48) / 2,
        y = (270 - 16) / 2,
        width = 48,
        height = 16
    }

    return {
        getxy = function()
            return (position.x + 0.5) // 1, (position.y + 0.5) // 1
        end,
        set_target = function(new_target)
            target = new_target
        end,
        apply = function()
            if not camera_applied then
                local camx, camy = (position.x + 0.5) // 1, (position.y + 0.5) // 1
                ui.camera(camx, camy)
                camera_applied = true
            end
        end,
        reset = function()
            if camera_applied then
                ui.camera(0, 0)
                camera_applied = false
            end
        end,
        before_frame = function(frame, camera, player, map)
            if target == nil or target.box == nil then return end
            local tbox = target.box()
            local playerCenterX = tbox.x + tbox.width / 2;
            local playerCenterY = tbox.y + tbox.height / 2;

            if playerCenterX < position.x + deadZone.x then
                position.x = lerp(position.x, playerCenterX - deadZone.x, 0.5)
            elseif playerCenterX > position.x + deadZone.x + deadZone.width then
                position.x = lerp(position.x, playerCenterX - deadZone.x - deadZone.width, 0.5)
            end

            if playerCenterY < position.y + deadZone.y then
                position.y = lerp(position.y, playerCenterY - deadZone.y, 0.5)
            elseif playerCenterY > position.y + deadZone.y + deadZone.height then
                position.y = lerp(position.y, playerCenterY - deadZone.y - deadZone.height, 0.5)
            end

            position.x = math.max(0, math.min(position.x, size.width - 480));
            position.y = math.max(0, math.min(position.y, size.height - 270));
        end,
        on_frame = function(frame, camera, player, map)

        end
    }
end
