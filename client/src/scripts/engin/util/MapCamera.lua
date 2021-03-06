--[[
 	MapCamera
 	public ->> 全局公开类
 	
	场景的摄像机管理
 
 
 * @author  jackdevelop@sina.com
 * $Id:$
 * @version 1.0
]]
local MapCamera = class("MapCamera")

function MapCamera:ctor(map)
    self.map_           = map

    self.zooming_       = false
    self.scale_         = 1
    self.actualScale_   = 1
    self.offsetX_       = 0
    self.offsetY_       = 0
    self.offsetLimit_   = nil
    self.margin_        = {top = 0, right = 0, bottom = 0, left = 0}


	
	--最小  最大放大倍数
    local width, height = map:getSize() --地图的尺寸
    local minScaleV     = display.height / height
    local minScaleH     = display.width / width
    
    
    local minScale      = minScaleV
    if minScaleH > minScale then minScale = minScaleH end
    self.minScale_ = minScale
    
    self.maxScale_ = 99 --最大默认为99
end






--[[
设置最大缩放比
@param float scale
@return float
]]
function MapCamera:setMaxScale(scale)
    self.maxScale_ = scale
end

--[[
获取最小缩放比
@return float
]]
function MapCamera:getMinScale()
    return self.minScale_
end

--[[
获取最大缩放比
@return float
]]
function MapCamera:getMaxScale()
    return self.maxScale_
end




--[[
返回地图的边空
]]
function MapCamera:getMargin()
    return clone(self.margin_)
end



--[[
获取当前地图的尺寸
@return mapWidth, mapHeight
]]
function MapCamera:getMapSize()
    local mapWidth, mapHeight = self.map_:getSize()
    return mapWidth, mapHeight
end
--function MapCamera:setCenter()
--	local mapWidth, mapHeight = self:getMapSize();
--	self:moveTo(mapWidth* self.scale_ /2,mapHeight* self.scale_ /2)
--	 --self:resetOffsetLimit()
--end





--[[--
设置地图卷动的边空
]]
function MapCamera:setMargin(top, right, bottom, left)
    if self.zooming_ then return end

    if type(top)    == "number" then self.margin_.top = top end
    if type(right)  == "number" then self.margin_.right = right end
    if type(bottom) == "number" then self.margin_.bottom = bottom end
    if type(left)   == "number" then self.margin_.left = left end
    self:resetOffsetLimit()
end


--[[--
返回地图当前的缩放比例
]]
function MapCamera:getScale()
    return self.scale_
end



--[[--
设置地图当前的缩放比例
]]
function MapCamera:setScale(scale)
    if self.zooming_ then return end

    self.scale_ = scale
    if scale < self.minScale_ then scale = self.minScale_ end
    self.actualScale_ = scale
    self:resetOffsetLimit()
    self:setOffset(self.offsetX_, self.offsetY_)

    local backgroundLayer = self.map_:getBackgroundLayer()
    local batchLayer      = self.map_:getBatchLayer()
    local flysLayer      = self.map_:getFlysLayer()
    local debugLayer      = self.map_:getDebugLayer()
    local floorsLayer    = self.map_:getFloorsLayer()
    local sceneLayer    = self.map_:getSceneLayer()

	if backgroundLayer then	backgroundLayer:setScale(scale)   end
    if batchLayer then batchLayer:setScale(scale) end
    if flysLayer then flysLayer:setScale(scale) end
    if debugLayer then debugLayer:setScale(scale) end
     if floorsLayer then floorsLayer:setScale(scale) end
      if sceneLayer then sceneLayer:setScale(scale) end
     
end

--[[--

动态调整摄像机的缩放比例

]]
function MapCamera:zoomTo(scale, x, y)
    self.zooming_ = true
    self.scale_ = scale
    if scale < self.minScale_ then scale = self.minScale_ end
    self.actualScale_ = scale
    self:resetOffsetLimit()

    local backgroundLayer = self.map_:getBackgroundLayer()
    local batchLayer      = self.map_:getBatchLayer()
    local flysLayer      = self.map_:getFlysLayer()
    local debugLayer      = self.map_:getDebugLayer()
      local floorsLayer    = self.map_:getFloorsLayer()

    if backgroundLayer then transition.removeAction(self.backgroundLayerAction_) end
    if batchLayer then transition.removeAction(self.batchLayerAction_) end
    if flysLayer then transition.removeAction(self.marksLayerAction_) end
    if debugLayer then transition.stopTarget(debugLayer)  end
     if floorsLayer then transition.stopTarget(floorsLayer)  end
     

  	if backgroundLayer then  self.backgroundLayerAction_ = transition.scaleTo(backgroundLayer, {scale = scale, time = MapConstants.ZOOM_TIME}) end
  	if batchLayer then  self.batchLayerAction_ = transition.scaleTo(batchLayer, {scale = scale, time = MapConstants.ZOOM_TIME})  end
    if flysLayer then  self.marksLayerAction_ = transition.scaleTo(flysLayer, {scale = scale, time = MapConstants.ZOOM_TIME})  end
     if floorsLayer then  self.marksLayerAction_ = transition.scaleTo(floorsLayer, {scale = scale, time = MapConstants.ZOOM_TIME})  end
   
   
    if debugLayer then transition.scaleTo(debugLayer, {scale = scale, time = MapConstants.ZOOM_TIME})  end
     

    if type(x) ~= "number" then return end

    if x < self.offsetLimit_.minX then
        x = self.offsetLimit_.minX
    end
    if x > self.offsetLimit_.maxX then
        x = self.offsetLimit_.maxX
    end
    if y < self.offsetLimit_.minY then
        y = self.offsetLimit_.minY
    end
    if y > self.offsetLimit_.maxY then
        y = self.offsetLimit_.maxY
    end

    local x, y = display.pixels(x, y)
    self.offsetX_, self.offsetY_ = x, y

    if backgroundLayer then  transition.moveTo(backgroundLayer, {x = x,y = y,time = MapConstants.ZOOM_TIME,onComplete = function() self.zooming_ = false end }) end
    if batchLayer then  transition.moveTo(batchLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME}) end
    if flysLayer then  transition.moveTo(flysLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME}) end
    if floorsLayer then  transition.moveTo(floorsLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME})  end
    if debugLayer then  transition.moveTo(debugLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME})  end
end

--[[--

返回地图当前的卷动偏移量

]]
function MapCamera:getOffset()
    return self.offsetX_, self.offsetY_
end

--[[--

设置地图卷动的偏移量

]]
function MapCamera:setOffset(x, y, movingSpeed, onComplete)
    if self.zooming_ then return end


	local backgroundLayer = self.map_:getBackgroundLayer()
    local batchLayer      = self.map_:getBatchLayer()
    local flysLayer      = self.map_:getFlysLayer()
    local debugLayer      = self.map_:getDebugLayer()
    local floorsLayer    = self.map_:getFloorsLayer()

	
	
    if x < self.offsetLimit_.minX then
        x = self.offsetLimit_.minX
    end
    if x > self.offsetLimit_.maxX then
        x = self.offsetLimit_.maxX
    end
    if y < self.offsetLimit_.minY then
        y = self.offsetLimit_.minY
    end
    if y > self.offsetLimit_.maxY then
        y = self.offsetLimit_.maxY
    end



    local x, y = display.pixels(x, y)
    self.offsetX_, self.offsetY_ = x, y
    if backgroundLayer then
        transition.stopTarget(backgroundLayer)
    end
    if batchLayer then
        transition.stopTarget(batchLayer)
    end
     if flysLayer then
        transition.stopTarget(flysLayer)
    end
     if floorsLayer then
        transition.stopTarget(floorsLayer)
    end
    if debugLayer then
        transition.stopTarget(debugLayer)
    end
    
    
    
    
    if type(movingSpeed) == "number" and movingSpeed > 0 then
        local function moveLayer(oneLayer)
	    	 transition.moveTo(oneLayer, {
	            x = x,
	            y = y,
	            time = movingSpeed,
	            onComplete = onComplete
	        })
	    end
        
        moveLayer(backgroundLayer)
        moveLayer(batchLayer)
        moveLayer(flysLayer)
        moveLayer(floorsLayer)
        moveLayer(debugLayer)
    else
        if backgroundLayer then  self.map_:getBackgroundLayer():setPosition(x, y) end
        if batchLayer then  batchLayer:setPosition(x, y) end
        if flysLayer then flysLayer:setPosition(x, y) end
        if floorsLayer then floorsLayer:setPosition(x, y) end
        if debugLayer then debugLayer:setPosition(x, y) end
    end
end

--[[--

移动指定的偏移量

]]
function MapCamera:moveOffset(offsetX, offsetY, movingSpeed)
    self:setOffset(self.offsetX_ + offsetX, self.offsetY_ + offsetY, movingSpeed)
end

--[[--
移动到指定的位置
]]
function MapCamera:moveTo(positionX, positionY)
    self:setOffset(positionX, positionY)
end

--[[--

返回地图的卷动限制

]]
function MapCamera:getOffsetLimit()
    return clone(self.offsetLimit_)
end

--[[--

更新地图的卷动限制

]]
function MapCamera:resetOffsetLimit()
    local mapWidth, mapHeight = self.map_:getSize()
    self.offsetLimit_ = {
        minX = display.width - self.margin_.right - mapWidth * self.actualScale_,
        maxX = self.margin_.left,
        minY = display.height - self.margin_.top - mapHeight * self.actualScale_,
        maxY = self.margin_.bottom,
    }
end











--[[--

将屏幕坐标转换为地图坐标

]]
function MapCamera:convertToMapPosition(x, y)
    return (x - self.offsetX_) / self.actualScale_, (y - self.offsetY_) / self.actualScale_
end

--[[--

将地图坐标转换为屏幕坐标

]]
function MapCamera:convertToWorldPosition(x, y)
    return x * self.actualScale_ + self.offsetX_, y * self.actualScale_ + self.offsetY_
end

--[[--

将指定的地图坐标转换为摄像机坐标

]]
function MapCamera:convertToCameraPosition(x, y)
    local left = -(x - (display.width - self.margin_.left - self.margin_.right) / 2)
    local bottom = -(y - (display.height - self.margin_.top - self.margin_.bottom) / 2)
    return left, bottom
end

return MapCamera
