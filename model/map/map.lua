require("spring")

---@class Map: Object @map meta class
Map = {
    name = "unknown",
    ---@type Rect
    miniMapFrame = nil,
    ---@type EdgeInsets
    miniMapEdgeInsets = EdgeInsetsZero,
    ---@type Point
    miniMapMyLocation = nil,
    ---@type Point
    summonPosition = nil,
    ---@type integer
    oneLoopMaxStep = 6,
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
    TimerLoopStart(function()
        self:locateMiniMap()
    end, 5000)
    -- TimerLoopStart(function()
    --     self:detectOtherPlayer()
    -- end, 1000)
    TimerLoopStart(function()
        self:locateSelf()
    end, 100)
end

---Locate the mini-map
---@return boolean success
function Map:locateMiniMap()
    local screenX, screenY = GetScreenResolution()
    local tlX, tlY = FindBmp('images\\topLeft.bmp', 0, 0, screenX / 2, screenY / 2)
    if (tlX < 0 or tlY < 0) then
        print('Cannot locate mini-map')
        return false
    end
    local brX, brY = FindBmp('images\\btmRight.bmp', tlX + 20, tlY + 20, screenX / 2, screenY / 2)
    if (brX < 0 or brY < 0) then
        print('Cannot locate mini-map')
        return false
    end

    local width = brX - tlX + 16
    local height = brY - tlY
    local origin = Point:new(tlX, tlY)
    local size = Size:new(width, height)
    self.miniMapFrame = Rect:new(origin, size)
    print('located mini map:', self.miniMapFrame)
    return true
end

---detect other players
---@return
---| -1   # failed.
---| 0    # safe
---| 1    # warnning
---| 2    # need stop
function Map:detectOtherPlayer()
    if self.miniMapFrame == nil then
        -- print("no mini map position")
        return -1
    end

    local redX, redY = FindBmpInRect('images\\red.bmp', self.miniMapFrame)
    local greyX, greyY = FindBmpInRect('images\\grey.bmp', self.miniMapFrame)
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

---comment
---@return Point | nil
function Map:locateSelf()
    if self.miniMapFrame == nil then
        print("no mini map position")
        return nil
    end

    local meX, meY = FindBmpInRect('images\\minimap_me.bmp', self.miniMapFrame)
    if (meX >= 0 and meY >= 0) then
        self.miniMapMyLocation = Point:new(meX - self.miniMapFrame.origin.x, meY - self.miniMapFrame.origin.y)
        -- print('my location:', self.miniMapMyLocation)
        if self:nearLeftEdge() then
            -- print("left corner!!!!!!!!!!!!!!!")
        elseif self:nearRightEdge() then
            -- print("right corner!!!!!!!!!!!!!!!")
        end
        return self.miniMapMyLocation
    else
        print('Cannot locate self')
        return nil
    end
end

---@return boolean
function Map:nearLeftEdge()
    return self.miniMapMyLocation.x - self.miniMapEdgeInsets.left <= 35
end

---comment
---@return boolean
function Map:nearRightEdge()
    return self.miniMapFrame.size.width - self.miniMapMyLocation.x - self.miniMapEdgeInsets.right <= 35
end
