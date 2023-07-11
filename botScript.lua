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

---@param role Role
---@param map Map
function BotScript:start(role, map)
    self.curRole = role
    self.curMap = map

    -- bot.delay(3000, true)
    -- self:moveToPosition(50, 0)
    while true do
        print("loop Count:", self.loopCount, bot.runningTime())
        self:hitAndRunLoop()
    end
end

function BotScript:hitAndRunLoop()
    PressDirectionKey(self.curDirection)
    bot.delay(200, true)
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
        PressDirectionKey(self.curDirection)
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

---comment
---@param x integer @x coordinate of target location in mini map
---@param y integer @y coordinate of target location in mini map
---@return boolean success
function BotScript:moveToPosition(x, y)
    if self.curMap.miniMapMyLocation == nil then
        return false
    end
    print("move to postion", x, y)
    local distanceX = x - self.curMap.miniMapMyLocation.x
    local direction = Direction.right
    if distanceX < 0 then
        direction = Direction.left
    end
    local seconds = math.abs(distanceX) / self.curRole.horizontalVelocity
    print("distanceX, seconds", distanceX, seconds)
    if direction == self.curDirection then
        if seconds > 1 then
            seconds = seconds - 1
        end
    else
        seconds = seconds + 1
    end

    self.curDirection = direction
    print("start time:", bot.runningTime())
    PressDownDirectionKey(direction)
    bot.delay(math.ceil(seconds * 1000), true)
    print("end time1:", bot.runningTime())
    KeyUp("")
    print("end time2:", bot.runningTime())
    self.curRole.teleportSkill:cast(Direction.top, true)

    return true
end

return BotScript
