-- DKPBidder.lua
LoadAddOn("DKPBidder_Core")
LoadAddOn("DKPBidder_Minimap")
LoadAddOn("DKPBidder_Config")

local core = DKPBidder_Core
local minimap = DKPBidder_Minimap
local config = DKPBidder_Config

local frame = CreateFrame("Frame", "DKPBidderFrame", UIParent)
frame:SetSize(300, 420)
frame:SetPoint("CENTER")
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\AchievementFrame\\UI-Achievement-Parchment",  -- Parchment-like background
    edgeFile = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
    tile = false,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})

frame:SetBackdropColor(1, 1, 1, 1)  -- Set background color to match parchment
frame:SetBackdropBorderColor(1, 1, 1, 1)  -- Ensure border is not transparent

local titleFrame = CreateFrame("Frame", nil, frame)
titleFrame:SetSize(256, 64)
titleFrame:SetPoint("TOP", frame, "TOP", 0, 30)

local titleTexture = titleFrame:CreateTexture(nil, "ARTWORK")
titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
titleTexture:SetAllPoints(titleFrame)

local leftGryphon = frame:CreateTexture(nil, "ARTWORK")
leftGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
leftGryphon:SetSize(90, 90)
leftGryphon:SetPoint("RIGHT", titleFrame, "LEFT", 80, 39)

local rightGryphon = frame:CreateTexture(nil, "ARTWORK")
rightGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
rightGryphon:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
rightGryphon:SetSize(90, 90)
rightGryphon:SetPoint("LEFT", titleFrame, "RIGHT", -80, 39)

local topLeftCorner = frame:CreateTexture(nil, "OVERLAY")
topLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topLeftCorner:SetSize(32, 32)
topLeftCorner:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

local topRightCorner = frame:CreateTexture(nil, "OVERLAY")
topRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topRightCorner:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightCorner:SetSize(32, 32)
topRightCorner:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

local bottomLeftCorner = frame:CreateTexture(nil, "OVERLAY")
bottomLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomLeftCorner:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftCorner:SetSize(32, 32)
bottomLeftCorner:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

local bottomRightCorner = frame:CreateTexture(nil, "OVERLAY")
bottomRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomRightCorner:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightCorner:SetSize(32, 32)
bottomRightCorner:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

local topMetal = frame:CreateTexture(nil, "OVERLAY")
topMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
topMetal:SetSize(256, 16)
topMetal:SetPoint("TOP", frame, "TOP", 0, 8)

local bottomMetal = frame:CreateTexture(nil, "OVERLAY")
bottomMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
bottomMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomMetal:SetSize(256, 16)
bottomMetal:SetPoint("BOTTOM", frame, "BOTTOM", 0, -8)

local leftMetal = frame:CreateTexture(nil, "OVERLAY")
leftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
leftMetal:SetTexCoord(0, 1, 1, 0)  -- Rotate the texture 90 degrees
leftMetal:SetSize(16, 256)
leftMetal:SetPoint("LEFT", frame, "LEFT", -8, 0)

local rightMetal = frame:CreateTexture(nil, "OVERLAY")
rightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
rightMetal:SetTexCoord(0, 1, 0, 1)  -- Rotate the texture 90 degrees and flip horizontally
rightMetal:SetSize(16, 256)
rightMetal:SetPoint("RIGHT", frame, "RIGHT", 8, 0)

local topLeftMetal = frame:CreateTexture(nil, "OVERLAY")
topLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topLeftMetal:SetSize(32, 32)
topLeftMetal:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

local topRightMetal = frame:CreateTexture(nil, "OVERLAY")
topRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topRightMetal:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightMetal:SetSize(32, 32)
topRightMetal:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

local bottomLeftMetal = frame:CreateTexture(nil, "OVERLAY")
bottomLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomLeftMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftMetal:SetSize(32, 32)
bottomLeftMetal:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

local bottomRightMetal = frame:CreateTexture(nil, "OVERLAY")
bottomRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomRightMetal:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightMetal:SetSize(32, 32)
bottomRightMetal:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

frame:SetMovable(true)
frame:EnableMouse(true)

titleFrame:SetMovable(true)
titleFrame:EnableMouse(true)
titleFrame:RegisterForDrag("LeftButton")
titleFrame:SetScript("OnDragStart", function() frame:StartMoving() end)
titleFrame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)

frame.title = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("CENTER", titleFrame, "CENTER", 0, 12)
frame.title:SetText("DKP Bidder")

local bidStatusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
bidStatusText:SetPoint("TOP", frame.title, "BOTTOM", 0, -30)
bidStatusText:SetTextColor(1, 0, 0)  -- Red color
bidStatusText:SetText("NO ACTIVE BID")
frame.bidStatusText = bidStatusText

local itemText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
itemText:SetPoint("TOP", bidStatusText, "BOTTOM", 0, -10)
itemText:SetWidth(280)  -- Set the width to ensure text wraps
itemText:SetWordWrap(true)  -- Enable word wrapping
itemText:SetText("No item selected")
frame.itemText = itemText

local itemSlot = CreateFrame("Button", "DKPBidderItemSlot", frame, "ItemButtonTemplate")
itemSlot:SetPoint("TOP", itemText, "BOTTOM", 0, -10)
itemSlot:SetSize(64, 64)
_G[itemSlot:GetName() .. "IconTexture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")  -- Set a default item icon
itemSlot:SetNormalTexture(nil)  -- Remove the default border

local DKPAmount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
DKPAmount:SetPoint("TOP", itemSlot, "BOTTOM", 0, -10)
local dkpValue = core.gatherDKP()
if tonumber(dkpValue) then
    DKPAmount:SetText("Your net " .. dkpValue .. " DKP")
else
    DKPAmount:SetText(dkpValue)
end

local refreshButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
refreshButton:SetPoint("RIGHT", DKPAmount, "LEFT", -10, 0)
refreshButton:SetSize(25, 25)
refreshButton:SetText("R")
refreshButton:SetScript("OnClick", function()
    local dkpValue = core.gatherDKP()
    if tonumber(dkpValue) then
        DKPAmount:SetText("Your net " .. dkpValue .. " DKP")
    else
        DKPAmount:SetText(dkpValue)
    end
    core.updateBidButton()
end)
refreshButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Refresh", 1, 1, 1)
    GameTooltip:AddLine("Click to refresh the DKP amount.", nil, nil, nil, true)
    GameTooltip:Show()
end)
refreshButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

local messageFrame = CreateFrame("Frame", nil, frame)
messageFrame:SetSize(280, 50)
messageFrame:SetPoint("TOP", DKPAmount, "BOTTOM", 0, -20)

local messageTitle = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
messageTitle:SetPoint("TOP", 0, 0)
messageTitle:SetText("Current Bid")

local messageText = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
messageText:SetPoint("TOP", messageTitle, "BOTTOM", 0, -10)
messageText:SetTextColor(0, 0.75, 1)  -- GM-like blue text
messageText:SetText("")
frame.messageText = messageText

local bidButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
bidButton:SetPoint("TOP", messageFrame, "BOTTOM", 0, -10)
bidButton:SetSize(180, 25)  -- Make the button wider by 15 units
frame.bidButton = bidButton

local allInButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
allInButton:SetPoint("TOP", bidButton, "BOTTOM", 0, -10)
allInButton:SetSize(180, 25)  -- Make the button wider by 15 units
allInButton:SetText("ALL IN")
frame.allInButton = allInButton

local customBidBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
customBidBox:SetSize(50, 25)
customBidBox:SetPoint("TOP", allInButton, "BOTTOM", -60, -10)
customBidBox:SetAutoFocus(false)
customBidBox:SetNumeric(true)
frame.customBidBox = customBidBox

local customBidButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
customBidButton:SetPoint("LEFT", customBidBox, "RIGHT", 10, 0)
customBidButton:SetSize(120, 25)  -- Make the button wider by 15 units
customBidButton:SetText("BID")
frame.customBidButton = customBidButton

local passButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
passButton:SetPoint("TOP", customBidButton, "BOTTOM", -32, -10)
passButton:SetSize(180, 25)  -- Make the button wider by 15 units
passButton:SetText("PASS")
frame.passButton = passButton

function core.updateMessageText(text)
    messageText:SetText(text)
    core.updateBidButton()
end

function core.updateBidButton()
    local currentBid = core.currentBid
    local playerName = UnitName("player")
    local bidAmount = config.data and config.data.bidAmount or 10
    local dkpValue = tonumber(core.gatherDKP())
    local newBidAmount = currentBid.amount + bidAmount

    if currentBid.amount == 0 then
        bidButton:SetText("NO ACTIVE BID")
        bidButton:Disable()
        allInButton:SetText("NO ACTIVE BID")
        allInButton:Disable()
        customBidButton:SetText("NO ACTIVE BID")
        customBidButton:Disable()
        passButton:SetText("NO ACTIVE BID")
        passButton:Disable()
    elseif dkpValue < newBidAmount then
        bidButton:SetText("NOT ENOUGH DKP")
        bidButton:Disable()
        allInButton:SetText("NOT ENOUGH DKP")
        allInButton:Disable()
        customBidButton:SetText("NOT ENOUGH DKP")
        customBidButton:Disable()
        passButton:SetText("PASS")
        passButton:Enable()
    elseif currentBid.player == playerName then
        bidButton:SetText("YOUR BID")
        bidButton:Disable()
        allInButton:SetText("YOUR BID")
        allInButton:Disable()
        customBidButton:SetText("YOUR BID")
        customBidButton:Disable()
        passButton:SetText("PASS")
        passButton:Enable()
    else
        bidButton:SetText("OUTBID " .. bidAmount)
        bidButton:Enable()
        allInButton:SetText("ALL IN")
        allInButton:Enable()
        customBidButton:SetText("BID")
        customBidButton:Enable()
        passButton:SetText("PASS")
        passButton:Enable()
    end
end

bidButton:SetScript("OnClick", function()
    local currentBid = core.currentBid
    local playerName = UnitName("player")
    local bidAmount = config.data and config.data.bidAmount or 10
    local dkpValue = tonumber(core.gatherDKP())
    local newBidAmount = currentBid.amount + bidAmount

    if dkpValue >= newBidAmount and (currentBid.amount == 0 or currentBid.player ~= playerName) then
        SendChatMessage(tostring(newBidAmount), "RAID")
    end
end)

allInButton:SetScript("OnClick", function()
    local currentBid = core.currentBid
    local playerName = UnitName("player")
    local dkpValue = tonumber(core.gatherDKP())

    if dkpValue > currentBid.amount and currentBid.player ~= playerName then
        SendChatMessage(tostring(dkpValue), "RAID")
    else
        print("NOT ENOUGH DKP")
    end
end)

customBidButton:SetScript("OnClick", function()
    local customBid = tonumber(customBidBox:GetText())
    local dkpValue = tonumber(core.gatherDKP())
    local newBidAmount = core.currentBid.amount + customBid
    if customBid and customBid > 0 and newBidAmount <= dkpValue and core.currentBid.player ~= UnitName("player") then
        SendChatMessage(tostring(newBidAmount), "RAID")
        customBidBox:ClearFocus()
        customBidBox:SetText("")
    else
        print("Invalid bid amount or insufficient DKP.")
    end
end)

passButton:SetScript("OnClick", function()
    SendChatMessage("pass", "RAID")
    bidButton:Disable()
    allInButton:Disable()
    customBidButton:Disable()
    passButton:Disable()
end)

itemSlot:SetScript("OnEnter", function(self)
    local itemLink = self.itemLink
    if itemLink then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end
end)

itemSlot:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

minimap.createMinimapButton(core.toggleFrame, config.toggleConfigFrame)

frame:SetScript("OnShow", function()
    local dkpValue = core.gatherDKP()
    if tonumber(dkpValue) then
        DKPAmount:SetText("Your net " .. dkpValue .. " DKP")
    else
        DKPAmount:SetText(dkpValue)
    end
    core.updateBidButton()
end)

frame:SetScript("OnHide", function() frame:Hide() end)

SLASH_DKPBidder1 = "/dkpbidder"
SlashCmdList["DKPBidder"] = core.toggleFrame