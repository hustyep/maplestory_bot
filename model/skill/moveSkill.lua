require("model.skill.skill")
require("math")

---@class MoveSkill: Skill @移动技能
MoveSkill = {
    ---@type number
    unitDistance = 0,
}
setmetatable(MoveSkill, Skill)
MoveSkill.__index = MoveSkill

function MoveSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    return obj
end

function MoveSkill:cast()
    print('MoveSkill', self.key)

    -- bot.delay(self.precast)
    -- self.castedTime = os.clock()
    -- KeyPress(self.key)
    -- bot.delay(self.backswing)

    return true
end

---@class MultiJump: MoveSkill @二段跳或者三段跳
MultiJump = {
    ---@type integer 最大次数
    maxJumpTimes = 2
}
setmetatable(MultiJump, MoveSkill)
MultiJump.__index = MultiJump

function MultiJump:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    obj.unitDistance = 20
    return obj
end

---comment
---@param jumpTimes integer | nil
---@return boolean
function MultiJump:cast(jumpTimes)
    jumpTimes = jumpTimes or self.maxJumpTimes
    -- print("MultiJump", self.key, jumpTimes)

    KeyPress(JumpKey)
    KeyPress(self.key)
    -- bot.pressKey(JumpKey, 50, true)
    -- bot.pressKey(self.key, 30)

    if jumpTimes == 3 then
        bot.pressKey(self.key, 30)
    end

    return true
end

---@class TeleportSkill: MoveSkill @位移技能
TeleportSkill = {
    ---@type integer
    maxStackTimes = 1,
    ---@type integer
    usableTimes = 1,
}
setmetatable(TeleportSkill, MoveSkill)
TeleportSkill.__index = TeleportSkill

function TeleportSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    obj.unitDistance = 60
    return obj
end

function TeleportSkill:canUse()
    if self.castedTime == 0 or self.usableTimes > 0 then
        return true
    end
    if CurrentTime() - self.castedTime >= self.cooldown then
        return true
    end
    return false
end

---comment
---@param direction Direction
---@param jumpDelay number
---@return boolean
function TeleportSkill:cast(direction, jumpDelay)
    print('TeleportSkill', direction)

    if self:canUse() == false then
        return false
    end

    if self.usableTimes <= 0 then
        self.usableTimes = self.maxStackTimes
    end
    self.usableTimes = self.usableTimes - 1

    jumpDelay  = jumpDelay or 0

    bot.delay(self.precast)
    KeyPress(JumpKey)
    if jumpDelay > 0 then
        Sleep(jumpDelay)
    end
    self.castedTime = CurrentTime()
    PressDownDirectionKey(direction)
    Sleep(50)
    KeyPress(self.key)
    KeyUp("")
    bot.delay(self.backswing)

    return true
end

---@class JumpUpSkill: MoveSkill @位移技能
JumpUpSkill = {}
setmetatable(JumpUpSkill, MoveSkill)
JumpUpSkill.__index = JumpUpSkill

function JumpUpSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    obj.unitDistance = 40
    obj.key = JumpKey
    return obj
end

function JumpUpSkill:cast(needJump)
    print('begin cast skill: ' .. self.key)
    bot.delay(self.precast)
    self.castedTime = CurrentTime()
    if needJump then
        KeyPress(JumpKey)
    end
    KeyPress(self.key)
    bot.delay(self.backswing)
end

---@class RopeLiftSkill: MoveSkill @位移技能
RopeLiftSkill = {}
setmetatable(RopeLiftSkill, MoveSkill)
RopeLiftSkill.__index = RopeLiftSkill

function RopeLiftSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    obj.unitDistance = 40
    obj.key = JumpKey
    return obj
end

---@param needJump boolean
---@param stopDelay integer | nil
---@return boolean
function RopeLiftSkill:cast(needJump, stopDelay)
    print('begin cast skill: ' .. self.key)

    if self:canUse() == false then
        return false
    end

    bot.delay(self.precast)
    self.castedTime = CurrentTime()
    if needJump then
        KeyPress(JumpKey)
    end
    KeyPress(self.key)
    if stopDelay ~= nil then
        bot.delay(stopDelay)
        KeyPress(self.key)
    end
    bot.delay(self.backswing)

    return true
end

---@class JumpDownSkill: MoveSkill @位移技能
JumpDownSkill = {}
setmetatable(JumpDownSkill, MoveSkill)
JumpDownSkill.__index = JumpDownSkill

function JumpDownSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    obj.backswing = 800
    obj.key = JumpKey
    return obj
end

function JumpDownSkill:cast()
    bot.delay(self.precast)
    self.castedTime = CurrentTime()
    PressDownDirectionKey(Direction.down)
    Sleep(30)
    KeyPress(self.key)
    KeyUp("")
    bot.delay(self.backswing)

    return true
end
