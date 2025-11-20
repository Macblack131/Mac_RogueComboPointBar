local function OnSettingChanged(setting, value)
    if setting:GetVariable() == "resetSettings" then
        Mac_RogueComboPointBarFrame:ResetPosition()
    end
end

local function CreateSettings()

    local category = Settings.RegisterVerticalLayoutCategory("Mac_RogueComboPointBar")

    do
        local variable = "isLock"
        local name = "Lock position"
        local variableKey = "isLock"
        local tooltip = "Lock the frame."
        local variableTbl = Mac_RogueComboPointBarDB
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        setting:SetValueChangedCallback(OnSettingChanged)
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
	-- RegisterProxySetting example. This will run the GetValue and SetValue
	-- callbacks whenever access to the setting is required.

	local name = "Combo points to change color"
	local variable = "comboPointsToChangeColor"
	local defaultValue = 5
	local minValue = 2
	local maxValue = 7
	local step = 1

	local function GetValue()
		return Mac_RogueComboPointBarDB.comboPointsToChangeColor or defaultValue
	end

	local function SetValue(value)
		Mac_RogueComboPointBarDB.comboPointsToChangeColor = value
	end

	local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
	setting:SetValueChangedCallback(OnSettingChanged)

	local tooltip = "Combo points to change color."
	local options = Settings.CreateSliderOptions(minValue, maxValue, step)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
	Settings.CreateSlider(category, setting, options, tooltip)
end

    do 
        local name = "resetSettings"
        local variable = "resetSettings"
        local variableKey = "resetSettings"
        local variableTbl = Mac_RogueComboPointBarDB
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        setting:SetValueChangedCallback(OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)

end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "Mac_RogueComboPointBar" then
		Mac_RogueComboPointBarDB = Mac_RogueComboPointBarDB or {}
        Mac_RogueComboPointBarDB.comboPointsToChangeColor = Mac_RogueComboPointBarDB.comboPointsToChangeColor or 5
		CreateSettings()
    end
end)