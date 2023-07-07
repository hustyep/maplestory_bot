---@class Object
Object = {
    ---@type string
    name = "Object",
}
Object.__index = Object

function Object:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    return obj
end

function Object:is(T)
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end