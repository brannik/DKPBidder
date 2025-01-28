DKP_CORE = {}

DKP_CORE.DkpAmount = 0
DKP_CORE.GuildName = ""
DKP_CORE.config = {}
DKP_CORE.activeBid = false
DKP_CORE.EventFrame = CreateFrame("Frame")
DKP_CORE.MSSellected = -1
DKP_CORE.MyData = {
    playerName = UnitName("player"),
    dkpAmount = 0,
    currentSpecIndex = 0,
    MSChange = DKP_CORE.MSSellected
}
-- /dump DKP_CORE.config
function DKP_CORE.LoadConfig()
    -- Initialize DKP_Config if it doesn't exist
    if not DKP_Config then
        DKP_Config = {}
    end

    -- Load the guild's config or use the default if none exists
    if DKP_Config[DKP_CORE.GuildName] then
        DKP_CORE.config = DKP_Config[DKP_CORE.GuildName]
        print("Configuration loaded for guild:", DKP_CORE.GuildName)
    
    end

    -- Optionally set the active specialization if SPEC_ICONS exists
    if SPEC_ICONS then
        DKP_CORE.MSSellected = SPEC_ICONS.GetActiveSpec()
    end
end

function DKP_CORE.SaveConfig()
    -- Ensure DKP_Config table exists
    if not DKP_Config then
        DKP_Config = {}
    end

    -- Save the current config to the guild's key
    DKP_Config[DKP_CORE.GuildName] = DKP_CORE.config
    print("Configuration saved for guild:", DKP_CORE.GuildName)
end
function DKP_CORE.GetGuildName()
    -- get guild name
    DKP_CORE.GuildName = GetGuildInfo("player") or "NO GUILD"
end
local function GetPlayerNote(playerName,officer)
    local numGuildMembers = GetNumGuildMembers()
        for i = 1, numGuildMembers do
            -- Retrieve guild member info
        local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if name == playerName then
            if officer and officer == true then
			    return officernote
			else
                return note
			end
        end
     end
end
local function NoteIsMainChar(note)
    if string.match(note,REGEX.strings.noteMainRegex) then
	    return note
	else
		return nil
	end
end
local function IsOfficer(playerName)
	return false
end
local function FindOfficerOnline()
    return "officerName"
end
local function ReqeustDkpFromOfficer(officerName)
    return "?dkp"
end
local function GetDkpFromNote(note)
    return string.match(note,REGEX.strings.noteDkpRegex) or 0
end
local function FindMainChar(mainName,officer)
    local numGuildMembers = GetNumGuildMembers(true)
        for i = 1, numGuildMembers do
            -- Retrieve guild member info
        local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if name == mainName then
            if officer and officer == true then
			    return officernote
			else
                return note
			end
        end
     end
end

function DKP_CORE.BackupDKP()
    DKP_Backup = tonumber(DKP_CORE.DkpAmount)
end
function DKP_CORE.RestoreDKP()
    if DKP_Backup and DKP_Backup ~= nil then
        DKP_CORE.DkpAmount = tonumber(DKP_Backup)
	else
	    DKP_Backup = 0
		DKP_CORE.DkpAmount = 0
	end
end

function DKP_CORE.UpdateLocalPlayerInfo()
    local playerName = UnitName("player")
    DKP_CORE.MyData.playerName = playerName
    DKP_CORE.MyData.dkpAmount = tonumber(DKP_CORE.DkpAmount)
    DKP_CORE.MyData.currentSpecIndex = SPEC_ICONS.GetActiveSpecIndex()
    if MS_Change then
	    if MS_Change == -1 then
		    DKP_CORE.MyData.MSChange = -1
		else
		    DKP_CORE.MyData.MSChange = tonumber(MS_Change)
		end
    else
        DKP_CORE.MyData.MSChange = -1
	end
    
end
function DKP_CORE.GatherDKP(manualRefresh)
    local manual
    if manualRefresh and manualRefresh ~= false then
	    manual = true
	else
		manual = false
	end
    
    
    local playerName = UnitName("player")

    if DKP_CORE.config and DKP_CORE.config.dkpStorage == "Public Note" then
	    local playerNote = GetPlayerNote(playerName)
        if NoteIsMainChar(playerNote) then
            local mainChar = FindMainChar(playerNote)
            local dkp = GetDkpFromNote(mainChar)
            DKP_CORE.DkpAmount = dkp
        else
            local dkp = GetDkpFromNote(playerNote)
            DKP_CORE.DkpAmount = dkp
		end
        DKP_CORE.BackupDKP()
        DKP_CORE.UpdateLocalPlayerInfo()
	end

    if DKP_CORE.config and DKP_CORE.config.dkpStorage == "Officer Note" then
	    if DKP_CORE.config and DKP_CORE.config.officerNoteVisible == true then
		    local playerNote = GetPlayerNote(playerName,true)
            if NoteIsMainChar(playerNote) then
                local mainChar = FindMainChar(playerNote,true)
                local dkp = GetDkpFromNote(mainChar)
                DKP_CORE.DkpAmount = dkp
            else
                local dkp = GetDkpFromNote(playerNote,true)
                DKP_CORE.DkpAmount = dkp
		    end
            DKP_CORE.BackupDKP()
            DKP_CORE.UpdateLocalPlayerInfo()
		end

        if DKP_CORE.config and DKP_CORE.config.officerNoteVisible == false then
		    if manual == true then
			    -- get officer and wisp him 
			end

            if manual == false then 
			    DKP_CORE.RestoreDKP()
			end
		end
	end
end

function DKP_CORE.FindPlayerOtherPlayerDKP(playerName)
    return 100
end

function DKP_CORE.FindPlayerDKP(playerName)
    if PLAYERS_ROOSTER then
	    if PLAYERS_ROOSTER[playerName] then
		    return string.format("|cffFFA500[DKP: %s]|r", PLAYERS_ROOSTER[playerName].dkpAmount)
        else
            return ""
		end
	else
        return ""
	end
    
end
