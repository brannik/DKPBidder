local eventFrame = CreateFrame("Frame")

local function OnFrameShown()

    -- Reference the itemSlot here, after the frame is shown
    local ritemSlot = _G["roll_ItemSlot"]  -- Reference to your item slot
    if ritemSlot then
        InitializeItemSlot(ritemSlot)  -- Initialize the item slot with the question mark icon
        
        -- Set tooltip behavior for the item slot
        ritemSlot:SetScript("OnEnter", function(self)
            local ritemID = self:GetID()
            if ritemID and ritemID ~= 0 then  -- Only show tooltip if the item is set
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetItemByID(ritemID)  -- Use this if item is set by ID
                GameTooltip:Show()
            end
        end)
        
        ritemSlot:SetScript("OnLeave", function()
            GameTooltip:Hide()  -- Hide tooltip when mouse leaves
        end)
    else
        print("Error: roll_ItemSlot not found. Check your XML definition.")
    end
end

-- Access the frame defined in XML using _G["roll"]
local rollUIFrame = _G["roll"]
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
        roll:Hide()
    end
end)

-- Set the item in the item slot
function SetItemToSlot(ritemLink)
    local ritemSlot = _G["roll_ItemSlot"]  -- Reference to your item slot
    if ritemSlot and ritemLink then
        -- Use SetItemButtonTexture to set the item's icon based on the itemLink
        SetItemButtonTexture(ritemSlot, ritemLink)

        -- Optionally, set the item count (e.g., 1 item)
        SetItemButtonCount(ritemSlot, 1)

        -- Optional: Set the item quality border
        local ritemID = GetItemInfoInstant(ritemLink)
        local _, _, quality = GetItemInfo(ritemID)
        SetItemButtonQuality(ritemSlot, quality)
    end
end

-- Reset the item in the slot (clear it and set it to the question mark icon)
function ResetItemSlot()
    local ritemSlot = _G["roll_ItemSlot"]  -- Reference to your item slot
    if ritemSlot then
        -- Set the item slot texture back to the question mark icon
        SetItemButtonTexture(ritemSlot, "Interface\\Icons\\INV_Misc_QuestionMark")
        SetItemButtonCount(ritemSlot, 0)  -- Reset the count to 0
        SetItemButtonQuality(ritemSlot, 0)  -- Remove the quality border
    end
end

-- Initialize the item slot with the question mark icon
function InitializeItemSlot(ritemSlot)
    if ritemSlot then
        -- Set the default texture to the question mark icon
        local texture = ritemSlot:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(ritemSlot)
        texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        ritemSlot.texture = texture  -- Store the texture for later use
        
        -- Set count to 0 initially
        SetItemButtonCount(ritemSlot, 0)
    end
end

-- Set the item in the item slot
function SetItemToSlot(ritemLink)
    local ritemSlot = _G["roll_ItemSlot"]  -- Reference to your item slot
    if ritemSlot and ritemLink then
        -- Set the item's icon based on the itemLink
        local texture = ritemSlot.texture
        if texture then
            texture:SetTexture(GetItemIcon(ritemLink))  -- Set the icon based on item link
        end

        -- Optionally, set the item count (e.g., 1 item)
        SetItemButtonCount(ritemSlot, 1)

        -- Optional: Set the item quality border manually
        local itemID = GetItemInfoInstant(ritemLink)
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
        ritemSlot:SetNormalTexture(borderTexture)
    end
end
