function apply_gravity(ctx)
    ctx.position.y = ctx.dead and ctx.position.y + ctx.velocity.y * 0.6 or ctx.position.y + ctx.velocity.y
    ctx.velocity.y = ctx.velocity.y > kMaxGravity and kMaxGravity or ctx.velocity.y + kGravity
end

function apply_velocity(ctx)
    ctx.position.x = ctx.position.x + ctx.velocity.x
end
