require("model.skill.skill")

---@class TeleportSkill: Skill @位移技能
TeleportSkill = {}
setmetatable(TeleportSkill, Skill)
TeleportSkill.__index = TeleportSkill

function TeleportSkill:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    return obj
end

---comment
---@param direction Direction
---@param needJump boolean | nil
---@return boolean
function TeleportSkill:cast(direction, needJump)
    print('TeleportSkill', direction)

    if self:canUse() == false then
        return false
    end

    needJump  = needJump or false

    bot.delay(self.precast)
    if needJump then
        KeyPress(JumpKey)
    end
    self.castedTime = os.clock()
    PressDownDirectionKey(direction)
    Sleep(50)
    KeyPress(self.key)
    KeyUp("")
    bot.delay(self.backswing)

    return true
end