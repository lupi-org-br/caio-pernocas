function make_penpen(data)
    local current_frame = 1
    local wx = data.x * 16 - 16
    local wy = data.y * 16
    local vy = 0

    math.randomseed(wx)

    local salt = math.random(1, 20)
    local on_ground = false
    local stop_at_edges = false
    local slide_speed = 2 + math.floor(math.random(1, 2))
    local dead = 0
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

    local function has_clearance(map)
        local probe_x = player_to_the_left and wx + 2 or wx + 28
        local col_type = player_to_the_left and kColisionType.left or kColisionType.right
        return not map.colides(probe_x, wy + 8, col_type)
    end

    local function update_state(player, map)
        if not player or state == "slide" then return end
        local pw = player.box()
        local dist = math.abs(pw.x - wx)
        if dist < 92 and has_clearance(map) then
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

        local probe_x = dir > 0 and wx + 28 or wx + 2
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

    local function box()
        return { x = wx + 6, y = wy, width = 20, height = 16 }
    end

    local function check_player_hit(player, camera)
        if not player or dead > 0 then return end
        local pbox, ebox = player.box(), box()
        if not check_collision(pbox, ebox) then return end

        local jump_kill = pbox.y + pbox.height < ebox.y + ebox.height
        local penpen_dir = player_to_the_left and -1 or 1
        local roll_kill = player.is_rolling()
            and player.get_roll_direction() * penpen_dir > 0

        if jump_kill or roll_kill then
            if jump_kill then player.enemy_taken_jump()
            else player.invert_roll() end
            dead = 1
        else
            player.mark_dead()
            camera.set_target { box = function() return box() end }
        end
    end

    return {
        update_relative_position = function() return true end,

        on_enter = function(frame, player, map, camera) end,

        before_frame = function(frame, player, map, camera)
            if dead > 0 then
                dead = math.min(5, dead + 0.2)
                return
            end
            apply_gravity(map)
            update_state(player, map)
            apply_slide(map)
            check_player_hit(player, camera)
        end,

        on_frame = function(frame, player, map, camera)
            if dead >= 5 then return end
            if dead > 0 then
                local ef = math.min(4, 1 + math.floor(dead // 1))
                ui.spr(Sprites.poi.explode[tostring(ef)], wx, wy, false, false)
                return
            end
            local anim = animations[state]
            current_frame = (1 + (((frame + salt) // anim.cadency) % anim.frames)) // 1
            local sprite_key = anim.sprite .. "_" .. math.floor(current_frame)
            ui.spr(Sprites.poi.penpen[sprite_key], wx, wy, not player_to_the_left, false)
        end
    }
end