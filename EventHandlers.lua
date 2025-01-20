EVENTS = {}

local DKPEventFrame = CreateFrame("Frame")
local GLOBALEventsFrame = CreateFrame("Frame")

local function OnDKPMessageRecieved(self, event, message, sender)
    if event == "CHAT_MSG_WHISPER" then
        local dkp = string.match(message,REGEX.strings.dkpWhisperRegex) or 0
        if dkp ~= DKP_CORE.DkpAmount then
	        DKP_CORE.DkpAmount = dkp
            DKP_CORE.BackupDKP()
            DKP_UI.UpdateUI()
	    end
	end
end
local function OnGlobalWhisperRecieved(self, event, message, sender)
    if event == "CHAT_MSG_WHISPER" then
        local dkp = string.match(message,REGEX.strings.dkpWhisperRegex) or 0
        if dkp ~= DKP_CORE.DkpAmount then
	        DKP_CORE.DkpAmount = dkp
            DKP_CORE.BackupDKP()
            -- update other uis if any here
	    end
	end
end

function EVENTS.RegisterDKPEvents()
    DKPEventFrame:RegisterEvent("CHAT_MSG_WHISPER")
    DKPEventFrame:RegisterEvent("CHAT_MSG_RAID")
    DKPEventFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
    DKPEventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
    DKPEventFrame:SetScript("OnEvent", OnDKPMessageRecieved)
end

function EVENTS.UnregisterDKPEvents()
	DKPEventFrame:UnregisterEvent("CHAT_MSG_WHISPER")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
    DKPEventFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
end

function EVENTS.RegisterGlobalEvents()
    GLOBALEventsFrame:RegisterEvent("CHAT_MSG_WHISPER")
    GLOBALEventsFrame:SetScript("OnEvent", OnGlobalWhisperRecieved)
end
function EVENTS.UnregisterGlobalEvents()
    GLOBALEventsFrame:UnregisterEvent("CHAT_MSG_WHISPER")
end