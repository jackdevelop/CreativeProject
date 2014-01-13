--[[
登陆场景
]]
local BaseScene = require("engin.mvcs.view.BaseScene")
local LoginScene = class("LoginScene", BaseScene)



function BaseScene:ctor(param)
	
	local function updateCheckBoxButtonLabel(checkbox)
        local state = ""
        if checkbox:isButtonSelected() then
            state = "on"
        else
            state = "off"
        end
        if not checkbox:isButtonEnabled() then
            state = state .. " (disabled)"
        end
        checkbox:setButtonLabelString(string.format("state is %s", state))
    end

    checkBoxButton1 = cc.ui.UICheckBoxButton.new(TestUIButtonScene.CHECKBOX_BUTTON_IMAGES)
        :setButtonLabel(cc.ui.UILabel.new({text = "", size = 22,  color = ccc3(255, 96, 255)}))
        :setButtonLabelOffset(0, -40)
        :setButtonLabelAlignment(display.CENTER)
        :onButtonStateChanged(function(event)
            updateCheckBoxButtonLabel(event.target)
        end)
        :align(display.LEFT_CENTER, display.left + 40, display.top - 80)
        :addTo(self)
    updateCheckBoxButtonLabel(checkBoxButton1)
	
	
	
end



return LoginScene
