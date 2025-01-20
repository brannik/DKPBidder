DKP_UI = {}

local eventFrame = CreateFrame("Frame")

local function OnFrameShown()
    EVENTS.RegisterDKPEvents()
    DKP_UI.UpdateUI()
    -- Ensure that DKPUIEditBox exists before trying to use it
    local editBox = _G["DKPUIEditBox"]
    if editBox then
        -- Set the default text (e.g., '123')
        editBox:SetText("123")
    else
        print("Error: DKPUIEditBox not found.")
    end
    
	editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    -- Reference the itemSlot here, after the frame is shown
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot then
        InitializeItemSlot(itemSlot)  -- Initialize the item slot with the question mark icon
        
        -- Set tooltip behavior for the item slot
        itemSlot:SetScript("OnEnter", function(self)
            local itemID = self:GetID()
            if itemID and itemID ~= 0 then  -- Only show tooltip if the item is set
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetItemByID(itemID)  -- Use this if item is set by ID
                GameTooltip:Show()
            end
        end)
        
        itemSlot:SetScript("OnLeave", function()
            GameTooltip:Hide()  -- Hide tooltip when mouse leaves
        end)
    else
        print("Error: DKPUI_ItemSlot not found. Check your XML definition.")
    end

    local dkpAmountText = _G["dkpAmount"]
    if dkpAmountText then
	    dkpAmountText:SetText("You have " .. DKP_CORE.DkpAmount .. " DKP")
	end
end
local function OnFrameHidden()
    EVENTS.UnregisterDKPEvents()
end
-- Access the frame defined in XML using _G["DKPUI"]
local dkpUIFrame = _G["DKPUI"]
if dkpUIFrame then
    -- Set the OnShow event handler for when the frame is shown
    dkpUIFrame:SetScript("OnShow", OnFrameShown)
    dkpUIFrame:SetScript("OnHide", OnFrameHidden)
else
    print("Error: DKPUI frame not found.")
end

-- Register the ADDON_LOADED event
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        DKPUI:Hide()
    end
end)

-- Set the item in the item slot
function SetItemToSlot(itemLink)
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot and itemLink then
        -- Use SetItemButtonTexture to set the item's icon based on the itemLink
        SetItemButtonTexture(itemSlot, itemLink)

        -- Optionally, set the item count (e.g., 1 item)
        SetItemButtonCount(itemSlot, 1)

        -- Optional: Set the item quality border
        local itemID = GetItemInfoInstant(itemLink)
        local _, _, quality = GetItemInfo(itemID)
        SetItemButtonQuality(itemSlot, quality)
    end
end

-- Reset the item in the slot (clear it and set it to the question mark icon)
function ResetItemSlot()
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot then
        -- Set the item slot texture back to the question mark icon
        SetItemButtonTexture(itemSlot, "Interface\\Icons\\INV_Misc_QuestionMark")
        SetItemButtonCount(itemSlot, 0)  -- Reset the count to 0
        SetItemButtonQuality(itemSlot, 0)  -- Remove the quality border
    end
end

-- Initialize the item slot with the question mark icon
function InitializeItemSlot(itemSlot)
    if itemSlot then
        -- Set the default texture to the question mark icon
        local texture = itemSlot:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(itemSlot)
        texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        itemSlot.texture = texture  -- Store the texture for later use
        
        -- Set count to 0 initially
        SetItemButtonCount(itemSlot, 0)
    end
end

-- Set the item in the item slot
function SetItemToSlot(itemLink)
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot and itemLink then
        -- Set the item's icon based on the itemLink
        local texture = itemSlot.texture
        if texture then
            texture:SetTexture(GetItemIcon(itemLink))  -- Set the icon based on item link
        end

        -- Optionally, set the item count (e.g., 1 item)
        SetItemButtonCount(itemSlot, 1)

        -- Optional: Set the item quality border manually
        local itemID = GetItemInfoInstant(itemLink)
        local _, _, quality = GetItemInfo(itemID)

        -- You can manually set a different texture for the border based on item quality
        local borderTexture = "Interface\\Buttons\\UI-Quickslot"  -- Default no quality
        if quality == 1 then
            borderTexture = "Interface\\Buttons\\UI-Quickslot-Green"  -- Common quality
        elseif quality == 2 then
            borderTexture = "Interface\\Buttons\\UI-Quickslot-Blue"  -- Uncommon quality
        elseif quality == 3 then
            borderTexture = "Interface\\Buttons\\UI-Quickslot-Purple"  -- Rare quality
        elseif quality == 4 then
            borderTexture = "Interface\\Buttons\\UI-Quickslot-Orange"  -- Epic quality
        end
        
        -- Apply the border texture manually
        itemSlot:SetNormalTexture(borderTexture)
    end
end

function DKP_UI.UpdateUI()
    
    if DKPUI:IsShown() then
	    local dkpAmountText = _G["dkpAmount"]
        if dkpAmountText then
	        dkpAmountText:SetText("You have " .. DKP_CORE.DkpAmount .. " DKP")
	    end
	end
end
