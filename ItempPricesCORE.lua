ITEM_PRICES = {}

ITEM_PRICES.data = {}

function ITEM_PRICES.SaveItemData(itemLink, amount)
    -- Validate inputs
    if not itemLink or not amount then
        print("Error: Invalid input to SaveItemData. itemLink:", tostring(itemLink), "amount:", tostring(amount))
        return -- Exit the function early if inputs are invalid
    end

    -- Check if the item already exists in the data table
    if ITEM_PRICES.data[itemLink] then
        -- Update the min value if the new amount is smaller
        if amount < ITEM_PRICES.data[itemLink].min then
            ITEM_PRICES.data[itemLink].min = amount
        end
        -- Update the max value if the new amount is larger
        if amount > ITEM_PRICES.data[itemLink].max then
            ITEM_PRICES.data[itemLink].max = amount
        end
        -- Increment the drop count
        ITEM_PRICES.data[itemLink].drops = ITEM_PRICES.data[itemLink].drops + 1
    else
        -- Add a new entry for this item
        ITEM_PRICES.data[itemLink] = {
            min = amount,
            max = amount,
            drops = 1
        }
    end
    ITEM_PRICES.SaveData()
end

function ITEM_PRICES.LoadData()
    if not DKP_Items then
        -- Initialize DKP_Items if it doesn't exist
        DKP_Items = {}
    end

    if DKP_Items.ITEM_PRICES then
        -- Load saved data
        ITEM_PRICES.data = DKP_Items.ITEM_PRICES
        print("ITEM_PRICES data loaded.")
    else
        -- Initialize empty data if nothing is saved
        ITEM_PRICES.data = {}
        print("ITEM_PRICES data initialized.")
    end
end

-- Save the current data
function ITEM_PRICES.SaveData()
    if not DKP_Items then
        DKP_Items = {}
    end

    -- Save ITEM_PRICES.data into DKP_Items
    DKP_Items.ITEM_PRICES = ITEM_PRICES.data
    print("ITEM_PRICES data saved.")
end

-- Event handling to load and save data
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        -- Load the data when the addon is loaded
        ITEM_PRICES.LoadData()
    elseif event == "PLAYER_LOGOUT" then
        -- Save the data when the player logs out
        ITEM_PRICES.SaveData()
    end
end)