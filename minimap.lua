DKPBidder_Minimap = {}

function DKPBidder_Minimap.createMinimapButton(onLeftClick, onRightClick)
    local minimapButton = CreateFrame("Button", "DKPBidderMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)  -- Default position
    minimapButton:SetNormalTexture("Interface\\AddOns\\DKPBidder\\media\\icon.tga")
    minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local minimapButtonBackground = minimapButton:CreateTexture(nil, "BACKGROUND")
    minimapButtonBackground:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    minimapButtonBackground:SetSize(32, 32)
    minimapButtonBackground:SetPoint("CENTER")

    local coinTexture = minimapButton:CreateTexture(nil, "ARTWORK")
    coinTexture:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
    coinTexture:SetSize(16, 16)
    coinTexture:SetPoint("CENTER")

    local minimapButtonBorder = minimapButton:CreateTexture(nil, "OVERLAY")
    minimapButtonBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    minimapButtonBorder:SetSize(54, 54)
    minimapButtonBorder:SetPoint("CENTER", minimapButton, "CENTER", 10, -10)

    minimapButton:SetMovable(true)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:SetScript("OnDragStart", minimapButton.StartMoving)
    minimapButton:SetScript("OnDragStop", function(self)
        minimapButton:StopMovingOrSizing()
        DKPBidder_Minimap.savePosition()
    end)

    minimapButton:RegisterForClicks("AnyUp")
    minimapButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            onLeftClick()
        elseif button == "RightButton" then
            onRightClick()
        end
    end)

    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("DKP Bidder", 1, 1, 1)
        GameTooltip:AddLine("Left-click to toggle the DKP Bidder frame.", nil, nil, nil, true)
        GameTooltip:AddLine("Right-click to open the config window.", nil, nil, nil, true)
        GameTooltip:Show()
    end)

    minimapButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    DKPBidder_Minimap.loadPosition()
end

function DKPBidder_Minimap.savePosition()
    local point, relativeTo, relativePoint, xOfs, yOfs = DKPBidderMinimapButton:GetPoint()
    DKPBidder_Config.data.minimapPosition = { point, relativePoint, xOfs, yOfs }
    DKPBidder_Config.saveConfig()
end

function DKPBidder_Minimap.loadPosition()
    if DKPBidder_Config.data.minimapPosition then
        local point, relativePoint, xOfs, yOfs = unpack(DKPBidder_Config.data.minimapPosition)
        DKPBidderMinimapButton:SetPoint(point, Minimap, relativePoint, xOfs, yOfs)
    else
        DKPBidderMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)  -- Default position
    end
end
