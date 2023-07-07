require("model.skill.skill")
require("math")

---@class MoveSkill: Skill @位移技能
MoveSkill = {}
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
    return obj
end

---comment
---@param jumpTimes integer | nil
---@return boolean
function MultiJump:cast(jumpTimes)
    jumpTimes = jumpTimes or self.maxJumpTimes
    print("MultiJump", self.key, jumpTimes)

    self.castedTime = os.clock()
    bot.pressKey(JumpKey, 30, true)
    bot.pressKey(self.key, 30, true)

    if jumpTimes == 3 then
        bot.pressKey(self.key, 30, true)
    end

    return true
end