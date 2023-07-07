require("model.map.map")
require("model.role.role")

---@meta
botScript = {}

---@type Role
local curRole

---@type Map
local curMap

---@type Direction
local directionKey = Direction.right

---@type integer
local loopCount = 0

local function hitAndRunLoop()
    PressDirectionKey(directionKey)
    bot.delay(100,true)

    for i = 1, curMap.oneLoopStep do
        print("jump and hit: " .. i .. " -----------------")
        curRole:jumpAndHit(3)
        -- bot.delay(100)
    end

    KeyUp("")
    bot.delay(50)
    loopCount = loopCount + 1
    if (directionKey == Direction.left) then
        directionKey = Direction.right
    else
        directionKey = Direction.left
    end
end

---@param role Role
---@param map Map
function botScript.create(role, map)
    curRole = role
    curMap = map

    bot.delay(1000, true)
    while true do
        print("running time", bot.runningTime())
        hitAndRunLoop()
    end
end

return botScript
