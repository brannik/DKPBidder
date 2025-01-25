DKP_UI = {}
DKP_UI.CurentBidName = ""
DKP_UI.CurrentBidAmount = 0
DKP_UI.Activesession = false

local eventFrame = CreateFrame("Frame")

local function OnFrameShown()
    EVENTS.RegisterDKPEvents()
    DKP_CORE.GatherDKP(false)

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
	
    if MS_Change then
        if MS_Change == -1 then
		    local activeSpec = SPEC_ICONS.GetActiveSpec()
            local targetIcon = _G["specTexture"]
            if activeSpec then
                targetIcon:SetTexture(activeSpec.icon)
            end
        else
            local _, playerClass = UnitClass("player")
            local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
            if specs[MS_Change] then
                local icon = _G["specTexture"]
                icon:SetTexture(specs[MS_Change].icon)
            end
		end
	end

    local text = _G["itemPrices"]
    if text then
	    text:SetText("")
	end
    local currentBidText = _G["currentBidText"]
    if currentBidText then
	    currentBidText:SetText("")
	end
    DKP_UI.UpdateUI()
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
function DKP_UI.GetItemPrices(itemlink)
    local text = _G["itemPrices"]
    if text then
        if ITEM_PRICES.data and ITEM_PRICES.data[itemlink] then
            local min = ITEM_PRICES.data[itemlink].min
            local max = ITEM_PRICES.data[itemlink].max
            local drop = ITEM_PRICES.data[itemlink].drops
		    text:SetText("MIN: " .. min .. " MAX: " .. max .. "\nDROP: " .. drop)
		else
            text:SetText("No price history.")
		end
	    
	end
end
-- Reset the item in the slot (clear it and set it to the question mark icon)
function DKP_UI.ResetItemSlot()
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot then
        -- Set the item slot texture back to the question mark icon
        SetItemButtonTexture(itemSlot, "Interface\\Icons\\INV_Misc_QuestionMark")
        SetItemButtonCount(itemSlot, 0)  -- Reset the count to 0
        --SetItemButtonQuality(itemSlot, 0)  -- Remove the quality border
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
function DKP_UI.SetItemToSlot(itemLink)
    local itemSlot = _G["DKPUI_ItemSlot"]  -- Reference to your item slot
    if itemSlot and itemLink then
        -- Set the item's icon based on the itemLink
        local texture = itemSlot.texture
        if texture then
            -- Set the icon immediately
            texture:SetTexture(GetItemIcon(itemLink))  -- Set the icon based on item link
        end

        -- Optionally, set the item count (e.g., 1 item)
        SetItemButtonCount(itemSlot, 1)

        -- Try to get item information
        local function UpdateItemInfo()
            local itemName, _, _, itemQuality = GetItemInfo(itemLink)

            if itemQuality then
                -- Item information is available, update the item slot
                local borderTexture = "Interface\\Buttons\\UI-Quickslot"  -- Default no quality

                if itemQuality == 1 then
                    borderTexture = "Interface\\Buttons\\UI-Quickslot-Green"  -- Common quality
                elseif itemQuality == 2 then
                    borderTexture = "Interface\\Buttons\\UI-Quickslot-Blue"  -- Uncommon quality
                elseif itemQuality == 3 then
                    borderTexture = "Interface\\Buttons\\UI-Quickslot-Purple"  -- Rare quality
                elseif itemQuality == 4 then
                    borderTexture = "Interface\\Buttons\\UI-Quickslot-Orange"  -- Epic quality
                end

                -- Apply the normal texture (ensure the button is visually active)
                itemSlot:SetNormalTexture(borderTexture)

                -- Also set a highlight texture to make it look active
                local highlightTexture = "Interface\\Buttons\\UI-Quickslot-Highlight"  -- Active highlight
                itemSlot:SetHighlightTexture(highlightTexture)

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
                C_Timer.After(0.1, UpdateItemInfo)  -- Retry after 100ms
            end
        end

        -- Start the process of updating the item info
        UpdateItemInfo()
    end
end


local minBidAmount = 10

function DKP_UI.ManageButtons()
    local myName = UnitName("player")

    local outBidBtn = _G["btnOutBid"]
    local customBidBtn = _G["btnCustomBid"]
    local allInBtn = _G["btnBidAllin"]
    local customAmount = _G["DKPUIEditBox"]
    local passBtn = _G["btnPass"]

    if DKP_UI.Activesession == false then
	    outBidBtn:Disable()
        customBidBtn:Disable()
        allInBtn:Disable()
        passBtn:Disable()
        outBidBtn:SetText("NO BID")
        customBidBtn:SetText("NO BID")
        allInBtn:SetText("NO BID")
        passBtn:SetText("NO BID")

    elseif DKP_UI.Activesession == true then
        if DKP_UI.CurentBidName == myName then
	        outBidBtn:Disable()
            customBidBtn:Disable()
            allInBtn:Disable()
            passBtn:Enable()
            outBidBtn:SetText("Your bid")
            customBidBtn:SetText("Your bid")
            allInBtn:SetText("Your bid")
            passBtn:SetText("PASS")
	    end
        if DKP_UI.CurentBidName ~= myName then
            if tonumber(DKP_UI.CurrentBidAmount) == 0 then
		        if tonumber(DKP_CORE.DkpAmount) > tonumber(DKP_UI.CurrentBidAmount + minBidAmount) then
		            outBidBtn:Enable()
                    customBidBtn:Enable()
                    allInBtn:Enable()
                    passBtn:Enable()
                    outBidBtn:SetText("BID " .. minBidAmount)
                    customBidBtn:SetText("BID")
                    allInBtn:SetText("ALL IN " .. DKP_CORE.DkpAmount)
                    passBtn:SetText("PASS")

                    outBidBtn:SetScript("OnClick",function()
				        SendChatMessage(DKP_UI.CurrentBidAmount + minBidAmount, "RAID")
				    end)
                    customBidBtn:SetScript("OnClick",function()
                        local custAm = tonumber(customAmount:GetText())
                        if tonumber(DKP_CORE.DkpAmount) > tonumber(custAm) then
                            SendChatMessage(custAm, "RAID")
                        end
				    end)
                    allInBtn:SetScript("OnClick",function()
                        if tonumber(DKP_CORE.DkpAmount) > tonumber(DKP_UI.CurrentBidAmount) then
				            SendChatMessage(DKP_CORE.DkpAmount, "RAID")
                        end
				    end)
                    passBtn:SetScript("OnClick",function()
				        SendChatMessage("pass", "RAID")
				    end)
                else
                    outBidBtn:Disable()
                    customBidBtn:Disable()
                    allInBtn:Disable()
                    passBtn:Enable()
                    outBidBtn:SetText("NO DKP")
                    customBidBtn:SetText("NO DKP")
                    allInBtn:SetText("NO DKP")
                    passBtn:SetText("PASS")
	            end
		    else
                if tonumber(DKP_CORE.DkpAmount) > tonumber(DKP_UI.CurrentBidAmount + minBidAmount) then
		            outBidBtn:Enable()
                    customBidBtn:Enable()
                    allInBtn:Enable()
                    passBtn:Enable()
                    outBidBtn:SetText("OUTBID " .. minBidAmount)
                    customBidBtn:SetText("BID")
                    allInBtn:SetText("ALL IN " .. DKP_CORE.DkpAmount)
                    passBtn:SetText("PASS")

                    outBidBtn:SetScript("OnClick",function()
				        SendChatMessage(DKP_UI.CurrentBidAmount + minBidAmount, "RAID")
				    end)
                    customBidBtn:SetScript("OnClick",function()
                        local custAm = tonumber(customAmount:GetText())
                        if tonumber(DKP_CORE.DkpAmount) > tonumber(custAm) then
                            SendChatMessage(custAm, "RAID")
                        end
				    end)
                    allInBtn:SetScript("OnClick",function()
                        if tonumber(DKP_CORE.DkpAmount) > tonumber(DKP_UI.CurrentBidAmount) then
				            SendChatMessage(DKP_CORE.DkpAmount, "RAID")
                        end
				    end)
                    passBtn:SetScript("OnClick",function()
				        SendChatMessage("pass", "RAID")
				    end)
                else
                    outBidBtn:Disable()
                    customBidBtn:Disable()
                    allInBtn:Disable()
                    passBtn:Enable()
                    outBidBtn:SetText("NO DKP")
                    customBidBtn:SetText("NO DKP")
                    allInBtn:SetText("NO DKP")
                    passBtn:SetText("PASS")
	            end
		    end
        
	    end
	end

    
end

MS_Change = MS_Change or -1

function DKP_UI.UpdateUI()
    
    if DKPUI:IsShown() then
        DKP_UI.ManageButtons()
	    local dkpAmountText = _G["dkpAmount"]
        if dkpAmountText then
	        dkpAmountText:SetText("You have " .. DKP_CORE.DkpAmount .. " DKP")
	    end

        if MS_Change then
            if MS_Change == -1 then
		        local activeSpec = SPEC_ICONS.GetActiveSpec()
                local targetIcon = _G["specTexture"]
                if activeSpec then
                    targetIcon:SetTexture(activeSpec.icon)
                end
            else
                local _, playerClass = UnitClass("player")
                local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
                if specs[MS_Change] then
                    local icon = _G["specTexture"]
                    icon:SetTexture(specs[MS_Change].icon)
                end
		    end
	    end
        
        
        local currentBidText = _G["currentBidText"]
        if currentBidText then
            if DKP_UI.CurentBidName ~= "" then
                currentBidText:SetText(DKP_UI.CurentBidName .. " - " .. DKP_UI.CurrentBidAmount)
            end
	    end
        
	end
end
