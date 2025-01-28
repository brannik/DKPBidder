DKP_FRAME_UI = {}
local function SetupDKPFrame()
    local frame = DKPFrame
    if not frame then return end

    -- Apply backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })

    -- Set frame properties
    frame:SetBackdropColor(0, 0, 0, 0.8) -- Black background with 80% opacity
    frame:SetBackdropBorderColor(1, 1, 1, 1) -- White border

    -- Ensure the frame is shown
    frame:Show()
end
local eventFrame = CreateFrame("Frame")
local function OnFrameShown()
    if DKP_CORE.config and DKP_CORE.config.showDkpFrame == true then
        local text = _G["DKPFrameAmountText"]
        text:SetText("DKP: " .. DKP_CORE.DkpAmount)   
        SetupDKPFrame()
    else
        DKPFrame:Hide()
    end
end

local dkpUIFrameOnCharacter = _G["DKPFrame"]
if dkpUIFrameOnCharacter then
    -- Set the OnShow event handler for when the frame is shown
    dkpUIFrameOnCharacter:SetScript("OnShow", OnFrameShown)
else
    print("Error: DKPFrame frame not found.")
end


