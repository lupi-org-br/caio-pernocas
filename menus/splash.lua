local kStates = {
    unloaded,
    loading,
    waiting
}

local current_state = kStates.unloaded

local function _next_stage()
    if current_state == kStates.unloaded then 
        current_state = loading
    elseif current_state == kStates.loading then
        
        require "map"
        require "bg"
        require "player.player"
        require "pois"
        require "camera"
        require "title"
        require "utils"
        require "overw"
        require "ui"
        require "particles"

        current_state = waiting
    end  
end 

function make_splash()
    return {
        name = function() return "splash" end,
        update = function() end,
        is_finished = function()
            return false
        end,
        draw = function(current_frame)
            for i = 1, #Palette do
                local color = Palette[i]
                ui.palset(i - 1, color)
            end

            pad_1, pad_2 = 0, 0

            if ui.btnp(BTN_Z, pad_1) then

            end

            ui.cls(kColors.purple_light)
            ui.camera()
            ui.clip()

            ui.spr(Sprites.menus.splash_p1, 0, 0)
            ui.spr(Sprites.menus.splash_p2, 160, 0)
            ui.spr(Sprites.menus.splash_p3, 320, 0)

            if current_frame%64 > 32 then 
                ui.print("pressione [start] para iniciar!", 268-1, 170, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268+1, 170, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170+1, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170-1, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170, Palette.hex(0xFFFFFF))
            end 

            _next_stage()
        end
    }
end