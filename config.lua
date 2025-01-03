DKPBidder_Config = {}

local configFrame = CreateFrame("Frame", "DKPBidderConfigFrame", UIParent)
configFrame:SetSize(300, 400)
configFrame:SetPoint("CENTER")
configFrame:Hide()

configFrame:SetBackdrop({
    bgFile = "Interface\\AchievementFrame\\UI-Achievement-Parchment",  -- Parchment-like background
    edgeFile = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
    tile = false,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})

configFrame:SetBackdropColor(1, 1, 1, 1)  -- Set background color to match parchment
configFrame:SetBackdropBorderColor(1, 1, 1, 1)  -- Ensure border is not transparent

local titleFrame = CreateFrame("Frame", nil, configFrame)
titleFrame:SetSize(256, 64)
titleFrame:SetPoint("TOP", configFrame, "TOP", 0, 30)

local titleTexture = titleFrame:CreateTexture(nil, "ARTWORK")
titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
titleTexture:SetAllPoints(titleFrame)

local leftGryphon = configFrame:CreateTexture(nil, "ARTWORK")
leftGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
leftGryphon:SetSize(90, 90)
leftGryphon:SetPoint("RIGHT", titleFrame, "LEFT", 80, 39)

local rightGryphon = configFrame:CreateTexture(nil, "ARTWORK")
rightGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
rightGryphon:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
rightGryphon:SetSize(90, 90)
rightGryphon:SetPoint("LEFT", titleFrame, "RIGHT", -80, 39)

local topLeftCorner = configFrame:CreateTexture(nil, "OVERLAY")
topLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topLeftCorner:SetSize(32, 32)
topLeftCorner:SetPoint("TOPLEFT", configFrame, "TOPLEFT", -8, 8)

local topRightCorner = configFrame:CreateTexture(nil, "OVERLAY")
topRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topRightCorner:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightCorner:SetSize(32, 32)
topRightCorner:SetPoint("TOPRIGHT", configFrame, "TOPRIGHT", 8, 8)

local bottomLeftCorner = configFrame:CreateTexture(nil, "OVERLAY")
bottomLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomLeftCorner:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftCorner:SetSize(32, 32)
bottomLeftCorner:SetPoint("BOTTOMLEFT", configFrame, "BOTTOMLEFT", -8, -8)

local bottomRightCorner = configFrame:CreateTexture(nil, "OVERLAY")
bottomRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomRightCorner:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightCorner:SetSize(32, 32)
bottomRightCorner:SetPoint("BOTTOMRIGHT", configFrame, "BOTTOMRIGHT", 8, -8)

local topMetal = configFrame:CreateTexture(nil, "OVERLAY")
topMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
topMetal:SetSize(256, 16)
topMetal:SetPoint("TOP", configFrame, "TOP", 0, 8)

local bottomMetal = configFrame:CreateTexture(nil, "OVERLAY")
bottomMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
bottomMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomMetal:SetSize(256, 16)
bottomMetal:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, -8)

local leftMetal = configFrame:CreateTexture(nil, "OVERLAY")
leftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
leftMetal:SetTexCoord(0, 1, 1, 0)  -- Rotate the texture 90 degrees
leftMetal:SetSize(16, 256)
leftMetal:SetPoint("LEFT", configFrame, "LEFT", -8, 0)

local rightMetal = configFrame:CreateTexture(nil, "OVERLAY")
rightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
rightMetal:SetTexCoord(0, 1, 0, 1)  -- Rotate the texture 90 degrees and flip horizontally
rightMetal:SetSize(16, 256)
rightMetal:SetPoint("RIGHT", configFrame, "RIGHT", 8, 0)

local topLeftMetal = configFrame:CreateTexture(nil, "OVERLAY")
topLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topLeftMetal:SetSize(32, 32)
topLeftMetal:SetPoint("TOPLEFT", configFrame, "TOPLEFT", -8, 8)

local topRightMetal = configFrame:CreateTexture(nil, "OVERLAY")
topRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topRightMetal:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightMetal:SetSize(32, 32)
topRightMetal:SetPoint("TOPRIGHT", configFrame, "TOPRIGHT", 8, 8)

local bottomLeftMetal = configFrame:CreateTexture(nil, "OVERLAY")
bottomLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomLeftMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftMetal:SetSize(32, 32)
bottomLeftMetal:SetPoint("BOTTOMLEFT", configFrame, "BOTTOMLEFT", -8, -8)

local bottomRightMetal = configFrame:CreateTexture(nil, "OVERLAY")
bottomRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomRightMetal:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightMetal:SetSize(32, 32)
bottomRightMetal:SetPoint("BOTTOMRIGHT", configFrame, "BOTTOMRIGHT", 8, -8)

configFrame:SetMovable(true)
configFrame:EnableMouse(true)

titleFrame:SetMovable(true)
titleFrame:EnableMouse(true)
titleFrame:RegisterForDrag("LeftButton")
titleFrame:SetScript("OnDragStart", function() configFrame:StartMoving() end)
titleFrame:SetScript("OnDragStop", function() configFrame:StopMovingOrSizing() end)

configFrame.title = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
configFrame.title:SetPoint("CENTER", titleFrame, "CENTER", 0, 12)
configFrame.title:SetText("Config")

local closeButton = CreateFrame("Button", nil, configFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", configFrame, "TOPRIGHT")

local dropdownTitle = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dropdownTitle:SetPoint("TOP", configFrame.title, "BOTTOM", 0, -20)
dropdownTitle:SetText("DKP Storage Location")

local dropdown = CreateFrame("Frame", "DKPBidderConfigDropdown", configFrame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOP", dropdownTitle, "BOTTOM", 0, -10)
UIDropDownMenu_SetWidth(dropdown, 150)
UIDropDownMenu_SetText(dropdown, "Select Note Type")

local function OnClick(self)
    UIDropDownMenu_SetSelectedID(dropdown, self:GetID())
    DKPBidder_Config.data.DKPLocation = self.value
end

local function initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "PublicNote"
    info.value = "PublicNote"
    info.func = OnClick
    info.checked = (DKPBidder_Config.data and DKPBidder_Config.data.DKPLocation == "PublicNote")
    UIDropDownMenu_AddButton(info, level)

    info.text = "OfficerNote"
    info.value = "OfficerNote"
    info.func = OnClick
    info.checked = (DKPBidder_Config.data and DKPBidder_Config.data.DKPLocation == "OfficerNote")
    UIDropDownMenu_AddButton(info, level)
end

UIDropDownMenu_Initialize(dropdown, initialize)

local startBidTitle = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
startBidTitle:SetPoint("TOP", dropdown, "BOTTOM", 0, -20)
startBidTitle:SetText("Start Bid Regex")

local startBidEditBox = CreateFrame("EditBox", nil, configFrame, "InputBoxTemplate")
startBidEditBox:SetSize(200, 20)
startBidEditBox:SetPoint("TOP", startBidTitle, "BOTTOM", 0, -10)
startBidEditBox:SetAutoFocus(false)
startBidEditBox:SetText(DKPBidder_Config.data and DKPBidder_Config.data.startBidRegex or "Bidding for (.+) started.")
startBidEditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
startBidEditBox:SetBackdropColor(0, 0, 0, 1)

local stopBidTitle = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
stopBidTitle:SetPoint("TOP", startBidEditBox, "BOTTOM", 0, -20)
stopBidTitle:SetText("Stop Bid Regex")

local stopBidEditBox = CreateFrame("EditBox", nil, configFrame, "InputBoxTemplate")
stopBidEditBox:SetSize(200, 20)
stopBidEditBox:SetPoint("TOP", stopBidTitle, "BOTTOM", 0, -10)
stopBidEditBox:SetAutoFocus(false)
stopBidEditBox:SetText(DKPBidder_Config.data and DKPBidder_Config.data.stopBidRegex or "Bidding for .+ has been cancelled.")
stopBidEditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
stopBidEditBox:SetBackdropColor(0, 0, 0, 1)

local bidAmountTitle = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
bidAmountTitle:SetPoint("TOP", stopBidEditBox, "BOTTOM", 0, -20)
bidAmountTitle:SetText("Bid Amount")

local bidAmountEditBox = CreateFrame("EditBox", nil, configFrame, "InputBoxTemplate")
bidAmountEditBox:SetSize(200, 20)
bidAmountEditBox:SetPoint("TOP", bidAmountTitle, "BOTTOM", 0, -10)
bidAmountEditBox:SetAutoFocus(false)
bidAmountEditBox:SetText(DKPBidder_Config.data and DKPBidder_Config.data.bidAmount or "10")
bidAmountEditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
bidAmountEditBox:SetBackdropColor(0, 0, 0, 1)

local saveButton = CreateFrame("Button", nil, configFrame, "GameMenuButtonTemplate")
saveButton:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, 20)
saveButton:SetSize(100, 25)
saveButton:SetText("Save")
saveButton:SetScript("OnClick", function()
    DKPBidder_Config.data.startBidRegex = startBidEditBox:GetText()
    DKPBidder_Config.data.stopBidRegex = stopBidEditBox:GetText()
    DKPBidder_Config.data.bidAmount = tonumber(bidAmountEditBox:GetText()) or 10
    DKPBidder_Config.saveConfig()
    print("Config saved!")
end)

function DKPBidder_Config.toggleConfigFrame()
    if configFrame:IsShown() then
        configFrame:Hide()
    else
        DKPBidder_Config.loadConfig()
        UIDropDownMenu_SetSelectedValue(dropdown, DKPBidder_Config.data.DKPLocation)
        UIDropDownMenu_SetText(dropdown, DKPBidder_Config.data.DKPLocation)
        startBidEditBox:SetText(DKPBidder_Config.data.startBidRegex or "Bidding for (.+) started.")
        stopBidEditBox:SetText(DKPBidder_Config.data.stopBidRegex or "Bidding for .+ has been cancelled.")
        bidAmountEditBox:SetText(DKPBidder_Config.data.bidAmount or "10")
        configFrame:Show()
    end
end

-- Example config data
DKPBidder_Config.data = {
    DKPLocation = "OfficerNote",
    minimapPosition = nil,
    startBidRegex = "Bidding for (.+) started.",
    stopBidRegex = "has been cancelled.",
    bidAmount = 10
}

function DKPBidder_Config.saveConfig()
    -- Save config data to SavedVariables
    DKPBidderSavedConfig = DKPBidder_Config.data
end

function DKPBidder_Config.loadConfig()
    -- Load config data from SavedVariables
    if DKPBidderSavedConfig then
        DKPBidder_Config.data = DKPBidderSavedConfig
    else
        -- Set default config if SavedVariables does not exist
        DKPBidder_Config.data = {
            DKPLocation = "OfficerNote",
            minimapPosition = nil,
            startBidRegex = "Bidding for (.+) started.",
            stopBidRegex = "has been cancelled.",
            bidAmount = 10
        }
    end
end

-- Load config on addon load
DKPBidder_Config.loadConfig()

return DKPBidder_Config
