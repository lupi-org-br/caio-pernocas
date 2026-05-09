require "player.collision"
require "player.physics"
require "player.draw"
require "player.state_manager"

function make_player(map_ref)
    local ctx = {
        position = {
            x = CurrentStage.player_start.x * 16,
            y = CurrentStage.player_start.y * 16
        },
        last_check = { 
            x = CurrentStage.player_start.x * 16, 
            y = CurrentStage.player_start.y * 16 
        },
        velocity = { x = 0, y = 0 },
        size = { w = 32, h = 32 },
        looking_back = CurrentStage.looking_back,
        state = kPlayerStates.idle,
        points = 0, total_points = 0,
        win = 0, win_frame = 0,
        dead = false,
        reset_frames = 0, should_reset = false,
        on_ground = false,
        tileset = nil, tile_frame = 0,
        event_listeners = {},
        roll_direction = 0,
        map_ref = map_ref
    }

    local player_api = {}
    ctx.player_api = player_api

    -- Global helpers needed by states (would normally put in a utils file, but keeping here for now)
    _G.call_event_listeners = function(ctx, event, params)
        for _, listener in ipairs(ctx.event_listeners) do
            if listener.event == event then
                listener.callback(params)
            end
        end
    end

    _G.action_button_is = function(kind)
        if kind == kState.press then
            return ui.btn(BTN_Z, pad_1) ~= false
        elseif kind == kState.pressed then
            return ui.btnp(BTN_Z, pad_1) ~= false
        else
            return false
        end
    end

    local function box()
        local cfactor = (ctx.state == kPlayerStates.crouch or ctx.state == kPlayerStates.roll) and 14 or 6
        return {
            x = math.floor(ctx.position.x + 0.5) + 8,
            y = math.floor(ctx.position.y + 0.5) + cfactor,
            width = 32 - 16,
            height = 32 - cfactor
        }
    end

    -- Assemble Public API
    player_api.box = box
    player_api.get_points = function() return ctx.points end
    player_api.get_total_points = function() return ctx.total_points end
    player_api.should_reset = function()
        return (ctx.win > 200 and action_button_is(kState.press))
    end
    player_api.account_point = function() ctx.total_points = ctx.total_points + 1 end
    player_api.mark_point = function(point_x, point_y)
        ctx.points = ctx.points + 1
        ctx.last_check.x = point_x
        ctx.last_check.y = point_y
        if ctx.points == ctx.total_points then
            MapStages.mark_current_as_done()
        end
    end
    player_api.is_dead = function() return ctx.dead end
    player_api.is_rolling = function() return ctx.state == kPlayerStates.roll end
    player_api.get_roll_direction = function() return ctx.roll_direction end
    player_api.invert_roll = function()
        if not ctx.is_rolling() then return end
        ctx.roll_direction = -ctx.roll_direction
        ctx.looking_back = not ctx.looking_back
    end
    player_api.spring_jump = function()
        ctx.velocity.y = -(kJumpForce * 1.5)
        ctx.on_ground = false
        call_event_listeners(ctx, kPlayerEvents.jumped)
    end
    player_api.enemy_taken_jump = function()
        ctx.velocity.y = -(kJumpForce * 0.7)
        ctx.on_ground = false
        call_event_listeners(ctx, kPlayerEvents.jumped)
    end
    player_api.mark_dead = function()
        ctx.velocity.y = -(kJumpForce * 0.8)
        ctx.dead = true
        ctx.state = kPlayerStates.dead
    end
    player_api.overlay = function()
        return {
            before_frame = function(frame, camera, player, map)
                overlay_before_player(ctx, frame, camera)
            end,
            on_frame = function(frame, camera, player, map)
                overlay_frame_player(ctx, frame, camera)
            end
        }
    end
    player_api.before_frame = function(frame, camera, player, map)
        if ctx.win == 0 and ctx.reset_frames < 16 then 
            update_player_state(ctx, frame)
            if not ctx.dead then check_h_colisions(ctx) end
            apply_gravity(ctx)
            if not ctx.dead then
                apply_velocity(ctx)
                check_v_colisions(ctx)
            end
        end
        ctx.tile_frame = 1 + ((frame // ctx.state.cadency) % ctx.state.frames) // 1
        ctx.tileset = Sprites.player[ctx.state.asset]["f"..ctx.tile_frame]
    end
    player_api.on_frame = function(frame, camera, player, map)
        draw_player(ctx, frame, camera)
    end
    player_api.add_listener = function(event, callback)
        table.insert(ctx.event_listeners, { event = event, callback = callback })
    end

    return player_api
end
