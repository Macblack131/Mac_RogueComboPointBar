Mac_MinimalSliderWithInputBoxMixin = CreateFromMixins(CallbackRegistryMixin)

Mac_MinimalSliderWithInputBoxMixin:GenerateCallbackEvents(
	{
		"OnValueChanged",
		"OnInteractStart",
		"OnInteractEnd",
	}
);

local interactionFlags = {
	Hover = 1,
	Click = 2,
};

function Mac_MinimalSliderWithInputBoxMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);

	self.InteractionFlags = CreateFromMixins(FlagsMixin);
	self.InteractionFlags:OnLoad();

	local forward = false;
	self.Back:SetScript("OnClick", GenerateClosure(self.OnStepperClicked, self, forward));

	local backward = true;
	self.Forward:SetScript("OnClick", GenerateClosure(self.OnStepperClicked, self, backward));

	local function OnMouseDown(slider)
		if slider:IsEnabled() then
			self:SetInteractionFlag(interactionFlags.Click);
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		end
	end
	self.Slider:SetScript("OnMouseDown", OnMouseDown);

	local function OnMouseUp(slider)
		if slider:IsEnabled() then
			self:ClearInteractionFlag(interactionFlags.Click);
		end
	end
	self.Slider:SetScript("OnMouseUp", OnMouseUp);

	local function OnEnter(slider)
		if slider:IsEnabled() then
			self:SetInteractionFlag(interactionFlags.Hover);
		end
	end
	self.Slider:SetScript("OnEnter", OnEnter);

	local function OnLeave(slider)
		if slider:IsEnabled() then
			self:ClearInteractionFlag(interactionFlags.Hover);
		end
	end
	self.Slider:SetScript("OnLeave", OnLeave);	
end

function Mac_MinimalSliderWithInputBoxMixin:OnStepperClicked(forward)
	local value = self.Slider:GetValue();
	local step = self.Slider.buttonStep
	if forward then
		self.Slider:SetValue(value + step);
	else
		self.Slider:SetValue(value - step);
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

function Mac_MinimalSliderWithInputBoxMixin:Init(value, minValue, maxValue, steps, buttonStep)
	self.Slider:SetMinMaxValues(minValue, maxValue)
	self.Slider:SetValueStep((maxValue - minValue) / steps)
	self.Slider:SetValue(value)
	self.Slider.buttonStep = buttonStep or 1

    self.EditBox:SetJustifyH("CENTER")
    self.EditBox:SetText(math.floor(value * 10 + 0.5) / 10)
	self.EditBox.currentValue = math.floor(value * 10 + 0.5) / 10

	local function OnValueChanged(slider, value)
        self.EditBox:SetText(math.floor(value * 10 + 0.5) / 10)
        self.EditBox.currentValue = math.floor(value * 10 + 0.5) / 10

		self:TriggerEvent(Mac_MinimalSliderWithInputBoxMixin.Event.OnValueChanged, value);
	end
	self.Slider:SetScript("OnValueChanged", OnValueChanged);
    local function OnEnterPressed()
        local value = tonumber(self.EditBox:GetText())
			if value == nil then
				return
			else
                OnValueChanged(nil , math.floor(value * 10 + 0.5) / 10)
			end
        self.EditBox:ClearFocus()
    end

    self.EditBox:SetScript("OnEnterPressed", OnEnterPressed)

    local function OnEditFocusGained()
        self.EditBox:HighlightText(0,0)
    end

    self.EditBox:SetScript("OnEditFocusGained", OnEditFocusGained)

    local function OnEscapePressed()
        self.EditBox:SetText(self.EditBox.currentValue)
        self.EditBox:ClearFocus()
    end

    self.EditBox:SetScript("OnEscapePressed", OnEscapePressed)
end

function Mac_MinimalSliderWithInputBoxMixin:SetInteractionFlag(flag)
	local wasAnySet = self.InteractionFlags:IsAnySet();
	self.InteractionFlags:Set(flag);
	if not wasAnySet then
		self:TriggerEvent(Mac_MinimalSliderWithInputBoxMixin.Event.OnInteractStart);
	end
end

function Mac_MinimalSliderWithInputBoxMixin:ClearInteractionFlag(flag)
	local wasAnySet = self.InteractionFlags:IsAnySet();
	self.InteractionFlags:Clear(flag);
	if wasAnySet and not self.InteractionFlags:IsAnySet() then
		self:TriggerEvent(Mac_MinimalSliderWithInputBoxMixin.Event.OnInteractEnd);
	end
end

local function ConfigureSlider(self, color, alpha)
	self.Slider.Thumb:SetAlpha(alpha);
end

function Mac_MinimalSliderWithInputBoxMixin:SetEnabled(enabled)
	if enabled then
		ConfigureSlider(self, NORMAL_FONT_COLOR, 1.0);
	else
		ConfigureSlider(self, GRAY_FONT_COLOR, .7);
	end
	self.Slider:SetEnabled(enabled);
	self.Back:SetEnabled(enabled);
	self.Forward:SetEnabled(enabled);
end

function Mac_MinimalSliderWithInputBoxMixin:SetValue(value)
	self.Slider:SetValue(value)
end

function Mac_MinimalSliderWithInputBoxMixin:Release()
	self.Slider:Release();
end