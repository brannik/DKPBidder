local eventFrame = CreateFrame("Frame")

local function PopulateScrollFrame()
    -- Reference the ScrollFrame
    local scrollFrame = ScrollFrame
    if not scrollFrame then return end

    -- Create the ScrollChild if it doesn't exist
    if not scrollFrame.scrollChild then
        local scrollChild = CreateFrame("Frame", "ScrollFrameChild", scrollFrame)
        scrollChild:SetSize(scrollFrame:GetWidth(), 1) -- Height will adjust dynamically
        scrollFrame:SetScrollChild(scrollChild)
        scrollFrame.scrollChild = scrollChild
    end

    local scrollChild = scrollFrame.scrollChild

    -- Clear previous content
    for _, child in ipairs({scrollChild:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Constants for grid layout
    local ICON_SIZE = 45
    local PADDING = 30
    local VERTICAL_PADDING = 20
    local NUM_COLUMNS = 7
    local column = 0
    local row = 0

    -- Populate with ITEM_PRICES.data
    for itemLink, data in pairs(ITEM_PRICES.data) do
        -- Create item slot frame
        local itemSlot = CreateFrame("Button", nil, scrollChild, "ItemButtonTemplate")
        itemSlot:SetSize(ICON_SIZE, ICON_SIZE)
        itemSlot:SetPoint(
            "TOPLEFT",
            column * (ICON_SIZE + PADDING) + PADDING,
            -row * (ICON_SIZE + VERTICAL_PADDING * 3) - VERTICAL_PADDING
        )

        -- Style the item slot
        itemSlot:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-Slot-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 8,
        })
        itemSlot:SetBackdropColor(0, 0, 0, 0.5)

        -- Add the item icon
        local icon = itemSlot:CreateTexture(nil, "ARTWORK")
        local itemIcon = GetItemIcon(itemLink)
        if itemIcon then
            icon:SetTexture(itemIcon)
            icon:SetAllPoints()
            icon:SetVertexColor(1, 1, 1)
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark") -- Fallback icon
        end

        -- Add tooltip on hover
        itemSlot:SetScript("OnEnter", function()
            GameTooltip:SetOwner(itemSlot, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(itemLink)
            GameTooltip:Show()
        end)
        itemSlot:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        -- Create text below the item slot for additional data
        local itemText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        itemText:SetPoint("TOP", itemSlot, "BOTTOM", 0, -5)
        itemText:SetText(
            string.format("Min: %d\nMax: %d\nDrops: %d", data.min, data.max, data.drops)
        )
        itemText:SetJustifyH("CENTER")

        -- Adjust layout for the next item
        column = column + 1
        if column >= NUM_COLUMNS then
            column = 0
            row = row + 1
        end
    end

    -- Adjust the scroll child's height to fit the grid
    local numRows = math.ceil(table.getn(ITEM_PRICES.data) / NUM_COLUMNS)
    local contentHeight = numRows * (ICON_SIZE + VERTICAL_PADDING * 3) + VERTICAL_PADDING
    scrollChild:SetHeight(contentHeight)
end


local function OnFrameShown()
    PopulateScrollFrame()
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


