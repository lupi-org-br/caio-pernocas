require "palette"
require "sprites"

require "const"
require "map"
require "bg"
require "player"
require "pois"
require "camera"
require "title"
require "utils"
require "overw"
require "ui"

function make_game()
    local frame = 0
    local map = make_map()
    local player = make_player(map)
    local camera = make_camera(map)
    local pois = make_pois(camera, player, map)
    local bg = make_bg()
    local hud = make_ui(player)
    local assets = { bg, map, player, camera, pois, hud }
    camera.set_target(player)

    pois.on_enter(frame, camera, player, map)

    return {
        update = function() end,
        name = function() return "game" end,
        is_finished = function()
            return player.should_reset()
        end,
        draw = function(current_frame)
            frame = current_frame

            for i = 1, #Palette do
                local color = Palette[i]
                ui.palset(i - 1, color)
            end
            
            pad_1, pad_2 = 0,0
            
            ui.camera(0, 0)
            ui.clip(0, 0, 480, 270)

            for _, v in pairs(assets) do
                v.before_frame(frame, camera, player, map)
            end

            bg.on_frame(frame, camera, player, map)
            
            local camx, camy = camera.getxy()
            ui.camera(camx, camy)
            
            map.on_frame(frame, camera, player, map)
            player.on_frame(frame, camera, player, map)
            pois.on_frame(frame, camera, player, map)
            
            ui.camera(0, 0)
            
            hud.on_frame(frame, camera, player, map)
            player.overlay().on_frame(frame, camera, player, map)
        end
    }
end

Frame, Scene = 0, nil

local function draw()
    Frame = Frame + 1

    if Scene == nil then
        Scene = make_overworld()
    end

    if Scene.is_finished() == true then
        math.randomseed(os.time())
        Frame = 0
        Scene = Scene.name() == "game" and make_overworld() or make_game()
        collectgarbage("collect")
    end

    Scene.draw(Frame)
end

function update(new_frame)
    if Scene then Scene.update() end
    draw()
end

-- sfx.music("orca")
collectgarbage("generational")
