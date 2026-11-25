
Sprites.find = function(path)
    assert(type(path) == "string", "Sprites.find: nome deve ser string")

    local current = Sprites

    for part in string.gmatch(path, "[^/]+") do
        if type(current) ~= "table" then
            current = nil
            break
        end

        current = current[part]
    end

    if type(current) == "table" then
        return current
    end

    local function search(tree, name, visited)
        if type(tree) ~= "table" or visited[tree] then
            return nil
        end

        visited[tree] = true

        for key, value in pairs(tree) do
            if key == name and type(value) == "table" then
                return value
            end
        end

        for _, value in pairs(tree) do
            if type(value) == "table" then
                local result = search(value, name, visited)

                if result then
                    return result
                end
            end
        end

        return nil
    end

    local name = path:match("([^/]+)$")
    local result = search(Sprites, name, {})

    if result then
        return result
    end

    error("Sprites.find: sprite não encontrado: " .. path)
end
