DKP_CORE = {}

DKP_CORE.DkpAmount = 0
DKP_CORE.GuildName = ""
DKP_CORE.config = {}
DKP_CORE.activeBid = false
DKP_CORE.EventFrame = CreateFrame("Frame")

local function LoadConfig()
    -- load the config
    -- Load the guild's config or use the default if none exists
    if DKP_Config and DKP_Config[DKP_CORE.GuildName] then
        self.config = DKP_Config[DKP_CORE.GuildName]
        print("Configuration loaded for guild:", DKP_CORE.GuildName)
    else
        self.config = CONFIG.defaultConfig
        print("Default configuration loaded for guild:", DKP_CORE.GuildName)
    end
end
function DKP_CORE.SaveConfig()
    -- save config

    -- Save the current config to DKP_Config under the guild's name
    if not DKP_Config then
        DKP_Config = {}
    end
    DKP_Config[DKP_CORE.GuildName] = self.config
    print("Configuration saved for guild:", DKP_CORE.GuildName)
end
function DKP_CORE.GetGuildName()
    -- get guild name
    DKP_CORE.GuildName = GetGuildInfo("player") or "NO GUILD"
end
local function GetPlayerNote(playerName)
    -- read the note
end
local function NoteIsMainChar(note)
	local isName = string.match(note,REGEX.strings.noteMainRegex) ~= nil
    if isName then 
	    return true
	else
		return false
	end
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
function DKP_CORE.BackupDKP()
    DKP_Backup = DKP_CORE.DkpAmount
end
function DKP_CORE.RestoreDKP()
    if DKP_Backup and DKP_Backup ~= nil then
        DKP_CORE.DkpAmount = DKP_Backup
	else
	    DKP_Backup = 0
		DKP_CORE.DkpAmount = 0
	end
end
local function RegisterConstantEvents()
    -- custom chat etc
end
local function UnregisterConstantEvents()
    -- custom chat etc
end
function DKP_CORE.GatherDKP(manualRefresh)
    local manual
    if manualRefresh and manualRefresh ~= false then
	    manual = true
	else
		manual = false
	end
    DKP_CORE.RestoreDKP()
end


DKP_CORE.EventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
DKP_CORE.EventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        -- load config etc
    end
end)