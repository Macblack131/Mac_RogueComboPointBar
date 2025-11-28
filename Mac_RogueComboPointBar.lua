local function getValueFromSecretValue(secretValue)
    if type(secretValue) ~= "number" then
        return nil
    end
    local value = 0
    for i = 1, secretValue do
        value = value + 1
    end
    return value
end

local function getUnitPowerMax(unit, powerType)
    local secretValue = UnitPowerMax(unit, powerType)
    local UnitPowerMax = getValueFromSecretValue(secretValue)
    
    return UnitPowerMax
end

local function getUnitPower(unit, powerType)
    local secretValue = UnitPower(unit, powerType)
    local UnitPower = getValueFromSecretValue(secretValue)
    
    return UnitPower
end

local function HandleMouseUp(self)
    self:StopMovingOrSizing()
    self:SetMovable(false)

    local xOffset, yOffset = self:GetCenter()
    Settings.SetValue("positionX", xOffset - (GetScreenWidth() / 2))
    Settings.SetValue("positionY", yOffset - (GetScreenHeight() / 2))

end

local function HandleMouseDown(self)
    if Mac_RogueComboPointBarDB.isLock ~= true then
        self:SetMovable(true)
        self:StartMoving()
    end
end

Mac_RogueComboPointBarFrameMixin = {}

function Mac_RogueComboPointBarFrameMixin:UpdatePosition()
    self:ClearAllPoints()

    local xOffset = Mac_RogueComboPointBarDB.xOffset
    local yOffset = Mac_RogueComboPointBarDB.yOffset

    self:SetPoint("CENTER", UIParent, "CENTER", xOffset, yOffset)
end

function Mac_RogueComboPointBarFrameMixin:CreateRogueComboPoint()
    local unit = "player"
    local powerType = 4
    self.maxComboPoints = getUnitPowerMax(unit, powerType)
    self.RogueComboPointPool = self.RogueComboPointPool or {}
    for i = #self.RogueComboPointPool + 1, self.maxComboPoints do
        self.RogueComboPointPool[i] = CreateFrame("Frame", nil, self, "Mac_RogueComboPointTemplate")
        self.RogueComboPointPool[i].layoutIndex = i
    end
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:UpdateRogueComboPointVisibility()
    local unit = "player"
    local powerType = 4
    local maxComboPoints = getUnitPowerMax(unit, powerType)
    local rogueComboPointPool = self.RogueComboPointPool

    for i = 1, #rogueComboPointPool do
        if i  > maxComboPoints then
            rogueComboPointPool[i]:Hide()
        else
            rogueComboPointPool[i]:Show()
        end
    end
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:OnLoad()
    self:UpdatePosition()
    self:SetScript("OnMouseUp", HandleMouseUp)
    self:SetScript("OnMouseDown", HandleMouseDown)
    self:RegisterEvent("UNIT_POWER_UPDATE")
    self:RegisterEvent("UNIT_MAXPOWER")
    self:CreateRogueComboPoint()
    self:UpdateSpacing()
    self:UpdateRogueComboPoint()
end

function Mac_RogueComboPointBarFrameMixin:OnEvent(event, ...)
    if event == "UNIT_POWER_UPDATE" then
        local unitTarget, powerType = ...
        if unitTarget == "player" and powerType == "COMBO_POINTS" then
            self:UpdateRogueComboPoint()
        end
    end

    if event == "UNIT_MAXPOWER" then
        local unitTarget, powerType = ...
        if unitTarget == "player" and powerType == "COMBO_POINTS" then
            self:CreateRogueComboPoint()
            self:UpdateRogueComboPointVisibility()
            self:UpdateRogueComboPoint()
        end
    end
end

function Mac_RogueComboPointBarFrameMixin:UpdateSpacing()
    self.spacing = Mac_RogueComboPointBarDB.spacing
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:UpdateRogueComboPointSize()
    local rogueComboPointPool = self.RogueComboPointPool
    for i = 1, #rogueComboPointPool do
        local rogueComboPoint = rogueComboPointPool[i]
        rogueComboPoint:UpdateSize()
    end
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:UpdateRogueComboPointBorder()
    local rogueComboPointPool = self.RogueComboPointPool
    for i = 1, #rogueComboPointPool do
        local rogueComboPoint = rogueComboPointPool[i]
        rogueComboPoint:UpdateBorder()
    end
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:UpdateRogueComboPoint()
    local unit = "player"
    local powerType = 4
    local currentComboPoints = getUnitPower(unit, powerType)
    local rogueComboPointPool = self.RogueComboPointPool

    local color = Mac_RogueComboPointBarDB.color
    local backgroundColor = Mac_RogueComboPointBarDB.backgroundColor
    local changedColor = Mac_RogueComboPointBarDB.changedColor
    for i = 1, #rogueComboPointPool do
        local rogueComboPoint = rogueComboPointPool[i]
        if i > currentComboPoints then
            rogueComboPoint.Texture:SetColorTexture(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        elseif currentComboPoints >= Mac_RogueComboPointBarDB.comboPointsToChangeColor and Mac_RogueComboPointBarDB.chouldChangeColor == true then
            rogueComboPoint.Texture:SetColorTexture(changedColor.r, changedColor.g, changedColor.b, changedColor.a)
        else
            rogueComboPoint.Texture:SetColorTexture(color.r, color.g, color.b, color.a)
        end
    end
end

function Mac_RogueComboPointBarFrameMixin:ResetPosition()
    self:ClearAllPoints()
    self:SetPoint("CENTER")
end