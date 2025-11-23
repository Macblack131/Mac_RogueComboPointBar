local function getValueFromSecretValue(secretValue)
    if type(secretValue) ~= "number" then
        print("Uncorrect value")
        return nil
    end

    local value = 0
    for i = 1, secretValue do
        value = value + 1
    end

    return value
end

local function getUnitPowerMax(unit, powerType)
    local secretValue = UnitPowerMax(unit, 4)
    local UnitPowerMax = getValueFromSecretValue(secretValue)
    
    return UnitPowerMax
end

local function getUnitPower(unit, powerType)
    local secretValue = UnitPower(unit, powerType)
    local UnitPower = getValueFromSecretValue(secretValue)
    
    return UnitPower
end

Mac_RogueComboPointBarFrameMixin = {}

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

function Mac_RogueComboPointBarFrameMixin:OnLoad()
    self:SetMovable(true)
    self:SetScript("OnMouseDown", function(self)
        if Mac_RogueComboPointBarDB.isLock ~= true then
        self:StartMoving()
        end
    end)
    self:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        self:SetUserPlaced(true)
    end)

    self:RegisterEvent("UNIT_POWER_UPDATE")
    self:CreateRogueComboPoint()
    self:UpdateSpacing()
    self:UpdateRogueComboPoint()
end

function Mac_RogueComboPointBarFrameMixin:OnEvent(event, ...)
    if event == "UNIT_POWER_UPDATE" then
        self:UpdateRogueComboPoint()
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
    local maxComboPoints = getUnitPowerMax(unit, powerType)
    if maxComboPoints ~= self.maxComboPoints then
        self:CreateRogueComboPoint()
    end
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