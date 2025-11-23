Mac_RogueComboPointMixin = {}

function Mac_RogueComboPointMixin:OnLoad()
    self.Texture:SetTexture("Interface/TargetingFrame/UI-StatusBar")
    self:UpdateSize()
    self:UpdateBorder()
end

function Mac_RogueComboPointMixin:UpdateSize()
    self:SetSize(Mac_RogueComboPointBarDB.width, Mac_RogueComboPointBarDB.height)
end

function Mac_RogueComboPointMixin:UpdateBorderSize()
    local borderSize = Mac_RogueComboPointBarDB.borderSize

    self.BorderLeft:SetWidth(borderSize)
    self.BorderRight:SetWidth(borderSize)
    self.BorderTop:SetHeight(borderSize)
    self.BorderBottom:SetHeight(borderSize)
    
    self.BorderTop:SetPoint("TOPLEFT", 0, borderSize)
    self.BorderTop:SetPoint("TOPRIGHT", borderSize, 0)

    self.BorderRight:SetPoint("TOPRIGHT", borderSize, 0)
    self.BorderRight:SetPoint("BOTTOMRIGHT", 0, -borderSize)

    self.BorderBottom:SetPoint("BOTTOMLEFT", -borderSize, -borderSize)
    self.BorderBottom:SetPoint("BOTTOMRIGHT", 0, 0)

    self.BorderLeft:SetPoint("TOPLEFT", -borderSize, borderSize)
    self.BorderLeft:SetPoint("BOTTOMLEFT", 0, 0)

end

function Mac_RogueComboPointMixin:UpdateBordeColor()
    local colorData = Mac_RogueComboPointBarDB.borderColor
    local r, g, b, a = colorData.r, colorData.g, colorData.b, colorData.a

    self.BorderTop:SetColorTexture(r, g, b, a)
    self.BorderRight:SetColorTexture(r, g, b, a)
    self.BorderBottom:SetColorTexture(r, g, b, a)
    self.BorderLeft:SetColorTexture(r, g, b, a)
end

function Mac_RogueComboPointMixin:ShowBorder()
    self.BorderTop:Show()
    self.BorderRight:Show()
    self.BorderBottom:Show()
    self.BorderLeft:Show()
end

function Mac_RogueComboPointMixin:HideBorder()
    self.BorderTop:Hide()
    self.BorderRight:Hide()
    self.BorderBottom:Hide()
    self.BorderLeft:Hide()
end

function Mac_RogueComboPointMixin:UpdateBorder()
    if Mac_RogueComboPointBarDB.showBorder == false then
        self:HideBorder()
        return
    end
    self:ShowBorder()
    self:UpdateBorderSize()
    self:UpdateBordeColor()
end