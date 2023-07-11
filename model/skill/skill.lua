require("model.classic")
require("model.commonModel")

JumpKey = "S"

---@class Skill: Object @skill meta class
Skill = {
    ---@type string
    key = "F",
    ---@type integer @milliseconds
    cooldown = 0,
    ---@type integer @milliseconds
    castedTime = 0,
    ---@type integer @milliseconds
    precast = 0,
    ---@type integer @milliseconds
    backswing = 500,
}
setmetatable(Skill, Object)
Skill.__index = Skill

function Skill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    return obj
end

---@param array table
---@return Skill
function Skill:newWithArray(array)
    local o = Skill:new()
    o.key = array[1]
    o.cooldown = array[2]
    o.castedTime = array[3]
    o.precast = array[4]
    o.backswing = array[5]
    o.castX = array[6]
    o.castY = array[7]

    return o
end

---@param milliseconds integer | nil
---@return boolean
function Skill:canUse(milliseconds)
    if self.cooldown == 0 or self.castedTime == 0 then
        return true
    end

    milliseconds = milliseconds or 0
    if CurrentTime() - self.castedTime - milliseconds < self.cooldown then
        print('try cast skill failed: ', self.key, 'cooling')
        return false
    end

    -- if point == nil then
    --     return true
    -- end
    -- if self.castPoint ~= nil then
    --     if math.abs(point.x - self.castPoint.x) > self.castTolerance or math.abs(point.y - self.castPoint.y) > self.castTolerance then
    --         print('try cast skill failed: ', self.key, ' position')
    --         return false
    --     end
    -- end
    return true
end

---@return boolean success
function Skill:cast()
    -- print('try cast skill: ', self.key)
    if self:canUse() == false then
        return false
    end

    print('begin cast skill: ' .. self.key)
    bot.delay(self.precast)
    self.castedTime = CurrentTime()
    KeyPress(self.key)
    bot.delay(self.backswing)
    -- print('cast skill end: ' .. self.key)

    return true
end

-- 职业放置技能
---@class SummonSkill: Skill @summon skill meta class
SummonSkill = {}
setmetatable(SummonSkill, Skill)
SummonSkill.__index = SummonSkill

function SummonSkill:new(o)
    o = o or {}
    setmetatable(o, self)
    o.key = "w"
    o.precast = 500
    o.backswing = 800
    return o
end

-- 艾尔达放置技能
ShowerSkill = Skill:new()

function ShowerSkill:new(o)
    o = o or Skill:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function ShowerSkill:cast(x, y)
    print('try cast shower skill')
    if os.clock() - self.castedTime < self.cooldown and self.castedTime ~= 0 then
        print('try cast skill: ' .. self.key .. ' time fail')
        return false
    end

    if math.abs(x - self.castX) > self.castToleranceX or math.abs(y - self.castY) > self.castToleranceY then
        print('try cast skill: ' .. self.key .. ' position fail')
        return false
    end

    Sleep(self.precast)
    KeyDown("down")
    self.castedTime = os.clock()
    KeyPress(self.key)
    KeyUp("down")
    Sleep(self.backswing)

    return true
end
