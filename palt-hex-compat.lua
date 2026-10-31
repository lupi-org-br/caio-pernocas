
local parsed_colors = {}
local rgb_cache = {}
local hex_cache = {}

local function parse_palette()
    for i = 1, #Palette do
        local value = Palette[i]
        local b = math.floor(value / 1024) % 32
        local g = math.floor(value / 32) % 32
        local r = value % 32

        parsed_colors[i] = {
            r = r * 8 + math.floor(r / 4),
            g = g * 8 + math.floor(g / 4),
            b = b * 8 + math.floor(b / 4)
        }
    end
end

function Palette.rgb(r, g, b)
    local key = r * 65536 + g * 256 + b
    local cached = rgb_cache[key]

    if cached ~= nil then
        return cached
    end

    local min_dist = math.huge
    local best_idx = 1

    for i = 1, #parsed_colors do
        local color = parsed_colors[i]
        local dr = color.r - r
        local dg = color.g - g
        local db = color.b - b
        local dist = dr * dr + dg * dg + db * db

        if dist < min_dist then
            min_dist = dist
            best_idx = i
        end
    end

    local result = best_idx - 1
    rgb_cache[key] = result

    return result
end

function Palette.hex(value)
    local cached = hex_cache[value]

    if cached ~= nil then
        return cached
    end

    local r, g, b

    if type(value) == "number" then
        r = math.floor(value / 65536) % 256
        g = math.floor(value / 256) % 256
        b = value % 256
    elseif type(value) == "string" then
        local clean = value:gsub("^#", ""):gsub("^0[xX]", "")
        local number = tonumber(clean, 16)

        if number then
            r = math.floor(number / 65536) % 256
            g = math.floor(number / 256) % 256
            b = number % 256
        end
    end

    if r == nil or g == nil or b == nil then
        return 0
    end

    local result = Palette.rgb(r, g, b)
    hex_cache[value] = result

    return result
end

parse_palette()

return Palette
