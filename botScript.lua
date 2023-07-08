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
    bot.delay(100, true)
    PressDirectionKey(self.curDirection)
    bot.delay(100, true)
    self.curRole:useBuffSkill()

    while true do
        if self.curDirection == Direction.right then
            if self.curMap:nearRightEdge() then
                break
            end
        elseif self.curDirection == Direction.left then
            if self.curMap:nearLeftEdge() then
                break
            end
        end
        self.curRole:jumpAndHit(3)
    end

    -- for i = 1, self.curMap.oneLoopStep do
    --     -- print("jump and hit: " .. i .. " -----------------")
    --     self.curRole:jumpAndHit(3)
    -- end

    KeyUp("")
    -- key_hid(0)
    bot.delay(100, true)
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
