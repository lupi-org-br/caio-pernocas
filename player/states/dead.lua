StateDead = {}

function StateDead.update(ctx, frame)
    ctx.velocity.x = 0
    ctx.roll_direction = 0
    return nil
end
