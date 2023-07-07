dofile("model/role/role.lua")

-- normal attack skill
local atkSkill = Skill:new()
atkSkill.key = "F"
atkSkill.backswing = 300

function atkSkill:cast()
    print('Attack skill: ', self.key)

    self.castedTime = os.clock()
    bot.pressKey(self.key, self.backswing, true)
    bot.pressKey("D", 300, true)

    return true
end

-- move skill, flash jump or blink
local jumpSkill = MultiJump:new()
jumpSkill.key = ";"
jumpSkill.backswing = 50
jumpSkill.maxTimes = 3

-- buff skill or buff potion
local buff1 = Skill:newWithArray({ "1", 190000, 0, 0, 850, 0, 0 })
local buff2 = Skill:newWithArray({ "2", 120000, 0, 0, 600, 0, 0 })
local buffSkills = { buff1, buff2 }

-- aoe skill
local skill1 = Skill:newWithArray({ "1", 190000, 0, 0, 850, 0, 0 })
local skill2 = Skill:newWithArray({ "2", 120000, 0, 0, 600, 0, 0 })
aoeSkills = { skill1, skill2 }

commonRole = Role:new()
commonRole.name = "shadower"
commonRole.mainAtkSkill = atkSkill
commonRole.moveSkill = jumpSkill
commonRole.buffSklls = buffSkills
-- testRole.aoeSkills = aoeSkills
commonRole.summonSkill = SummoningSkill:new()
-- testRole.showerSkill = ShowerSkill:new()
commonRole.teleportSkill = nil