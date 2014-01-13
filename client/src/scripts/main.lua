
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end


--自己这里定义
CCLuaLoadChunksFromZIP("res/script/framework_precompiled.zip")


require("app.GameApp").new():run()
