local DEFAULT_SETTINGS = {
    isLock = false,
    color = {
        r = 0.776,
        g = 0.604,
        b = 0,
        a = 1,
    },
    resetSettings = false,
    yOffset = 0,
    spacing = 4,
    showBorder = true,
    backgroundColor = {
        r = 0,
        g = 0,
        b = 0,
        a = 0.25
    },
    changedColor = {
        r = 0.012,
        g = 0.8,
        b = 0.004,
        a = 1,
    },
    width = 40,
    borderColor = {
        r = 0,
        g = 0,
        b = 0,
        a = 1,
    },
    borderSize = 1,
    height = 20,
    comboPointsToChangeColor = 5,
    chouldChangeColor = true,
    xOffset = 0,
}


local function CreateSliderOptions(minValue, maxValue, step, buttonStep)
	local options = {}
	options.minValue = minValue or 0;
	options.maxValue = maxValue or 1;
	options.steps = (step and (maxValue - minValue) / step) or 100;
    options.buttonStep = buttonStep or 0.1
	return options;
end

local function AddInitializerToLayout(category, initializer)
	local layout = SettingsPanel:GetLayout(category)
	layout:AddInitializer(initializer)
end

local function CreateSliderInitializer(setting, options, tooltip)
	assert((setting:GetVariableType() == "number") and (options ~= nil))
	return Settings.CreateControlInitializer("Mac_SettingsSliderControlTemplate", setting, options, tooltip)
end

local function CreateSlider(category, setting, options, tooltip)
	local initializer = CreateSliderInitializer(setting, options, tooltip)
	AddInitializerToLayout(category, initializer)
	return initializer;
end

local function CreateCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, callback)
    local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), label, defaultValue)
    Settings.CreateCheckbox(category, setting, tooltip)
    if callback then
        setting:SetValueChangedCallback(callback)
    end
end

local function CreateColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, callback)
    local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), label, defaultValue)
    local data = Settings.CreateSettingInitializerData(setting, nil, tooltip)
    local initializer = Settings.CreateSettingInitializer('Mac_SettingsColorControlTemplate', data)
    layout:AddInitializer(initializer)
    if callback then
        setting:SetValueChangedCallback(callback)
    end
end

local function CreateHeader(layout, text, tooltip, indent)
        local data = { name = text, tooltip = tooltip, indent = indent or 0 };
        local initializer = Settings.CreateElementInitializer("Mac_SettingsHeaderTemplate", data);

        layout:AddInitializer(initializer);

end

local function CreateSettings()

    local category, layout = Settings.RegisterVerticalLayoutCategory("Mac_RogueComboPointBar")

    local variableTbl = Mac_RogueComboPointBarDB

    do
        local variable ="isLock"
        local variableKey = "isLock"
        local label = "Lock position"
        local defaultValue = false
        local tooltip = nil
        CreateCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip) 
    end

    CreateHeader(layout, "Combo point frame", nil, 0)

    do
        local defaultValue = 0
        local variableKey = "positionX"
        local label = "Position X"

		local function GetValue()
            return Mac_RogueComboPointBarDB.xOffset or defaultValue
		end

		local function SetValue(value)
            Mac_RogueComboPointBarDB.xOffset = value
            Mac_RogueComboPointBarFrame:UpdatePosition()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = -1920, 1920, 0.1, 10
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    do
        local defaultValue = 0
        local variableKey = "positionY"
        local label = "Position Y"

		local function GetValue()
            return Mac_RogueComboPointBarDB.yOffset or defaultValue
		end

		local function SetValue(value)
            Mac_RogueComboPointBarDB.yOffset = value
            Mac_RogueComboPointBarFrame:UpdatePosition()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = -1080, 1080, 0.1, 10
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    do
        local defaultValue = 4
        local variableKey = "spacing"
        local label = "Spacing"

		local function GetValue()
			return Mac_RogueComboPointBarDB.spacing or defaultValue
		end

		local function SetValue(value)
			Mac_RogueComboPointBarDB.spacing = value
            Mac_RogueComboPointBarFrame:UpdateSpacing()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = 0, 30, 0.1, 10
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    CreateHeader(layout, "Combo point", nil, 0)

    do
        local label = "Color"
        local tooltip = nil
        local variableKey = "color"
        local defaultValue = {
            r = 0.776,
            g = 0.604,
            b = 0,
            a = 1,
        }
        local variable ="color"

        local function OnValueChanged()
            Mac_RogueComboPointBarFrame:UpdateRogueComboPoint()
        end

        CreateColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged)
    end

    do
        local label = "Background color"
        local tooltip = nil
        local variableKey = "backgroundColor"
        local defaultValue = {
            r = 0,
            g = 0,
            b = 0,
            a = 0.25
        }
        local variable ="backgroundColor"

        local function OnValueChanged()
            Mac_RogueComboPointBarFrame:UpdateRogueComboPoint()
        end

        CreateColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged)
    end

    do
        local defaultValue = 20
        local variableKey = "height"
        local label = "Height"

		local function GetValue()
			return Mac_RogueComboPointBarDB.height or defaultValue
		end

		local function SetValue(value)
			Mac_RogueComboPointBarDB.height = value
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointSize()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = 1, 1080, 0.1, 1
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    do
        local defaultValue = 40
        local variableKey = "width"
        local label = "Width"

		local function GetValue()
			return Mac_RogueComboPointBarDB.width or defaultValue
		end

		local function SetValue(value)
			Mac_RogueComboPointBarDB.width = value
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointSize()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = 1, 1920, 0.1, 1
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    CreateHeader(layout, "Border", nil, 0)

    do
        local variable ="showBorder"
        local variableKey = "showBorder"
        local label = "Show border"
        local defaultValue = true
        local tooltip = nil

        local function OnValueChanged()
		    Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
	    end

       CreateCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged) 
    end

    do
        local label = "Border color"
        local tooltip = nil
        local variableKey = "borderColor"
        local defaultValue = {
            r = 0,
            g = 0,
            b = 0,
            a = 1,
        }
        local variable ="borderColor"

        local function OnValueChanged()
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
        end

        CreateColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged)
    end

    do
        local defaultValue = 1
        local variableKey = "borderSize"
        local label = "Border size"

		local function GetValue()
			return Mac_RogueComboPointBarDB.borderSize or defaultValue
		end

		local function SetValue(value)
			Mac_RogueComboPointBarDB.borderSize = value
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = 1, 32, 0.1, 1
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    CreateHeader(layout, "Change color", nil, 0)

    do
        local variable ="chouldChangeColor"
        local variableKey = "chouldChangeColor"
        local label = "Change combo points if combo points are greater than a specific value"
        local defaultValue = true
        local tooltip = nil

        local function OnValueChanged()
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
        end
        
        CreateCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged) 
    end

    do
        local label = "Changed color"
        local tooltip = nil
        local variableKey = "changedColor"
        local defaultValue = {
            r = 0.012,
            g = 0.8,
            b = 0.004,
            a = 1,
        }
        local variable ="changedColor"

        local function OnValueChanged()
            Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
        end

        CreateColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, OnValueChanged)
    end

    do
        local defaultValue = 5
        local variableKey = "comboPointsToChangeColor"
        local label = "Combo points to change color"

		local function GetValue()
			return Mac_RogueComboPointBarDB.comboPointsToChangeColor or defaultValue
		end

		local function SetValue(value)
			Mac_RogueComboPointBarDB.comboPointsToChangeColor = value
            Mac_RogueComboPointBarFrame:UpdateRogueComboPoint()
		end

		local setting = Settings.RegisterProxySetting(category, variableKey, Settings.VarType.Number, label, defaultValue, GetValue, SetValue)

        local minValue, maxValue, step, buttonStep = 2, 7, 1, 1
        local options = CreateSliderOptions(minValue, maxValue, step, buttonStep)
		local tooltip = nil
		CreateSlider(category, setting, options, tooltip)
    end

    do 
        local name = "resetSettings"
        local variable = "resetSettings"
        local variableKey = "resetSettings"
        local variableTbl = Mac_RogueComboPointBarDB
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)

        local function resetSettings()
            Mac_RogueComboPointBarFrame:ResetPosition()
        end

        setting:SetValueChangedCallback(resetSettings)
    end

    Settings.RegisterAddOnCategory(category)
end

local function Init()
    Mac_RogueComboPointBarDB = Mac_RogueComboPointBarDB or DEFAULT_SETTINGS
    CreateSettings()
    CreateFrame("Frame", "Mac_RogueComboPointBarFrame", UIParent, "Mac_RogueComboPointBarFrameTemplate")
end

EventUtil.ContinueOnAddOnLoaded("Mac_RogueComboPointBar", Init)

Mac_SettingsColorControlMixin = CreateFromMixins(SettingsControlMixin);
do
    local mixin = Mac_SettingsColorControlMixin

    function mixin:SetColorVisual(colorData)
        local r, g, b = colorData.r, colorData.g, colorData.b;
        self.ColorSwatch.Color:SetVertexColor(r, g, b);
    end

    function mixin:Init(initializer)
        SettingsControlMixin.Init(self, initializer);

        -- "SetCallback" actually registers the callback, it doesn't replace it
        self.data.setting:SetValueChangedCallback(function(_, value) self:SetColorVisual(value) end);
        self:SetColorVisual(self.data.setting:GetValue());

        self.ColorSwatch:SetScript("OnClick", function() self:OpenColorPicker() end);
        self.ColorSwatch:SetScript("OnEnter", function(button)
            GameTooltip:SetOwner(button, "ANCHOR_TOP");
            GameTooltip_AddHighlightLine(GameTooltip, initializer:GetName());
            GameTooltip_AddNormalLine(GameTooltip, initializer:GetTooltip());
            GameTooltip:Show();
        end);
        self.ColorSwatch:SetScript("OnLeave", function() GameTooltip:Hide(); end);

        self:EvaluateState();
    end

    function mixin:EvaluateState()
        SettingsControlMixin.EvaluateState(self);
        local enabled = self:IsEnabled();

        self.ColorSwatch:SetEnabled(enabled);
        if not enabled then
            self.Text:SetTextColor(GRAY_FONT_COLOR:GetRGB());
        end
    end

    function mixin:OpenColorPicker()
        local color = self.data.setting:GetValue();

        ColorPickerFrame:SetupColorPickerAndShow({
            r = color.r,
            g = color.g,
            b = color.b,
            opacity = color.a or nil,
            hasOpacity = color.a ~= nil,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB();
                local a = ColorPickerFrame:GetColorAlpha();

                self.data.setting:SetValue({ r = r, g = g, b = b, a = a, });
            end,
            cancelFunc = function()
                local r, g, b, a = ColorPickerFrame:GetPreviousValues();

                self.data.setting:SetValue({ r = r, g = g, b = b, a = a, });
            end,
        });
    end
end

Mac_SettingsHeaderMixin = CreateFromMixins(DefaultTooltipMixin);
    do
        local mixin = Mac_SettingsHeaderMixin;

        function mixin:Init(initializer)
            local data = initializer:GetData();
            self.Title:SetTextToFit(data.name);
            local indent = data.indent or 0;
            self.Title:SetPoint('TOPLEFT', (7 + (indent * 15)), -16);

            self:SetCustomTooltipAnchoring(self.Title, "ANCHOR_RIGHT");

            self:SetTooltipFunc(function() Settings.InitTooltip(initializer:GetName(), initializer:GetTooltip()) end);
        end
    end