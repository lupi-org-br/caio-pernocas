function make_map()
    local data = require(CurrentStage.map_name)

    local function get_map_size()
        local size = { 
            height = data.metadata.height * 16,
            width = data.metadata.width * 16
        }

        return size
    end

    local function draw(frame, camera)
        local camx, camy = camera.getxy()

        -- local ystart = 1 + camy // 16
        -- local yend = ystart + 17
        -- local xstart = 1 + camx // 16
        -- local xend = xstart + 30

        ui.camera(camx, camy)
        data.tilesets.FG = 'sunny' .. 1 + ((frame // 8) % 4)
        ui.map(data.foreground)
        ui.camera(0, 0)

        -- local tileset = Sprites.tilemap.sunny.['sunny_' .. 1 + ((frame // 8) % 4)]

        -- for y = ystart, yend do
        --     local line = data[y]
        --     if line ~= nil then
        --         for x = xstart, xend do
        --             local vx = line[x]
        --             if vx ~= nil then
        --                 local tile = vx[kMapID.tile]
        --                 if tile then 
        --                     ui.tile(tileset, tile - 1, 16 * (x - 1) - camx, 16 * (y - 1) - camy)
        --                 end 
        --             end
        --         end
        --     end
        -- end
    end

    return {
        size = get_map_size(),
        before_frame = function(frame, camera, player, map)
            
        end,
        on_frame = function(frame, camera, player, map)
            draw(frame, camera)
        end,
        colides = function(x, y, type)
            -- print("colides called with ", x, y, type)
            local width = data.metadata.width
            local type_id = data.colision.POIS[((x // 16) * width) + (y//16)]

            if type_id == nil then return false end
            print(x,y, tostring(type_id), tostring(types))
            local types = kColisionTile[type_id]
            
            for _, atype in pairs(types) do
                if atype == type then return true end
            end
            
            return false
        end,
        get_pois = function()
            local pois = {}
            local columns = data.metadata.width
            for k, v in pairs(data.pois.POIS) do
                local x = k % columns
                local y = k // columns
                table.insert(pois, { x = x, y = y, poi = v })
            end
            return pois
        end
    }
end
