Mac_RogueComboPointMixin = {}

function Mac_RogueComboPointMixin:OnLoad()
    self.Background:SetTexture("Interface/TargetingFrame/UI-StatusBar")
    self.Background:SetColorTexture(0, 0, 0, 0.25)
    self.Fill:SetTexture("Interface/TargetingFrame/UI-StatusBar")
    self.Fill:SetColorTexture(0.776, 0.604, 0)

    local borderFrame = CreateFrame("Frame", "Border", self)
    borderFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    borderFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
    borderFrame:SetFrameLevel(self:GetFrameLevel() + 1) -- Above the main frame
    
    local borderTop = borderFrame:CreateTexture("borderTop", "OVERLAY")
    borderTop:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", 0, 0)
    borderTop:SetPoint("TOPRIGHT", borderFrame, "TOPRIGHT", 0, 0)
    borderTop:SetHeight(2)
    borderTop:SetColorTexture(0, 0, 0, 0.5)
    
    local borderBottom = borderFrame:CreateTexture(nil, "OVERLAY")
    borderBottom:SetPoint("BOTTOMLEFT", borderFrame, "BOTTOMLEFT", 0, 0)
    borderBottom:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 0, 0)
    borderBottom:SetHeight(2)
    borderBottom:SetColorTexture(0, 0, 0, 0.5)
    
    local borderLeft = borderFrame:CreateTexture(nil, "OVERLAY")
    borderLeft:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", 0, 0)
    borderLeft:SetPoint("BOTTOMLEFT", borderFrame, "BOTTOMLEFT", 0, 0)
    borderLeft:SetWidth(2)
    borderLeft:SetColorTexture(0, 0, 0, 0.5)
    
    local borderRight = borderFrame:CreateTexture(nil, "OVERLAY")
    borderRight:SetPoint("TOPRIGHT", borderFrame, "TOPRIGHT", 0, 0)
    borderRight:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 0, 0)
    borderRight:SetWidth(2)
    borderRight:SetColorTexture(0, 0, 0, 0.5)
end