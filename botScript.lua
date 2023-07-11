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

    positionTolerance = 10,
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

function BotScript:start()
    assert(self.curRole, "role is nil")
    assert(self.curMap, "map is nil")

    while true do
        print("loop Count:", self.loopCount, bot.runningTime())
        assert(self.curMap.miniMapFrame, "frame of minimap is nil")
        assert(self.curMap.miniMapMyLocation, "my location is nil")
        self:hitAndRunLoop()
    end
end

function BotScript:hitAndRunLoop()
    PressDirectionKey(self.curDirection)
    bot.delay(200, true)
    self.curRole:useBuffSkill()
    self:tryUseSummonSkill()

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
        self:tryUseAoeSkill()
        PressDirectionKey(self.curDirection)
        self.curRole:jumpAndHit(3)
        self:tryUseAoeSkill()
    end

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

---@param point Point @coordinate of target location in mini map
---@return boolean success
function BotScript:moveToPosition(point)
    assert(self.curMap.miniMapMyLocation, "my location is nil")
    print("move to postion", point)

    if self.curRole.moveSkill == nil then
        self:walkTo(point.x)
    else
        self:jumpTo(point.x)
    end

    if point.y > self.curMap.miniMapMyLocation.y then
        self:moveUp(point.y)
    elseif point.y < self.curMap.miniMapMyLocation.y then
        self:moveDown(point.y)
    end

    return true
end

---@param x number
function BotScript:walkTo(x)
    assert(self.curRole.horizontalVelocity > 0, "horizontal velocity is zero")

    local distanceX = x - self.curMap.miniMapMyLocation.x
    local direction = Direction.right
    if distanceX < 0 then
        direction = Direction.left
        distanceX = math.abs(distanceX)
    end

    local seconds = distanceX / self.curRole.horizontalVelocity
    if direction == self.curDirection then
        if seconds > 1 then
            seconds = seconds - 1
        end
    else
        -- 减去转身时间
        seconds = seconds + 1
    end
    self.curDirection = direction
    PressDownDirectionKey(direction)
    bot.delay(math.ceil(seconds * 1000), true)
    KeyUp("")
end

---@param x number
function BotScript:jumpTo(x)
    assert(self.curRole.moveSkill.unitDistance > 0, "unitDistance is 0")

    local distanceX = x - self.curMap.miniMapMyLocation.x
    local direction = Direction.right
    if distanceX < 0 then
        direction = Direction.left
        distanceX = math.abs(distanceX)
    end
    print("distanceX, direction", distanceX, direction)

    local count = distanceX / self.curRole.moveSkill.unitDistance
    if count > 0 then
        for i = 1, count do
            self.curRole:jumpAndHit(3)
        end
    end

    self.curMap:locateSelf()
    self:walkTo(x)
end

function BotScript:moveUp(y)
    if self.curRole.teleportSkill ~= nil and self.curRole.teleportSkill:canUse() then
        self.curRole.teleportSkill:cast(Direction.top, 30)
        return true
    elseif self.curRole.ropeLiftSkill ~= nil and self.curRole.ropeLiftSkill:canUse() then
        self.curRole.ropeLiftSkill:cast(false)
        return true
    elseif self.curRole.jumpUpSkill ~= nil and self.curRole.jumpUpSkill:canUse() then
        self.curRole.jumpUpSkill:cast(false)
        return true
    end
    return false
end

function BotScript:moveDown(y)
    assert(self.curRole.jumpDownSkill, "jump down skill is nil")
    self.curRole.jumpDownSkill:cast()
    self.curMap:locateSelf()
    if self.curMap.miniMapMyLocation.y > y then
        self:moveDown(y)
    end
end

function BotScript:tryUseSummonSkill()
    if self.curMap.summonPosition == nil or self.curRole.summonSkill == nil then
        return false
    end

    if self.curRole.summonSkill:canUse(8000) then
        if self.curMap.preSummonPosition and self.curRole.preSummonSkill then
            self:moveToPosition(self.curMap.summonPosition)
            self.curRole.preSummonSkill:cast()
        end

        self:moveToPosition(self.curMap.summonPosition)
        self.curRole.summonSkill:cast()

        return true
    end

    return false
end

---@return boolean
function BotScript:tryUseAoeSkill()
    local canUse = false
    for index, value in ipairs(self.curMap.aoePositions) do
        if math.abs(value.x - self.curMap.miniMapMyLocation.x) <= self.positionTolerance and
            math.abs(value.y - self.curMap.miniMapMyLocation.y) <= self.positionTolerance then
                canUse = true
                break
        end
    end

    if canUse == false then
        return false
    end

    for index, value in ipairs(self.curRole.aoeSkills) do
        if value:cast() then
            return true
        end
    end

    return false
end

return BotScript
