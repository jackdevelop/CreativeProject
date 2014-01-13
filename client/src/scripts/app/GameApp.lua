
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

require("engin.config.EnginInit")


local UIDemoApp = class("UIDemoApp", cc.mvc.AppBase)




function UIDemoApp:ctor()
    UIDemoApp.super.ctor(self)
end






function UIDemoApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    self:enterScene(SceneConstants.LoginScene)
end






--[[
进入某个场景
]]
function UIDemoApp:enterScene(sceneName, ...)
    self.currentSceneName_ = sceneName
    UIDemoApp.super.enterScene(self, sceneName, ...)
end

return UIDemoApp
