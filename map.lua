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
        data.tilesets.FG = 'sunny' .. 1 + ((frame // 8) % 4)
        ui.map(data.foreground)
    end

    return {
        size = get_map_size(),
        before_frame = function(frame, camera, player, map)
            
        end,
        on_frame = function(frame, camera, player, map)
            draw(frame, camera)
        end,
        colides = function(x, y, type)
            local width = data.metadata.width // 1
            local tx, ty = x // 16, y // 16
            local ix = math.floor((ty * width) + tx + 1)
            local type_id = data.colision.POIS[ix]

            if type_id == nil then return false end
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
