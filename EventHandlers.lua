EVENTS = {}

local DKPEventFrame = CreateFrame("Frame")
local GLOBALEventsFrame = CreateFrame("Frame")
local myName = UnitName("player")

local function OnDKPMessageRecieved(self, event, message, sender)
    if event == "CHAT_MSG_WHISPER" and sender ~= myName then
        local dkp = string.match(message,REGEX.strings.dkpWhisperRegex)
        local spend = string.match(message,REGEX.strings.spendRegex)
        if dkp ~= DKP_CORE.DkpAmount then
	        DKP_CORE.DkpAmount = dkp
            DKP_CORE.BackupDKP()
            DKP_UI.UpdateUI()
            ADDON_COMUNICATION.SendMyData()
	    end
        if spend then
	        DKP_CORE.DkpAmount = spend
            DKP_CORE.BackupDKP()
            DKP_UI.UpdateUI()
            ADDON_COMUNICATION.SendMyData()
	    end
	elseif event == "CHAT_MSG_RAID_WARNING" then
        -- start bid here
        local startBidMsg = string.match(message,REGEX.strings.rwBidStartRegex)
        if startBidMsg then
            if not DKPUI:IsShown() then
                
		        DKPUI:Show()
                DKP_UI.Activesession = true
                DKP_UI.SetItemToSlot(startBidMsg)
                DKP_UI.GetItemPrices(startBidMsg)
                DKP_UI.CurentBidName = ""
                DKP_UI.CurrentBidAmount = 0
                DKP_UI.ManageButtons()
                
            else
                DKP_UI.SetItemToSlot(startBidMsg)
                DKP_UI.GetItemPrices(startBidMsg)
                DKP_UI.CurentBidName = ""
                DKP_UI.CurrentBidAmount = 0
                DKP_UI.Activesession = true
                DKP_UI.ManageButtons()
			end
		end

        -- check won regex and store the data in ITEM_PRICES
        local playerName, itemLink, dkpAmount = string.match(message,REGEX.strings.reBidWonRegex)
        if playerName and itemLink and dkpAmount then
		    print(playerName .. " won " .. itemLink .. " with " .. dkpAmount)
            ITEM_PRICES.SaveItemData(itemLink,dkpAmount)
		end

        

    elseif event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID" then
	    -- BIDS HERE
        local isBidMessage = string.match(message,REGEX.strings.placeBidRegex)
        local isCancellBidMessage = string.match(message,REGEX.strings.rwBidCancellRegex)

        if isBidMessage then
            DKP_UI.CurentBidName = sender
            DKP_UI.CurrentBidAmount = isBidMessage
            DKP_UI.UpdateUI()
		end
        if isCancellBidMessage then
		    DKP_UI.CurentBidName = ""
            DKP_UI.CurrentBidAmount = 0
            DKP_UI.Activesession = false
            DKP_UI.ManageButtons()
            DKP_UI.ResetItemSlot()
            DKP_UI.UpdateUI()
		end

        -- check won regex and store the data in ITEM_PRICES
        local playerName, itemLink, dkpAmount = string.match(message,REGEX.strings.reBidWonRegex)
        if playerName and itemLink and dkpAmount then
		    print(playerName .. " won " .. itemLink .. " with " .. dkpAmount)
            ITEM_PRICES.SaveItemData(itemLink,dkpAmount)
		end
		   
	end
end



local function OnGlobalWhisperRecieved(self, event, message, sender)
    if event == "CHAT_MSG_WHISPER" and sender ~= myName then
        local dkp = string.match(message,REGEX.strings.dkpWhisperRegex)
        local spend = string.match(message,REGEX.strings.spendRegex)
        if dkp ~= DKP_CORE.DkpAmount then
	        DKP_CORE.DkpAmount = dkp
            DKP_CORE.BackupDKP()
            DKP_UI.UpdateUI()
            ADDON_COMUNICATION.SendMyData()
	    end
        if spend then
	        DKP_CORE.DkpAmount = spend
            DKP_CORE.BackupDKP()
            DKP_UI.UpdateUI()
            ADDON_COMUNICATION.SendMyData()
	    end
	elseif event == "PARTY_MEMBERS_CHANGED" then
    -- This event fires when a group (party/raid) roster changes
    local isInGroup = GetNumPartyMembers() > 0  -- Checks if you are in any party (party only)
    local isInRaid = GetNumRaidMembers() > 0      -- Checks if you are in a raid group
    
    if isInGroup then
        if isInRaid then
            print("|cff00ff00[DEBUG] You are now in a raid group.")
            EVENTS.RegisterDKPEvents()  -- Call raid-specific logic
        else
            print("|cff00ff00[DEBUG] You are now in a party.")
            EVENTS.UnregisterDKPEvents()  -- Call party-specific logic
        end
    else
        print("|cffff0000[ERROR] You are not in a group!")
        EVENTS.UnregisterDKPEvents()  -- No group, so unregister events
    end
end
end

local areDKPEventsRegistered = false 

function EVENTS.RegisterDKPEvents()
    if not areDKPEventsRegistered then  -- Only register if not already registered
        DKPEventFrame:RegisterEvent("CHAT_MSG_WHISPER")
        DKPEventFrame:RegisterEvent("CHAT_MSG_RAID")
        DKPEventFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
        DKPEventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
        DKPEventFrame:SetScript("OnEvent", OnDKPMessageRecieved)
        
        areDKPEventsRegistered = true  -- Mark events as registered
        print("|cff00ff00[DEBUG] DKP events successfully registered.")
    else
        print("|cffff0000[ERROR] DKP events are already registered.")
    end
end

function EVENTS.UnregisterDKPEvents()
    areDKPEventsRegistered = false 
	DKPEventFrame:UnregisterEvent("CHAT_MSG_WHISPER")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
end

function EVENTS.RegisterGlobalEvents()
    GLOBALEventsFrame:RegisterEvent("CHAT_MSG_WHISPER")
    GLOBALEventsFrame:RegisterEvent("CHAT_MSG_ADDON")
    GLOBALEventsFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
    GLOBALEventsFrame:SetScript("OnEvent", OnGlobalWhisperRecieved)
end
function EVENTS.UnregisterGlobalEvents()
    GLOBALEventsFrame:UnregisterEvent("CHAT_MSG_WHISPER")
end