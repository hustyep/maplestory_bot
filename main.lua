require("bot")
dofile("model/map/testMap.lua")
dofile("model/role/commonRole.lua")

local role = CommonRole
local map = CommonMap

key_hid(0)

bot.start(role, map)

Loop()
