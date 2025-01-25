
local eventFrame = CreateFrame("Frame")

local function OnFrameShown()
   
end
local function OnFrameHidden()
    
end
-- Access the frame defined in XML using _G["DKPUI"]
local RFR = _G["RoosterFrame"]
if RFR then
    -- Set the OnShow event handler for when the frame is shown
    RFR:SetScript("OnShow", OnFrameShown)
    RFR:SetScript("OnHide", OnFrameHidden)
else
    print("Error: RFR frame not found.")
end

-- Register the ADDON_LOADED event
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        RoosterFrame:Hide()
    end
end)




