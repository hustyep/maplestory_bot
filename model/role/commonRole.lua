dofile("model/role/role.lua")

-- normal attack skill
local atkSkill = Skill:new()
atkSkill.key = "F"
atkSkill.backswing = 300

function atkSkill:cast()
    -- print('Attack skill: ', self.key)

    self.castedTime = os.clock()
    bot.pressKey(self.key, self.backswing, true)
    bot.pressKey("D", 250, true)

    return true
end

-- move skill, flash jump or blink
local jumpSkill = MultiJump:new()
jumpSkill.key = ";"
jumpSkill.backswing = 50
jumpSkill.maxTimes = 3

local teleportSkill = TeleportSkill:new()
teleportSkill.key ="G"
teleportSkill.backswing = 1000

-- buff skill or buff potion
local buff1 = Skill:newWithArray({ "2", 120000, 0, 0, 800, 0, 0 })
local buff2 = Skill:newWithArray({ "L", 600000, 0, 0, 500, 0, 0 })
local buff3 = Skill:newWithArray({ "1", 900000, 0, 0, 600, 0, 0 })
-- local buff3 = Skill:newWithArray({ "2", 20000, 0, 0, 600, 0, 0 })

local buffSkills = { buff1, buff2, buff3 }

-- aoe skill
local skill1 = Skill:newWithArray({ "x", 190000, 0, 0, 850, 0, 0 })
local skill2 = Skill:newWithArray({ "c", 120000, 0, 0, 600, 0, 0 })
local aoeSkills = { skill1, skill2 }

CommonRole = Role:new()
CommonRole.name = "shadower"
CommonRole.mainAtkSkill = atkSkill
CommonRole.moveSkill = jumpSkill
CommonRole.buffSklls = buffSkills
CommonRole.aoeSkills = aoeSkills
CommonRole.summonSkill = SummoningSkill:new()
-- testRole.showerSkill = ShowerSkill:new()
CommonRole.teleportSkill = teleportSkill
CommonRole.horizontalVelocity = 13