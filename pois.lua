
require "poi.branch.branch"
require "poi.utils"
require "poi.spike.spike"
require "poi.spring.spring"
require "poi.beetle.beetle"
require "poi.pad.pad"
require "poi.bird.bird"
require "poi.decal.decal"
require "poi.cherry.cherry"

local function make_poi_by_type(data, camera, player, map)
    if data.poi == kPoiType.spike then return make_spike(data) end
    if data.poi == kPoiType.spring then return make_spring(data) end
    if data.poi == kPoiType.beetle then return make_beetle(data) end
    if data.poi == kPoiType.palm then return make_decal(data, 'palm') end
    if data.poi == kPoiType.pine then return make_decal(data, 'pine') end
    if data.poi == kPoiType.house then return make_decal(data, 'house') end
    if data.poi == kPoiType.bigtree then return make_decal(data, 'bigtree') end
    if data.poi == kPoiType.rock then return make_decal(data, 'rock') end
    if data.poi == kPoiType.snowy_pine then return make_decal(data, 'snowy_pine') end
    if data.poi == kPoiType.bird then return make_bird(data) end
    if data.poi == kPoiType.pad_a then return make_pad(data, 0) end
    if data.poi == kPoiType.pad_b then return make_pad(data, 20) end
    if data.poi == kPoiType.pad_c then return make_pad(data, 40) end
    if data.poi == kPoiType.pad_d then return make_pad(data, 60) end
    if data.poi == kPoiType.branch_left then return make_branch(data, 'left') end
    if data.poi == kPoiType.branch_right then return make_branch(data, 'right') end

    if data.poi == kPoiType.cherry then
        player.account_point()
        return make_cherry(data)
    end
end

function make_pois(camera, player, map)
    local all_pois = {}
    for _, poi in ipairs(map.get_pois()) do
        local created = make_poi_by_type(poi, camera, player, map)
        if created then 
            table.insert(all_pois, created)
        end
    end

    return {
        on_enter = function(frame, camera, player, map) 
            for _, poi in ipairs(all_pois) do
                if poi.on_enter then
                    poi.on_enter(frame, player, map, camera)
                end
            end
        end,
        before_frame = function(frame, camera, player, map)
            local player = player.is_dead() == false and player or nil
            local camx, camy = camera.getxy()

            for _, poi in ipairs(all_pois) do
                poi.will_draw = poi.update_relative_position(camx, camy, map)
                if poi.will_draw and poi.before_frame then
                    poi.before_frame(frame, player, map, camera)
                elseif poi.faraway then
                    poi.faraway()
                end
            end
        end,
        on_frame = function(frame, camera, player, map)
            local player = player.is_dead() == false and player or nil

            for _, poi in ipairs(all_pois) do
                if poi.will_draw then
                    poi.on_frame(frame, player, map, camera)
                end
            end
        end
    }
end
