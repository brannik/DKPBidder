local eventFrame = CreateFrame("Frame")

local function OnFrameShown()

    
end

-- Access the frame defined in XML using _G["roll"]
local rollUIFrame = _G["ItemPrices"]
if rollUIFrame then
    -- Set the OnShow event handler for when the frame is shown
    rollUIFrame:SetScript("OnShow", OnFrameShown)
else
    print("Error: roll frame not found.")
end

-- Register the ADDON_LOADED event
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        ItemPrices:Hide()
    end
end)


