DKP_CORE = {}

DKP_CORE.DkpAmount = 0
DKP_CORE.GuildName = ""
DKP_CORE.config = {}
DKP_CORE.EventFrame = CreateFrame("Frame")

local function LoadConfig()
    -- load the config
end
function DKP_CORE.SaveConfig()
    -- save config
end
local function GetGuildName()
    -- get guild name
end
local function GetPlayerNote(playerName)
    -- read the note
end
local function NoteIsMainChar(note)
	return false
end
local function IsOfficer(playerName)
	return false
end
local function FindOfficerOnline()
    return "officerName"
end
local function ReqeustDkpFromOfficer(officerName)
    return "message whisper"
end
local function GetDkpFromWhisper(message)
    return 0
end
local function GetDkpFromNote(note)
    -- extract the dkp from note
end
local function FindMainChar(altName)
    -- find the dkp in main char
end
local function DkpStorage()
    return "Officer Note"
end
local function IsOfficerNoteVisible()
    return false
end
local function BackupDKP()

end
local function RestoreDKP()

end
local function RegisterConstantEvents()
    -- custom chat etc
end
local function UnregisterConstantEvents()
    -- custom chat etc
end
function DKP_CORE.GatherDKP(manualRefresh)
    local manual
    if manualRefresh then
	    manual = true
	else
		manual = false
	end
end

DKP_CORE.EventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
DKP_CORE.EventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        -- load config etc
    end
end)