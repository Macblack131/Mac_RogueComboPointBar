local function showBorderChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
end

local function BorderSizeChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
end

local function borderColorChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPointBorder()
end

local function colorChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPoint()
end

local function heightChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPointSize()
end

local function widthChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPointSize()
end

local function spacingChanged()
    Mac_RogueComboPointBarFrame:UpdateSpacing()
end

local function ComboPointsToChangeColorChanged(setting, value)
    Mac_RogueComboPointBarFrame:UpdateRogueComboPoint()
end

local function createCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, callback)
    local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), label, defaultValue)
    Settings.CreateCheckbox(category, setting, tooltip)
    if callback then
        setting:SetValueChangedCallback(callback)
    end
end

local function createColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, callback)
    local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), label, defaultValue)
    local data = Settings.CreateSettingInitializerData(setting, nil, tooltip)
    local initializer = Settings.CreateSettingInitializer('Mac_SettingsColorControlTemplate', data)
    layout:AddInitializer(initializer)
    if callback then
        setting:SetValueChangedCallback(callback)
    end
end

local function createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, callback)

    local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), label, defaultValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value) return string.format("%.1f", value)end)
    Settings.CreateSlider(category, setting, options, tooltip)
    if callback then
        setting:SetValueChangedCallback(callback)
    end
end

local function createHeader(layout, text, tooltip, indent)
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
       createCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip) 
    end

    createHeader(layout, "Combo point frame", nil, 0)

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

        createColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, colorChanged)
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

        createColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, colorChanged)
    end

    do
        local variable = "height"
        local variableKey = "height"
        local  variableTbl = Mac_RogueComboPointBarDB
        local label = "Height"
        local defaultValue = 20
        local tooltip = nil
        local minValue = 10
        local maxValue = 50
        local step = 0.1
        createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, heightChanged)
    end

    do
        local variable = "width"
        local variableKey = "width"
        local  variableTbl = Mac_RogueComboPointBarDB
        local label = "Width"
        local defaultValue = 40
        local tooltip = nil
        local minValue = 10
        local maxValue = 100
        local step = 0.1
        createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, widthChanged)
    end

        do
        local variable = "spacing"
        local variableKey = "spacing"
        local  variableTbl = Mac_RogueComboPointBarDB
        local label = "Spacing"
        local defaultValue = 4
        local tooltip = nil
        local minValue = 0
        local maxValue = 30
        local step = 0.1
        createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, spacingChanged)
    end

    createHeader(layout, "Border", nil, 0)

    do
        local variable ="showBorder"
        local variableKey = "showBorder"
        local label = "Show border"
        local defaultValue = true
        local tooltip = nil
       createCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, showBorderChanged) 
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

        createColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, borderColorChanged)
    end

    do
        local variable = "borderSize"
        local variableKey = "borderSize"
        local  variableTbl = Mac_RogueComboPointBarDB
        local label = "Border size"
        local defaultValue = 1
        local tooltip = nil
        local minValue = 1
        local maxValue = 10
        local step = 0.1
        createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, BorderSizeChanged)
    end

    createHeader(layout, "Change color", nil, 0)

    do
        local variable ="chouldChangeColor"
        local variableKey = "chouldChangeColor"
        local label = "Change combo points if combo points are greater than a specific value"
        local defaultValue = true
        local tooltip = nil
       createCheckBox(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, colorChanged) 
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

        createColorPicker(category, layout, variable, variableKey, variableTbl, label, defaultValue, tooltip, colorChanged)
    end

    do
        local variable = "comboPointsToChangeColor"
        local variableKey = "comboPointsToChangeColor"
        local  variableTbl = Mac_RogueComboPointBarDB
        local label = "Combo points to change color"
        local defaultValue = 5
        local tooltip = nil
        local minValue = 2
        local maxValue = 7
        local step = 1
        createSlider(category, variable, variableKey, variableTbl, label, defaultValue, tooltip, minValue, maxValue, step, ComboPointsToChangeColorChanged)
    end

    Settings.RegisterAddOnCategory(category)
end

local function Init()
    Mac_RogueComboPointBarDB = Mac_RogueComboPointBarDB or {}
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