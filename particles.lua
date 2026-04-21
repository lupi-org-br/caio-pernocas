
local function make_snow_particle(x, y)
    local cx, cy = x, y
    local ax = 0
    local ay = 0.4 + math.random() * 0.4
    local life = 120 + math.random() * 60
    return {
        update = function(frame)
            cx = cx + ax
            cy = cy + ay
            life = life - 1
        end,
        draw = function(frame)
            local size = life / 180 * 4
            ui.circfill(cx, cy, size, 231)
        end,
        alive = function() 
            return life > 0
        end
    }
end

kParticles = {
    snow = 1
}

local particles_max = 64
local particles_factories = {
    [kParticles.snow] = make_snow_particle
}

function make_particles()
    local particles = {}
    
    local function add_particle(x, y, type)
        if #particles < particles_max then
            table.insert(particles, particles_factories[type](x, y))
        end
    end

    local function update(frame)
        for i = #particles, 1, -1 do
            local p = particles[i]
            p.update(frame)
            if not p.alive() then
                table.remove(particles, i)
            end
        end
    end

    local function draw(frame)
        for _, p in pairs(particles) do
            p.draw(frame)
        end
    end

    return {
        add_particle = add_particle,
        before_frame = update,
        on_frame = draw
    }
end