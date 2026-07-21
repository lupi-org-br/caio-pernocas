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

            if current_frame%32 > 16 then 
                ui.print("pressione [start] para iniciar!", 268-1, 170, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268+1, 170, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170+1, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170-1, Palette.hex(0x552448))
                ui.print("pressione [start] para iniciar!", 268, 170, Palette.hex(0xFFFFFF))
            end 
        end
    }
end