function make_spike(data)
    local rx = (data.x - 1) * 16
    local ry = (data.y) * 16

    local function box()
        return {
            x = rx,
            y = ry + 6,
            width = 16,
            height = 10
        }
    end

    return {
        box = box,
        update_relative_position = function() return true end,
        before_frame = function(frame, player, map, camera)
            if player and check_collision(box(), player.box()) then
                camera.set_target { box = function() return box() end }
                player.mark_dead()
            end
        end,
        on_frame = function(frame, player, map, camera) end,
    }
end
