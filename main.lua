require("bot")
dofile("model/map/testMap.lua")
dofile("model/role/commonRole.lua")

local role = commonRole
local map = testMap

key_hid(0)

bot.start(role, map)

Loop()
