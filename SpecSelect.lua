

local eventFrame = CreateFrame("Frame")
MS_Change = MS_Change or -1

local specs = nil

local function OnFrameShown()
    local _, playerClass = UnitClass("player")
    specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)

    if specs[1] then
        local button = _G["specToggleOne"]
        button:SetNormalTexture(specs[1].icon) -- Set the icon as the button texture
    end

    if specs[2] then
        local button = _G["specToggleTwo"]
        button:SetNormalTexture(specs[2].icon) -- Set the icon as the button texture
    end

    if specs[3] then
        local button = _G["specToggleTree"]
        button:SetNormalTexture(specs[3].icon) -- Set the icon as the button texture
    end
    
    local text = _G["sellectedSpec"]

    if MS_Change == -1 then
        local activeSpec = SPEC_ICONS.GetActiveSpec()
        text:SetText("MS: " .. activeSpec.name)
	else
	    
        
        text:SetText("MS: " .. specs[MS_Change].name)
	end
    
    local btnAnnounce = _G["btnAnnounceMS"]
    btnAnnounce:SetScript("OnClick",function()
	    local spec = text:GetText()
        SendChatMessage(spec , "RAID")
	end)
end
local function OnFrameHidden()
    
end
-- Access the frame defined in XML using _G["DKPUI"]
local MSUI = _G["SpecSelect"]
if MSUI then
    -- Set the OnShow event handler for when the frame is shown
    MSUI:SetScript("OnShow", OnFrameShown)
    MSUI:SetScript("OnHide", OnFrameHidden)
else
    print("Error: MSUI frame not found.")
end

-- Register the ADDON_LOADED event
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        SpecSelect:Hide()
        local currentIndex = SPEC_ICONS.GetActiveSpecIndex()
        MS_Change = currentIndex
        DKP_CORE.UpdateLocalPlayerInfo()
    end
end)

-- Table to store the toggle buttons
local toggleButtons = {}



-- Function to toggle a button and deselect others
local function OneToggleButton_OnClick(self)
    local text = _G["sellectedSpec"]
    local _, playerClass = UnitClass("player")
    local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
    for index, button in pairs(toggleButtons) do
        if button == self then
            -- Select the clicked button
            
            --DKP_CORE.MSSellected = index -- Store the selected index, store in playervar !!!
            if MS_Change then
                local currentIndex = SPEC_ICONS.GetActiveSpecIndex()
                if index == currentIndex then
				    MS_Change = -1
				else
				    MS_Change = index
				end
			end
            DKP_CORE.UpdateLocalPlayerInfo()
            DKP_UI.UpdateUI()
            ADDON_COMUNICATION.SendMyData()

            button.selected = true
            
            -- Set backdrop for a green border
            button:SetBackdrop({
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- Border texture
                edgeSize = 10,
            })
            button:SetBackdropBorderColor(0, 1, 0) -- Green border
            text:SetText("MS: " .. specs[index].name)
            
        else
            -- Deselect all other buttons
            button.selected = false
            button:SetBackdrop(nil) -- Remove the border
            if button.glow then
                button.glow:Hide() -- Hide the glow
            end
        end
    end
end

-- Add buttons to the toggleButtons table
local function InitializeToggleButtons()
    -- Add your buttons here
    table.insert(toggleButtons, _G["specToggleOne"])
    table.insert(toggleButtons, _G["specToggleTwo"])
    table.insert(toggleButtons, _G["specToggleTree"])

    -- Assign the OnClick handler to each button
    for index, button in pairs(toggleButtons) do
        button:SetScript("OnClick", function()
            OneToggleButton_OnClick(button)
        end)
    end
end

-- Initialize the buttons (call this after creating your buttons)
InitializeToggleButtons()
