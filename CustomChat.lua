CUSTOM_CHAT = {}

function CUSTOM_CHAT.CreateCustomRaidTab()
    local tabName = "CustomRaid"
    local found = false

    -- Check if the tab already exists
    for i = 1, NUM_CHAT_WINDOWS do
        local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(i)
        if name == tabName then
            found = true
            break
        end
    end

    if not found then
        -- Create a new chat tab
        local chatFrameIndex = FCF_OpenNewWindow(tabName)
        
        -- Customize the new chat tab
        local chatFrame = _G["ChatFrame" .. chatFrameIndex]
        if chatFrame then
            -- Uncheck all message types for the new tab
            ChatFrame_RemoveAllMessageGroups(chatFrame)
            
            -- Add only specific message types to the new tab
            ChatFrame_AddMessageGroup(chatFrame, "RAID")
            ChatFrame_AddMessageGroup(chatFrame, "RAID_LEADER")
            ChatFrame_AddMessageGroup(chatFrame, "SYSTEM")
            ChatFrame_AddMessageGroup(chatFrame, "RAID_WARNING")
            ChatFrame_AddMessageGroup(chatFrame, "PARTY")
            ChatFrame_AddMessageGroup(chatFrame, "PARTY_LEADER")

            -- Additional customization (e.g., text color, font size)
            chatFrame:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
            chatFrame:SetFading(false) -- Disable fading if desired
            
            print("Custom chat tab '" .. tabName .. "' has been created.")
        end
    else
        print("Chat tab '" .. tabName .. "' already exists.")
    end
end

-- Add custom message formatting and DKP handling
local function GetClassColor(class)
    local classColor
    if class == "WARRIOR" then
        classColor = "C79C6E"
    elseif class == "PALADIN" then
        classColor = "F58CBA"
    elseif class == "HUNTER" then
        classColor = "ABD473"
    elseif class == "ROGUE" then
        classColor = "FFF569"
    elseif class == "PRIEST" then
        classColor = "FFFFFF"
    elseif class == "DEATHKNIGHT" then
        classColor = "C41E3A"
    elseif class == "SHAMAN" then
        classColor = "0070DE"
    elseif class == "MAGE" then
        classColor = "69CCF0"
    elseif class == "WARLOCK" then
        classColor = "9482C9"
    elseif class == "MONK" then
        classColor = "00FF96"
    elseif class == "DRUID" then
        classColor = "FF7D0A"
    elseif class == "DEMONHUNTER" then
        classColor = "A330C9"
    end
    return classColor
end

local function createWhisperLink(playerName)
    local _, class = UnitClass(playerName)
    local classColor = GetClassColor(class)
    return string.format("|cff%s|Hplayer:%s|h[%s]|h|r", classColor, playerName, playerName)
end

local function addItemLinkTooltip(msg)
    -- Check if the message contains an item link
    if msg:match("|Hitem:.-|h%[.-%]|h|r") then
        -- If there's an item link, modify the message
        return msg:gsub("|Hitem:.-|h%[.-%]|h|r", function(itemLink)
            return itemLink  -- Or any additional formatting if needed
        end)
    else
        -- If there's no item link, return the message as it is
        return msg
    end
end

local function GetPlayerDKP(playerName)
    if DKP_CORE.config and DKP_CORE.config.showDkpInRaidChat == true then
        return DKP_CORE.FindPlayerDKP(playerName) 
	else
	    return ""
	end
end

local function sendMessageToTab(tabName, message)
    for i = 1, NUM_CHAT_WINDOWS do
        local chatTabName = _G["ChatFrame" .. i .. "Tab"]:GetText()
        if chatTabName == tabName then
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame then
                chatFrame:AddMessage(message)
            end
            break
        end
    end
end
local function GetPlayerMSIcon(playerName)
    if PLAYERS_ROOSTER then
	    if PLAYERS_ROOSTER[playerName] then
		    local _, playerClass = UnitClass(playerName)
            local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
            local icon = ""
            if PLAYERS_ROOSTER[playerName].MSChange == -1 then
			    icon = specs[PLAYERS_ROOSTER[playerName].currentSpecIndex].icon
			else
			    icon = specs[PLAYERS_ROOSTER[playerName].MSChange].icon
			end
            
            return icon
		end
	end
end
local function raidMessage(self, event, msg, author, ...)
    if not author or author == "" then return false end

    local raidFrameTabName = "CustomRaid"  -- Define custom tab name
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = "|cFFFF4800[DND]|r"
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"
    end

    local whisperLink = createWhisperLink(author)
    local dkpAmount = GetPlayerDKP(author)

    -- Only add the item link tooltip if there is an item link
    local itemLinkTooltip = addItemLinkTooltip(msg) or msg
    local raidIcon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp"  -- Custom raid icon for raid message
    local specIcon = ""  -- This will be empty by default
    
    if DKP_CORE.config and DKP_CORE.config.showMSInRaidChat == true then
	    specIcon = GetPlayerMSIcon(author)
	end

    -- Check if specIcon is not empty and construct the message accordingly
    local msSection = (specIcon ~= "") and string.format("|cFF00FF00[MS: |T%s:16|t] |r", specIcon) or ""

    -- Format the message with the icon before the item link tooltip and surrounded by square brackets
    local formattedMessage = string.format("|cffFF7F00%s|T%s:16|t%s%s|r: %s%s", 
        playerStatus,  -- Player's status (DND/AFK)
        raidIcon,  -- Raid icon
        whisperLink,
        dkpAmount,
        msSection,  -- MS section only included if specIcon is not empty
        itemLinkTooltip  -- Only modifies the message if there's an item link
    )

    sendMessageToTab(raidFrameTabName, formattedMessage)
    return true
end

local function raidLeader(self, event, msg, author, ...)
    if not author or author == "" then return false end

    local raidFrameTabName = "CustomRaid"
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = "|cFFFF4800[DND]|r"
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"
    end

    local whisperLink = createWhisperLink(author)
    local dkpAmount = GetPlayerDKP(author)

    -- Only add the item link tooltip if there is an item link
    local itemLinkTooltip = addItemLinkTooltip(msg) or msg
    local leaderIcon = "Interface\\GroupFrame\\UI-Group-LeaderIcon.blp"  -- Custom raid leader icon for raid leader message
    local specIcon = ""  -- This will be empty by default
    
    if DKP_CORE.config and DKP_CORE.config.showMSInRaidChat == true then
	    specIcon = GetPlayerMSIcon(author)
        print(specIcon)
	end

    -- Check if specIcon is not empty and construct the message accordingly
    local msSection = (specIcon ~= "") and string.format("|cFF00FF00[MS: |T%s:16|t] |r", specIcon) or ""

    -- Format the message with the icon before the item link tooltip and surrounded by square brackets
    local formattedMessage = string.format("|cff8B4800%s|T%s:16|t%s%s|r: %s%s", 
        playerStatus,
        leaderIcon,  -- Raid leader icon
        whisperLink,
        dkpAmount,
        msSection,  -- MS section only included if specIcon is not empty
        itemLinkTooltip  -- Only modifies the message if there's an item link
    )

    sendMessageToTab(raidFrameTabName, formattedMessage)
    return true
end

local function raidWarning(self, event, msg, author, ...)
    if not author or author == "" then return false end

    local raidFrameTabName = "CustomRaid"
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = "|cFFFF4800[DND]|r"
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"
    end

    local whisperLink = createWhisperLink(author)
    local dkpAmount = GetPlayerDKP(author)

    -- Only add the item link tooltip if there is an item link
    local itemLinkTooltip = addItemLinkTooltip(msg) or msg
    local warningIcon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp"  -- Custom raid warning icon for raid warning message
    local specIcon = ""  -- This will be empty by default
    
    if DKP_CORE.config and DKP_CORE.config.showMSInRaidChat == true then
	    specIcon = "Interface\Icons\INV_Misc_QuestionMark" -- get player MS from the rooster
	end

    -- Check if specIcon is not empty and construct the message accordingly
    local msSection = (specIcon ~= "") and string.format("|cFF00FF00[MS: |T%s:16|t] |r", specIcon) or ""

    -- Format the message with the icon before the item link tooltip and surrounded by square brackets
    local formattedMessage = string.format("|cFFFF4800%s|T%s:16|t%s%s|r: %s%s", 
        playerStatus,
        warningIcon,  -- Raid warning icon
        whisperLink,
        dkpAmount,
        msSection,  -- MS section only included if specIcon is not empty
        itemLinkTooltip  -- Only modifies the message if there's an item link
    )

    sendMessageToTab(raidFrameTabName, formattedMessage)
    return true
end



function CUSTOM_CHAT.registerFilters()
    -- Register filters for raid chat events
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", raidMessage)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", raidLeader)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", raidWarning)
end

function CUSTOM_CHAT.unregisterFilters()
    -- Unregister filters for raid chat events
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", raidMessage)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", raidLeader)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", raidWarning)
end

