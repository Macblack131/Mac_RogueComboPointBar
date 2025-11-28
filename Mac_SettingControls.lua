local function InitializeSettingTooltip(initializer)
	Settings.InitTooltip(initializer:GetName(), initializer:GetTooltip());
end

Mac_SettingsSliderControlMixin = CreateFromMixins(SettingsControlMixin);

function Mac_SettingsSliderControlMixin:OnLoad()
	SettingsControlMixin.OnLoad(self);

	self.SliderWithInput = CreateFrame("Frame", nil, self, "Mac_MinimalSliderWithImputBoxTemplate");
	self.SliderWithInput:SetWidth(250);
	self.SliderWithInput:SetPoint("LEFT", self, "CENTER", -80, 3);

	Mixin(self.SliderWithInput.Slider, DefaultTooltipMixin);
	self.SliderWithInput.Slider:InitDefaultTooltipScriptHandlers();
	self.SliderWithInput.Slider:SetCustomTooltipAnchoring(self.SliderWithInput.Slider, "ANCHOR_RIGHT", 20, 0);
end

function Mac_SettingsSliderControlMixin:Init(initializer)
	SettingsControlMixin.Init(self, initializer);

	local setting = self:GetSetting();
	local options = initializer:GetOptions();
	self.SliderWithInput:Init(setting:GetValue(), options.minValue, options.maxValue, options.steps, options.buttonStep);

	self.SliderWithInput.Slider:SetTooltipFunc(GenerateClosure(InitializeSettingTooltip, initializer));

	self.cbrHandles:RegisterCallback(self.SliderWithInput, Mac_MinimalSliderWithInputBoxMixin.Event.OnValueChanged, self.OnSliderValueChanged, self);

	self:EvaluateState();
end

function Mac_SettingsSliderControlMixin:Release()
	self.SliderWithInput:Release();
	SettingsControlMixin.Release(self);
end

function Mac_SettingsSliderControlMixin:OnSliderValueChanged(value)
	self:GetSetting():SetValue(value);
end

function Mac_SettingsSliderControlMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value);

	local initializer = self:GetElementData();
	if initializer.reinitializeOnValueChanged then
		self.SliderWithInput:FormatValue(self:GetSetting():GetValue());
	end
end

function Mac_SettingsSliderControlMixin:SetValue(value)
	self.SliderWithInput:SetValue(value);
end

function Mac_SettingsSliderControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self);
	local enabled = self:IsEnabled();
	self.SliderWithInput:SetEnabled(enabled);
	self:DisplayEnabled(enabled);
end