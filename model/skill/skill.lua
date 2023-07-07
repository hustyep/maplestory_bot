require("model.classic")

JumpKey = "S"

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

---按下方向键
---@param direction Direction
function PressDirectionKey(direction)
    for i, v in ipairs(direction) do
        -- print("press direction:", direction)
        KeyDown(v)
    end
end

---@class Skill: Object @skill meta class
Skill = {
    ---@type string
    key = "F",
    ---@type integer @milliseconds
    cooldown = 60000,
    ---@type integer @milliseconds
    castedTime = 0,
    ---@type integer @milliseconds
    precast = 0,
    ---@type integer @milliseconds
    backswing = 500,
    ---@type integer
    castX = 0,
    ---@type integer
    castY = 0,
    castToleranceX = 10,
    castToleranceY = 10,
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

---@param x integer | nil
---@param y integer | nil
---@return boolean
function Skill:canUse(x, y)
    if self.cooldown > 0 then
        if CurrentTime() - self.castedTime < self.cooldown and self.castedTime ~= 0 then
            print('try cast skill failed: ', self.key, 'cooling')
            return false
        end
    end

    if self.castX ~= 0 and self.castY ~= 0 then
        if math.abs(x - self.castX) > self.castToleranceX or math.abs(y - self.castY) > self.castToleranceY then
            print('try cast skill failed: ', self.key, ' position')
            return false
        end
    end
    return true
end

---comment
---@param x integer | nil
---@param y integer | nil
---@return boolean success
function Skill:cast(x, y)
    print('try cast skill: ', self.key, x, y)
    x = x or 0
    y = y or 0

    if self:canUse(x, y) == false then
        return false
    end

    print('begin cast skill: ' .. self.key)
    bot.delay(self.precast)
    self.castedTime = CurrentTime()
    KeyPress(self.key)
    bot.delay(self.backswing)
    print('cast skill end: ' .. self.key)

    return true
end

-- 职业放置技能
SummoningSkill = Skill:new()

function SummoningSkill:new(o)
    o = o or Skill:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

-- 放置技能
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
