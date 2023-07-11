require("model.classic")
require("model.skill.skill")
require("model.skill.moveSkill")

---@class Role: Object @role meta class
Role = {
    ---@type string
    roleName = "unknown",
    ---@type Skill @the normal attack skill
    mainAtkSkill = nil,
    ---@type MoveSkill
    moveSkill = nil,
    ---@type Skill[]
    buffSklls = {},
    ---@type Skill[]
    aoeSkills = {},
    ---@type SummonSkill | nil
    summonSkill = nil,
    ---@type Skill | nil
    preSummonSkill = nil,
    ---@type Skill | nil
    showerSkill = nil,
    ---@type TeleportSkill | nil @teleport skill, such as blink
    teleportSkill = nil,
    ---@type JumpUpSkill | nil
    jumpUpSkill = nil,
    ---@type RopeLiftSkill | nil
    ropeLiftSkill = nil,
    ---@type JumpDownSkill | nil
    jumpDownSkill = nil,
    ---@type string @the key of return scroll
    returnKey = "N",
    ---@type number
    horizontalVelocity = 14
}
setmetatable(Role, Object)
Role.__index = Role

function Role:new(o)
    local obj = o or {}
    setmetatable(obj, self)
    return obj
end

function Role:useBuffSkill()
    -- print("try user buff skill")
    for index, value in ipairs(self.buffSklls) do
        if value:cast() then
            break
        end
    end
end

function Role:jumpAndHit(jumpTimes)
    -- print("jump and hit")
    if self.moveSkill:is(MoveSkill) then
        local jumpSkill = MultiJump:new(self.moveSkill)
        jumpSkill:cast(jumpTimes)
    else
        print("wrong type")
        bot.delay(1000)
    end
    self.mainAtkSkill:cast()
end

function Role:say(text)
    bot.pressKey("Enter", 500)
    SayString(text)
    Sleep(200)
    bot.pressKey("Enter", 500)
end

---return to the nearest town and stop the script
function Role:returnTown()
    print("return town")

    bot.pause()
    Sleep(1000)
    bot.pressKey(self.returnKey, 500)
    bot.pressKey(self.returnKey, 500)
    bot.pressKey(self.returnKey, 500)
    bot.stop()
end
