dofile("model/map/map.lua")

CommonMap = Map:new()
CommonMap.miniMapEdgeInsets = EdgeInsets:new(0, 16, 0, 20)
CommonMap.summonPosition = Point:new(80, 100)