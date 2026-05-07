require "player.states.idle"
require "player.states.run"
require "player.states.crouch"
require "player.states.roll"
require "player.states.jump"
require "player.states.fall"
require "player.states.dead"

PlayerStates = {
    [kPlayerStates.idle] = StateIdle,
    [kPlayerStates.run] = StateRun,
    [kPlayerStates.crouch] = StateCrouch,
    [kPlayerStates.roll] = StateRoll,
    [kPlayerStates.jump] = StateJump,
    [kPlayerStates.fall] = StateFall,
    [kPlayerStates.dead] = StateDead,
}

function update_player_state(ctx, frame)
    local current_state_module = PlayerStates[ctx.state]
    if current_state_module and current_state_module.update then
        local next_state = current_state_module.update(ctx, frame)
        if next_state and next_state ~= ctx.state then
            ctx.state = next_state
            local new_state_module = PlayerStates[next_state]
            if new_state_module and new_state_module.enter then
                new_state_module.enter(ctx)
            end
        end
    end
end
