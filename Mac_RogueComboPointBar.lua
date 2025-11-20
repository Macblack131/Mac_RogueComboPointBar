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

function Mac_RogueComboPointBarFrameMixin:OnLoad()
    self:SetMovable(true)
    self:SetScript("OnMouseDown", function(self, button)
        if Mac_RogueComboPointBarDB.isLock ~= true then
        self:StartMoving()
        end
    end)
    self:SetScript("OnMouseUp", function(self, button)
        self:StopMovingOrSizing()
        self:SetUserPlaced(true)
    end)

    self:RegisterEvent("UNIT_POWER_UPDATE")
    self.RogueComboPointPool = CreateFramePool("Frame", self, "Mac_RogueComboPointTemplate")
    local unit = "player"
    local powerType = 4
    local currentComboPoints = getUnitPower(unit, powerType)
    local maxComboPoints = getUnitPowerMax(unit, powerType)
    self:Update(currentComboPoints, maxComboPoints)
end

function Mac_RogueComboPointBarFrameMixin:OnEvent(event, ...)
    if event == "UNIT_POWER_UPDATE" then
        local unit = "player"
        local powerType = 4
        local currentComboPoints = getUnitPower(unit, powerType)
        local maxComboPoints = getUnitPowerMax(unit, powerType)
        self:Update(currentComboPoints, maxComboPoints)
    end
end

function Mac_RogueComboPointBarFrameMixin:Update(currentComboPoints, maxComboPoints)
    self.RogueComboPointPool:ReleaseAll()
    for i = 1, maxComboPoints do
        local rogueComboPoint = self.RogueComboPointPool:Acquire()
        rogueComboPoint.layoutIndex = i
        rogueComboPoint:Show()
        rogueComboPoint.Fill:Show()
        if i > currentComboPoints then
            rogueComboPoint.Fill:Hide()
        end
        if Mac_RogueComboPointBarDB then
            if Mac_RogueComboPointBarDB.comboPointsToChangeColor then
                if currentComboPoints >= Mac_RogueComboPointBarDB.comboPointsToChangeColor then
                    rogueComboPoint.Fill:SetColorTexture(0.012, 0.8, 0.004)
                else
                    rogueComboPoint.Fill:SetColorTexture(0.776, 0.604, 0)
                end
            end
        else
            rogueComboPoint.Fill:SetColorTexture(0.776, 0.604, 0)
        end
    end
    self:Layout()
end

function Mac_RogueComboPointBarFrameMixin:ResetPosition()
    self:ClearAllPoints()
    self:SetPoint("CENTER")
end