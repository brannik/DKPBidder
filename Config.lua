local eventFrame = CreateFrame("Frame")

local function OnFrameShown()
    
end

-- Access the frame defined in XML using _G["Config"]
local ConfigFrame = _G["Config"]
if ConfigFrame then
    -- Set the OnShow event handler for when the frame is shown
    ConfigFrame:SetScript("OnShow", OnFrameShown)
else
    print("Error: Config frame not found.")
end

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        if ConfigFrame then
            ConfigFrame:Hide() -- Hide the frame initially
        end
    end
end)
