function make_penpen(data)
    local current_frame = 1
    local wx = data.x * 16 - 16
    local wy = data.y * 16
    local vy = 0
    local on_ground = false
    local stop_at_edges = false
    local slide_speed = 2
    local state = "idle"
    local player_to_the_left = false
    local animations = {
        ["idle"] = {frames = 4, cadency = 24, sprite = "walk"},
        ["nearby"] = {frames = 4, cadency = 6, sprite = "walk"},
        ["slide"] = {frames = 2, cadency = 8, sprite = "slide"}
    }

    local function apply_gravity(map)
        vy = math.min(kMaxGravity, vy + kGravity)
        wy = wy + vy
        on_ground = map.colides(wx + 8, wy + 16, kColisionType.bottom)
                 or map.colides(wx + 24, wy + 16, kColisionType.bottom)
        if on_ground and vy > 0 then
            wy = ((wy + 16) // 16) * 16 - 16
            vy = 0
        end
    end

    local function update_state(player)
        if not player or state == "slide" then return end
        local pw = player.box()
        local dist = math.abs(pw.x - wx)
        if dist < 92 then
            state = "slide"
        elseif dist < 128 then
            player_to_the_left = pw.x < wx
            state = "nearby"
        else
            player_to_the_left = pw.x < wx
            state = "idle"
        end
    end

    local function apply_slide(map)
        if state ~= "slide" then return end
        local dir = player_to_the_left and -slide_speed or slide_speed
        wx = wx + dir

        local probe_x = dir > 0 and wx + 26 or wx + 6
        local col_type = dir > 0 and kColisionType.right or kColisionType.left
        if map.colides(probe_x, wy + 8, col_type) then
            state = "idle"
            return
        end

        if stop_at_edges and on_ground then
            if not map.colides(probe_x, wy + 17, kColisionType.bottom) then
                state = "idle"
            end
        end
    end

    return {
        update_relative_position = function() return true end,

        on_enter = function(frame, player, map, camera) end,

        before_frame = function(frame, player, map, camera)
            apply_gravity(map)
            update_state(player)
            apply_slide(map)
        end,

        on_frame = function(frame, player, map, camera)
            local anim = animations[state]
            current_frame = (1 + ((frame // anim.cadency) % anim.frames)) // 1
            local sprite_key = anim.sprite .. "_" .. math.floor(current_frame)
            ui.spr(Sprites.poi.penpen[sprite_key], wx, wy, not player_to_the_left, false)
        end
    }
end