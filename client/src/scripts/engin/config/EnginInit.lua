--初始化静态类
UrlConfig = require("engin.config.UrlConfig")
SceneConstants = require("engin.config.SceneConstants")
AnimationProperties = require("engin.config.AnimationProperties") -- game的app中可以直接重写覆盖此类





--初始化全局类
HttpLoad = require("engin.mvcs.service.HttpLoad").new()
HttpLoadResultHandle = require("engin.mvcs.service.HttpLoadResultHandle").new()



FilterText = require("engin.components.FilterText").new();
AtlasText  = require("engin.components.AtlasText").new();
BubbleButton =  require("engin.components.BubbleButton").new();