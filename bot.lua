require("spring")
require("botScript")

---@meta bot
bot = {}

---@type Role
local curRole

---@type Map
local curMap

---@type thread
local botCo

---@type
---| "running"   # running.
---| "paused"    # paused
---| "stopped"   # stopped
local ScriptStatus = "running"

bot.startTime = CurrentTime()

---keyboard event
---@param e
---| 0  # relased
---| 1  # pressed
---@param v integer @keyboard value
local function onKeyboardEvent(e, v)
	if e == 0 then
		-- print("key released", v)
		return
	end

	-- print("key pressed", v)

	if (v == VK('F2')) then
		bot.pause()
	elseif v == VK('F3') then
		bot.stop()
	elseif v == VK('F1') then
		bot.resume()
	end
end

local function runScript()
	print("bot start----------------------")
	botScript.create(curRole, curMap)
end

---@param milliseconds integer
---@param forceAsync boolean | nil
function bot.delay(milliseconds, forceAsync)
	if milliseconds <= 0 then
		return
	end
	forceAsync = forceAsync or false
	if milliseconds > 80 or forceAsync == true then
		TimerStart(function()
			if ScriptStatus == "running" then
				bot.resume()
			else
				key_hid(0)
			end
		end, milliseconds - 65
		)
		coroutine.yield()
	else
		Sleep(milliseconds)
	end
end

---@param key string
---@param delay integer
---@param isAsync boolean | nil
function bot.pressKey(key, delay, isAsync)
	print("pressKey:", key, delay, isAsync)

	KeyPress(key)
	isAsync = isAsync or true
	if isAsync then
		bot.delay(delay)
	else
		Sleep(delay)
	end
end

function bot.runningTime()
	return CurrentTime() - bot.startTime
end

---@param role Role
---@param map Map
function bot.start(role, map)
	curRole = role
	curMap = map
	botCo = coroutine.create(runScript)
	bot.startTime = CurrentTime()

	-- map:locateMiniMap()
	map:startDetactPlayer()
	TimerLoopStart(checkRunningStatus, 5000)
	RegKbEvent(onKeyboardEvent)
	coroutine.resume(botCo)
end

function bot.resume()
	key_hid(0)
	ScriptStatus = "running"
	coroutine.resume(botCo)
end

function bot.pause()
	key_hid(0)
	ScriptStatus = "paused"
end

function bot.stop()
	key_hid(0)
	ScriptStatus = "stopped"
	error("stopped")
end

function checkRunningStatus()
	print("bot status:", ScriptStatus)
end

return bot
