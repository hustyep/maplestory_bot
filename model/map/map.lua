
---@class Map: Object @map meta class
Map = {
    name = "unknown",
    miniMapX = 0,
    miniMapY = 0,
    miniMapWidth = 160,
    miniMapHeight = 90,
    miniMapMeX = 0,
    miniMapMeY = 0,
    floors = 3,
    ---@type integer
    oneLoopStep = 3,
    ---@type integer
    detectCount = 0,
    ---@type integer
    noDetectCount = 0,
}
setmetatable(Map, Object)
Map.__index = Map

function Map:new(o)
    local obj = o or {}
    setmetatable(obj, self)

    return obj
end

function Map:startDetactPlayer()
    self:locateMiniMap()
    TimerLoopStart(function ()
        self:locateMiniMap()
    end, 5000)
    TimerLoopStart(function ()
        self:detectOtherPlayer()
    end, 1000)
    TimerLoopStart(function ()
        self:locateSelf()
    end, 100)
end

---Locate the mini-map
---@return boolean success
function Map:locateMiniMap()
    local screenX, screenY = GetScreenResolution()
    local tlX, tlY = FindBmp('images\\topLeft.bmp', 0, 0, screenX, screenY)
    if (tlX < 0 or tlY < 0) then
        print('Cannot locate mini-map')
        return false
    else
        self.miniMapX, self.miniMapY = tlX, tlY
        print('located mini map:', self.miniMapX, self.miniMapY)
        return true
    end
end

---detect other players
---@return
---| -1   # failed.
---| 0    # safe
---| 1    # warnning
---| 2    # need stop
function Map:detectOtherPlayer()
    if self.miniMapX == nil or self.miniMapY == nil then
        -- print("no mini map position")
        return -1
    end

    local redX, redY = FindBmp('images\\red.bmp',
        self.miniMapX,
        self.miniMapY,
        self.miniMapX + self.miniMapWidth,
        self.miniMapY + self.miniMapHeight)
    local greyX, greyY = FindBmp('images\\grey.bmp',
        self.miniMapX,
        self.miniMapY,
        self.miniMapX + self.miniMapWidth,
        self.miniMapY + self.miniMapHeight)
    if (redX >= 0 or greyX >= 0) then
        self.detectCount = self.detectCount + 1
        self.noDetectCount = 0
        print('Warning! Other players detected!', self.etectCount)
    else
        self.noDetectCount = self.noDetectCount + 1
        if (self.noDetectCount <= 10) then
            -- print('No detection', self.noDetectCount)
        end
    end

    if (self.noDetectCount == 10) then
        self.etectCount = 0 -- After a certain time, reset detectCount
        print('Reset detectCount')
        return 0
    elseif (self.detectCount >= 20) then
        return 2
    elseif (self.detectCount >= 10) then
        return 1
    else
        return 0
    end
end

function Map:locateSelf()
    if self.miniMapX == nil or self.miniMapY == nil then
        print("no mini map position")
        return -1
    end

    local meX, meY = FindBmp('images\\minimap_me.bmp',
        self.miniMapX,
        self.miniMapY,
        self.miniMapX + self.miniMapWidth,
        self.miniMapY + self.miniMapHeight)
    if (meX >= 0 and meY >= 0) then
        print('my location:', meX, meY)
        self.miniMapMeX, self.miniMapMeY = meX, meY
        return meX, meY
    else
        -- print('Cannot locate self')
        return -1, -1
    end
end