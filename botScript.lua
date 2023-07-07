require("model.map.map")
require("model.role.role")

---@class BotScript: Object
BotScript = {
    ---@type Role
    curRole = nil,

    ---@type Map
    curMap = nil,

    ---@type Direction
    curDirection = Direction.right,

    ---@type integer
    loopCount = 0,
}
setmetatable(BotScript, Object)
BotScript.__index = BotScript

---comment
---@param o table | nil
---@param role Role
---@param map Map
function BotScript:new(o, role, map)
    local obj = o or {}
    setmetatable(obj, self)
    obj.curRole = role
    obj.curMap = map
    return obj
end

function BotScript:hitAndRunLoop()
    PressDirectionKey(self.curDirection)
    bot.delay(100, true)
    self.curRole:useBuffSkill()

    for i = 1, self.curMap.oneLoopStep do
        print("jump and hit: " .. i .. " -----------------")
        self.curRole:jumpAndHit(3)
        -- bot.delay(100)
    end

    KeyUp("")
    bot.delay(50)
    self.loopCount = self.loopCount + 1
    if (self.curDirection == Direction.left) then
        self.curDirection = Direction.right
    else
        self.curDirection = Direction.left
    end
end

---@param role Role
---@param map Map
function BotScript:start(role, map)
    self.curRole = role
    self.curMap = map

    bot.delay(1000, true)
    while true do
        print("loop Count:", self.loopCount, bot.runningTime())
        self:hitAndRunLoop()
    end
end

return BotScript
