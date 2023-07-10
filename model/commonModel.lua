require("model.classic")

---@enum Direction
Direction = {
    top = { "up" },
    bottom = { "down" },
    left = { "left" },
    right = { "right" },
    topLeft = { "top", "left" },
    topRight = { "top", "right" },
    bottomLeft = { "down", "left" },
    bottomRight = { "down", "right" }
}

---点击方向键
---@param direction Direction
function PressDirectionKey(direction)
    for i, v in ipairs(direction) do
        -- print("press direction:", direction)
        KeyPress(v)
    end
end

---按下方向键
---@param direction Direction
function PressDownDirectionKey(direction)
    for i, v in ipairs(direction) do
        -- print("press direction:", direction)
        KeyDown(v)
    end
end

---@class Point: Object @point meta class
Point = {
    ---@type number
    x = 0,
    ---@type number
    y = 0
}
setmetatable(Point, Object)
Point.__index = Point

---@param x number
---@param y number
---@return Point
function Point:new(x, y)
    local o = {}
    setmetatable(o, self)
    o.x = x
    o.y = y
    return o
end

---@class Size: Object @size meta class
Size = {
    ---@type number
    width = 0,
    ---@type number
    height = 0
}
setmetatable(Size, Object)
Size.__index = Size

---@param width number
---@param height number
---@return Size
function Size:new(width, height)
    local o = {}
    setmetatable(o, self)
    o.width = width
    o.height = height
    return o
end

---@class Rect: Object @frame meta class
Rect = {
    ---@type Point
    origin = Point:new(0, 0),
    ---@type Size
    size = Size:new(0, 0)
}
setmetatable(Rect, Object)
Rect.__index = Rect

---@param origin Point
---@param size Size
---@return Rect
function Rect:new(origin, size)
    local o = {}
    setmetatable(o, self)
    o.origin = origin
    o.size = size
    return o
end

---@class EdgeInsets: Object @EdgeInsets meta class
EdgeInsets = {
    ---@type number
    top = 0,
    ---@type number

    left = 0,
    ---@type number

    bottom = 0,
    ---@type number

    right = 0
}
setmetatable(EdgeInsets, Object)
EdgeInsets.__index = EdgeInsets

---comment
---@param top number
---@param left number
---@param bottom number
---@param right number
---@return EdgeInsets
function EdgeInsets:new(top, left, bottom, right)
    local o = {}
    setmetatable(o, self)
    o.top = top
    o.left = left
    o.bottom = bottom
    o.right = right
    return o
end

PointZero = Point:new(0, 0)
SizeZero = Size:new(0, 0)
RectZero = Rect:new(PointZero, SizeZero)
EdgeInsetsZero = EdgeInsets:new(0, 0, 0, 0)
