local eventFrame = CreateFrame("Frame")
ROLL_UI = {}
ROLL_UI.rolls = {}

local function OnFrameShown()
    EVENTS.RegisterRollEvents()
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
    local rollBtn = _G["btnRoll"]
    rollBtn:SetScript("OnClick",function()
        local range = 100 
	    RollRandom(range)
	end)
    ROLL_UI.UpdateUI()
end
local function OnFrameHidden()
    ROLL_UI.rolls = {}
end

-- Access the frame defined in XML using _G["roll"]
local rollUIFrame = _G["roll"]
if rollUIFrame then
    -- Set the OnShow event handler for when the frame is shown
    rollUIFrame:SetScript("OnShow", OnFrameShown)
    rollUIFrame:SetScript("OnHide", OnFrameHidden)
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

function ROLL_UI.SetItemToSlot(itemLink)
    local itemSlot = _G["roll_ItemSlot"] -- Reference to your item slot
    if itemSlot and itemLink then
        -- Ensure the texture exists in the itemSlot
        if not itemSlot.texture then
            itemSlot.texture = itemSlot:CreateTexture(nil, "ARTWORK")
            itemSlot.texture:SetAllPoints(itemSlot) -- Match the size of the item slot
        end

        -- Get the item's icon from the itemLink and apply it
        local icon = GetItemIcon(itemLink)
        if icon then
            itemSlot.texture:SetTexture(icon) -- Set the icon texture
            itemSlot.texture:SetVertexColor(1, 1, 1) -- Ensure the icon is fully visible
        else
            print("Failed to retrieve icon for", itemLink)
        end

        if itemSlot then
            -- Clear textures to avoid inner square
            itemSlot:SetNormalTexture(nil)
            itemSlot:SetPushedTexture(nil)
            itemSlot:SetDisabledTexture(nil)

            -- Add hover effect if needed
            local highlightTexture = itemSlot:CreateTexture(nil, "HIGHLIGHT")
            highlightTexture:SetAllPoints(itemSlot)
            highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
            highlightTexture:SetBlendMode("ADD")
            itemSlot:SetHighlightTexture(highlightTexture)
        end

        -- Add a hover effect using a highlight texture
        if not itemSlot.hoverTexture then
            itemSlot.hoverTexture = itemSlot:CreateTexture(nil, "HIGHLIGHT")
            itemSlot.hoverTexture:SetAllPoints(itemSlot)
            itemSlot.hoverTexture:SetTexture("Interface\\Buttons\\UI-Quickslot-Highlight") -- Default highlight texture
            itemSlot.hoverTexture:SetBlendMode("ADD") -- Glow effect
        end
        itemSlot:SetHighlightTexture(itemSlot.hoverTexture)

        -- Try to get item information
        local function UpdateItemInfo()
            local itemName, _, _, itemQuality = GetItemInfo(itemLink)

            if itemQuality then
                

                -- Apply tooltip on hover
                itemSlot:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(itemSlot, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(itemLink)
                    GameTooltip:Show()
                end)

                -- Hide tooltip when mouse leaves
                itemSlot:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            else
                -- Retry after a short delay if item info is not available
                print("Item info is not available yet, retrying...")
                C_Timer.After(0.1, UpdateItemInfo) -- Retry after 100ms
            end
        end

        -- Start the process of updating the item info
        UpdateItemInfo()
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


local function updateRollsScrollFrame(rolls, frame)
    -- Ensure the frame is valid
    if not frame then
        print("rollsFrame not found!")
        return
    end

    -- Ensure the content frame exists
    local content = frame.content
    if not content then
        content = CreateFrame("Frame", nil, frame)
        content:SetSize(frame:GetWidth(), 1) -- Set initial size
        frame.content = content
        frame:SetScrollChild(content) -- Set the content as the scrollable child
    end

    -- Delete existing FontStrings (clear previous rolls)
    if content.rollFontStrings then
        for _, fontString in ipairs(content.rollFontStrings) do
            fontString:Hide() -- Hide the FontString
        end
        content.rollFontStrings = {} -- Clear the table
    end

    -- Ensure the scroll frame is refreshed before printing the table
    content:SetHeight(1) -- Set the content's height to a minimal value
    frame:UpdateScrollChildRect() -- Refresh the scroll frame

    -- Create a table to store new FontStrings if it doesn't exist
    if not content.rollFontStrings then
        content.rollFontStrings = {}
    end

    -- Sort the rolls by value in descending order
    local sortedRolls = {}
    for playerName, rollValue in pairs(rolls) do
        table.insert(sortedRolls, { name = playerName, value = rollValue })
    end
    table.sort(sortedRolls, function(a, b)
        return a.value > b.value
    end)

    -- Set up variables for positioning
    local yOffset = -10 -- Starting offset from the top
    local spacing = 20 -- Space between FontStrings

    -- Create a new FontString for each roll
    for _, roll in ipairs(sortedRolls) do
        -- Get the player's class color
        local class, classFileName = UnitClass(roll.name) -- Get the class name for the player
        local classColor = RAID_CLASS_COLORS[classFileName] -- Get the class color

        -- Define the color codes
        local classColorCode = classColor and ("|cff%02x%02x%02x"):format(classColor.r * 255, classColor.g * 255, classColor.b * 255) or "|cffffffff"
        local rollColorCode = "|cff00ff00" -- Green for roll value
        local neutralColorCode = "|cffffffff" -- White for neutral text

        -- Construct the text with color codes
        local coloredText = string.format(
            "%s%s%s rolled %s%d",
            classColorCode, roll.name, neutralColorCode, rollColorCode, roll.value
        )

        -- Create a new FontString
        local fontString = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fontString:SetWidth(content:GetWidth() - 20) -- Define the width for centering
        fontString:SetPoint("TOP", content, "TOP", 0, yOffset) -- Center horizontally
        fontString:SetText(coloredText)
        fontString:SetJustifyH("CENTER") -- Horizontally center the text within the FontString

        -- Store it for future cleanup
        table.insert(content.rollFontStrings, fontString)
        yOffset = yOffset - spacing -- Move to the next line
    end

    -- Adjust the scroll frame height based on the content
    local contentHeight = math.abs(yOffset) + 10
    content:SetHeight(contentHeight)
end


function ROLL_UI.UpdateUI()
-- Assuming rollsFrame is defined as a scrollable frame
    local rollsFrame = _G["rollsFrame"]

    local content = rollsFrame.content
    if not content then
        content = CreateFrame("Frame", nil, rollsFrame)
        content:SetSize(rollsFrame:GetWidth(), 1) -- Set initial size
        rollsFrame.content = content
        rollsFrame:SetScrollChild(content) -- Set the content as the scrollable child
    end

    -- Delete existing FontStrings (clear previous rolls)
    if content.rollFontStrings then
        for _, fontString in ipairs(content.rollFontStrings) do
            fontString:Hide() -- Hide the FontString
            -- fontString:SetParent(nil) -- Remove it from the parent
        end
        content.rollFontStrings = {} -- Clear the table
    end

    if rollsFrame then
        -- Ensure the content frame exists and refresh the scroll view
        if not rollsFrame.content then
            local content = CreateFrame("Frame", nil, rollsFrame)
            content:SetSize(rollsFrame:GetWidth(), 1) -- Set initial size
            rollsFrame.content = content
            rollsFrame:SetScrollChild(content) -- Set the content as the scrollable child
        end

        -- Refresh the scroll view before printing the table
        updateRollsScrollFrame(ROLL_UI.rolls, rollsFrame)
    else
        print("rollsFrame not found!")
    end

    
end
