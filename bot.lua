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
local scriptStatus = "running"

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

	-- local keysta = GetKeyState(VK("LCtrl"))
	-- if keysta >= 0 then
	-- 	return
	-- end


	if (v == VK('Pause')) then
		if scriptStatus == "running" then
			bot.pause()
		elseif scriptStatus == "paused" then
			bot.resume()
		end
	elseif v == VK('Scroll') then
		bot.stop()
	elseif v == VK('PrintScr') then
		if scriptStatus == "paused" then
			bot.restart()
		end
	end
end

local function runScript()
	print("bot start----------------------")
	local script = BotScript:new(nil, curRole, curMap)
	script:start(curRole, curMap)
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
			if scriptStatus == "running" then
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

local function checkRunningStatus()
	print("bot status:", scriptStatus)
end

local function checkKeyStatus()
	pauseKeySta=GetKeyState(VK("Pause"))
	stopKeySta=GetKeyState(VK("Scroll"))
	-- restartKeySta=GetKeyState(VK("Scroll"))

	if pauseKeySta < 0 then
		if scriptStatus == "running" then
			bot.pause()
		elseif scriptStatus == "paused" then
			bot.resume()
		end
	elseif stopKeySta < 0 then
		bot.stop()
	-- elseif v == VK('PrintScr') then
	-- 	if scriptStatus == "paused" then
	-- 		bot.restart()
	-- 	end
	end
end

---@param key string
---@param delay integer
---@param isAsync boolean | nil
function bot.pressKey(key, delay, isAsync)
	-- print("pressKey:", key, delay, isAsync)

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
	TimerLoopStart(checkKeyStatus, 500)
	-- RegKbEvent(onKeyboardEvent)
	coroutine.resume(botCo)
end

function bot.restart()
	key_hid(0)
	scriptStatus = "running"
	botCo = coroutine.create(runScript)
	bot.startTime = CurrentTime()
	coroutine.resume(botCo)
end

function bot.resume()
	key_hid(0)
	scriptStatus = "running"
	coroutine.resume(botCo)
end

function bot.pause()
	key_hid(0)
	scriptStatus = "paused"
end

function bot.stop()
	key_hid(0)
	scriptStatus = "stopped"
	error("stopped")
end

return bot
