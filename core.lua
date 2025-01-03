DKPBidder_Core = {}

DKPBidder_Core.currentDKPvar = ""
DKPBidder_Core.bidStarter = ""
DKPBidder_Core.currentBid = { player = "", amount = 0 }

function DKPBidder_Core.toggleFrame()
    if DKPBidderFrame:IsShown() then
        DKPBidderFrame:Hide()
        DKPBidder_Core.unregisterRaidWarningListener()
    else
        DKPBidderFrame:Show()
        DKPBidder_Core.registerRaidWarningListener()
    end
end

function DKPBidder_Core.gatherDKP()
    if not IsInGuild() then
        DKPBidder_Core.currentDKPvar = "NO GUILD"
        return DKPBidder_Core.currentDKPvar
    end

    local playerName = UnitName("player")
    local note

    for i = 1, GetNumGuildMembers() do
        local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
        if name == playerName then
            if DKPBidder_Config.data.DKPLocation == "PublicNote" then
                note = publicNote
            elseif DKPBidder_Config.data.DKPLocation == "OfficerNote" then
                note = officerNote
            end
            break
        end
    end

    if not note or note == "" then
        DKPBidder_Core.currentDKPvar = "NO DKP"
        return DKPBidder_Core.currentDKPvar
    end

    local netTotPattern = "Net:(%d+) Tot:%d+"
    local nTHPattern = "N:(%d+) T:%d+ H:%d+"

    if note:match(netTotPattern) then
        DKPBidder_Core.currentDKPvar = note:match("Net:(%d+)")
    elseif note:match(nTHPattern) then
        DKPBidder_Core.currentDKPvar = note:match("N:(%d+)")
    elseif note:match("^%a+$") then  -- Check if the note is a single string (character name)
        for i = 1, GetNumGuildMembers() do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            if name == note then
                if DKPBidder_Config.data.DKPLocation == "PublicNote" then
                    note = publicNote
                elseif DKPBidder_Config.data.DKPLocation == "OfficerNote" then
                    note = officerNote
                end
                break
            end
        end
        if note:match(netTotPattern) then
            DKPBidder_Core.currentDKPvar = note:match("Net:(%d+)")
        elseif note:match(nTHPattern) then
            DKPBidder_Core.currentDKPvar = note:match("N:(%d+)")
        else
            DKPBidder_Core.currentDKPvar = "NO DKP"
        end
    else
        DKPBidder_Core.currentDKPvar = note:match("Net:(%d+)") or note:match("N:(%d+)") or "NO DKP"
    end

    return DKPBidder_Core.currentDKPvar
end

function DKPBidder_Core.onRaidWarningMessage(self, event, message, sender)
    if DKPBidderFrame:IsShown() then
        local startBidRegex = DKPBidder_Config.data and DKPBidder_Config.data.startBidRegex or "Bidding for (.+) started."
        local itemLink = message:match(startBidRegex)
        if itemLink then
            DKPBidder_Core.updateItemSlot(itemLink)
            DKPBidder_Core.updateBidStatusText("BID FOR")
            DKPBidder_Core.bidStarter = sender
            DKPBidder_Core.currentBid = { player = "", amount = 0 }
            DKPBidder_Core.updateMessageText("")
            DKPBidder_Core.unlockButtons()
        end
    end
end

function DKPBidder_Core.onRaidMessage(self, event, message, sender)
    if DKPBidderFrame:IsShown() then
        local stopBidRegex = DKPBidder_Config.data and DKPBidder_Config.data.stopBidRegex or "Bidding for .+ has been cancelled."
        if message:match(stopBidRegex) and sender == DKPBidder_Core.bidStarter then
            DKPBidder_Core.resetItemSlot()
            DKPBidder_Core.updateBidStatusText("NO ACTIVE BID")
        elseif message:match("^%d+$") then
            local bidAmount = tonumber(message)
            if bidAmount and bidAmount > DKPBidder_Core.currentBid.amount then
                DKPBidder_Core.currentBid = { player = sender, amount = bidAmount }
                DKPBidder_Core.updateMessageText(sender .. " - " .. bidAmount)
            end
        end
    end
end

function DKPBidder_Core.updateItemSlot(itemLink)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemLink)
    if itemTexture then
        _G["DKPBidderItemSlotIconTexture"]:SetTexture(itemTexture)
        _G["DKPBidderItemSlot"].itemLink = itemLink
        local r, g, b = GetItemQualityColor(itemRarity)
        _G["DKPBidderFrame"].itemText:SetText(itemName)
        _G["DKPBidderFrame"].itemText:SetTextColor(r, g, b)
    end
end

function DKPBidder_Core.resetItemSlot()
    _G["DKPBidderItemSlotIconTexture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    _G["DKPBidderItemSlot"].itemLink = nil
    _G["DKPBidderFrame"].itemText:SetText("No item selected")
    _G["DKPBidderFrame"].itemText:SetTextColor(1, 1, 1)
    DKPBidder_Core.updateBidStatusText("NO ACTIVE BID")
    DKPBidder_Core.updateMessageText("")
end

function DKPBidder_Core.updateBidStatusText(text)
    _G["DKPBidderFrame"].bidStatusText:SetText(text)
end

function DKPBidder_Core.updateMessageText(text)
    _G["DKPBidderFrame"].messageText:SetText(text)
end

function DKPBidder_Core.unlockButtons()
    local bidAmount = DKPBidder_Config.data and DKPBidder_Config.data.bidAmount or 10
    _G["DKPBidderFrame"].bidButton:SetText("BID " .. bidAmount)
    _G["DKPBidderFrame"].bidButton:Enable()
    _G["DKPBidderFrame"].allInButton:SetText("ALL IN")
    _G["DKPBidderFrame"].allInButton:Enable()
    _G["DKPBidderFrame"].customBidButton:SetText("BID")
    _G["DKPBidderFrame"].customBidButton:Enable()
    _G["DKPBidderFrame"].passButton:SetText("PASS")
    _G["DKPBidderFrame"].passButton:Enable()
end

function DKPBidder_Core.registerRaidWarningListener()
    if not DKPBidder_Core.raidWarningFrame then
        DKPBidder_Core.raidWarningFrame = CreateFrame("Frame")
        DKPBidder_Core.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
        DKPBidder_Core.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID")
        DKPBidder_Core.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
        DKPBidder_Core.raidWarningFrame:SetScript("OnEvent", function(self, event, message, sender)
            if event == "CHAT_MSG_RAID_WARNING" then
                DKPBidder_Core.onRaidWarningMessage(self, event, message, sender)
            elseif event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
                DKPBidder_Core.onRaidMessage(self, event, message, sender)
            end
        end)
    end
end

function DKPBidder_Core.unregisterRaidWarningListener()
    if DKPBidder_Core.raidWarningFrame then
        DKPBidder_Core.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
        DKPBidder_Core.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID")
        DKPBidder_Core.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
    end
end

function DKPBidder_Core.placeBid(bidAmount)
    local currentDKP = tonumber(DKPBidder_Core.gatherDKP())
    if currentDKP and bidAmount <= currentDKP then
        local newBidAmount = DKPBidder_Core.currentBid.amount + bidAmount
        SendChatMessage(newBidAmount, "RAID")
    else
        print("Insufficient DKP to place bid.")
    end
end

return DKPBidder_Core
