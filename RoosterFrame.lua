ROOSTER_UI = {}
local eventFrame = CreateFrame("Frame")

local function OnFrameShown()
    local checkShowGuild = _G["chkShowGuildRooster"]
    local checkShowRaid = _G["chkShowRaidRooster"]
    
    checkShowGuild:SetChecked(true)
    checkShowRaid:SetChecked(false)

    checkShowGuild:SetScript("OnClick",function()
	    checkShowRaid:SetChecked(false)
        ROOSTER_UI.UpdateFrame()
	end)

    checkShowRaid:SetScript("OnClick",function()
	    checkShowGuild:SetChecked(false)
        ROOSTER_UI.UpdateFrame()
	end)

    ROOSTER_UI.UpdateFrame()
end
local function OnFrameHidden()
    
end
-- Access the frame defined in XML using _G["DKPUI"]
local RFR = _G["RoosterFrame"]
if RFR then
    -- Set the OnShow event handler for when the frame is shown
    RFR:SetScript("OnShow", OnFrameShown)
    RFR:SetScript("OnHide", OnFrameHidden)
else
    print("Error: RFR frame not found.")
end

-- Register the ADDON_LOADED event
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        RoosterFrame:Hide()
    end
end)

local function PopulateRoosterScrollFrame()
    -- Reference the ScrollFrame
    local scrollFrame = scrollRoosterFrame
    if not scrollFrame then return end

    -- Create the ScrollChild if it doesn't exist
    if not scrollFrame.scrollChild then
        local scrollChild = CreateFrame("Frame", "ScrollRoosterChild", scrollFrame)
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

    -- Constants for layout
    local ROW_HEIGHT = 20
    local PADDING = 10
    local yOffset = -PADDING -- Start offset

    -- Column widths
    local playerNameWidth = 100
    local dkpWidth = 120
    local iconWidth = 25

    -- Helper function to get class color
    local function GetClassColor(className)
        local classColors = {
            WARRIOR = "|cffc79c6e",
            MAGE = "|cff40c7eb",
            ROGUE = "|cfffff569",
            DRUID = "|cffff7d0a",
            HUNTER = "|cffabd473",
            SHAMAN = "|cff0070de",
            PRIEST = "|cffffffff",
            WARLOCK = "|cff8787ed",
            PALADIN = "|cfff58cba",
            DEATHKNIGHT = "|cffc41f3b",
        }
        return classColors[className] or "|cffffffff"
    end

    -- Create headers
    local headerFrame = CreateFrame("Frame", nil, scrollChild)
    headerFrame:SetSize(scrollChild:GetWidth(), ROW_HEIGHT)
    headerFrame:SetPoint("TOPLEFT", 0, yOffset)

    local playerNameHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerNameHeader:SetPoint("LEFT", 10, 0)
    playerNameHeader:SetText("Name")
    playerNameHeader:SetWidth(playerNameWidth)

    local dkpHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dkpHeader:SetPoint("LEFT", playerNameHeader, "RIGHT", 10, 0)
    dkpHeader:SetText("DKP")
    dkpHeader:SetWidth(dkpWidth)

    local iconHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconHeader:SetPoint("LEFT", dkpHeader, "RIGHT", 10, 0)
    iconHeader:SetText("MS")
    iconHeader:SetWidth(iconWidth)

    -- Adjust yOffset for the next row (after the header)
    yOffset = yOffset - (ROW_HEIGHT + PADDING)

    -- Fetch all online guild members
    for i = 1, GetNumGuildMembers() do
        local name, rank, rankIndex, level, class, zone, note, 
        officernote, online, status, classFileName, 
        achievementPoints, achievementRank, isMobile, isSoREligible, standingID = GetGuildRosterInfo(i)

        if online then
            -- Remove server name from player name if present
            name = strsplit("-", name)

            -- Check if the player is in PLAYERS_ROOSTER
            local playerData = PLAYERS_ROOSTER[name]

            -- Create a frame for each row
            local rowFrame = CreateFrame("Frame", nil, scrollChild)
            rowFrame:SetSize(scrollChild:GetWidth(), ROW_HEIGHT)
            rowFrame:SetPoint("TOPLEFT", 0, yOffset)

            -- Create player name text (left-aligned)
            local playerDataText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            playerDataText:SetPoint("LEFT", 10, 0)
            playerDataText:SetFont("Fonts\\FRIZQT__.TTF", 14) -- Increase font size
            playerDataText:SetWidth(playerNameWidth)  -- Fixed width for name column
            playerDataText:SetJustifyH("LEFT") -- Ensure text is left-aligned

            -- Create DKP text (left-aligned)
            local dkpAmountText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            dkpAmountText:SetPoint("LEFT", playerDataText, "RIGHT", 10, 0)
            dkpAmountText:SetWidth(dkpWidth)  -- Fixed width for DKP column
            dkpAmountText:SetJustifyH("LEFT") -- Ensure text is left-aligned

            -- Create spec icon (ensure it's a valid texture object)
            local specIcon = rowFrame:CreateTexture(nil, "OVERLAY")
            specIcon:SetSize(25, 25)
            specIcon:SetPoint("LEFT", dkpAmountText, "RIGHT", 10, 0)
            specIcon:SetWidth(iconWidth)  -- Fixed width for icon column

            -- Ensure specIcon is a valid texture and set the script only if it's valid
            if specIcon.SetScript then
                specIcon:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    local specName = ""
                    if playerData then
                        local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(classFileName)
                        if playerData.MSChange == -1 then
                            specName = specs[playerData.currentSpecIndex].name
                        else
                            specName = specs[playerData.MSChange].name
                        end
                    end
                    GameTooltip:SetText(specName or "Unknown Spec", 1, 1, 1)
                    GameTooltip:Show()
                end)

                specIcon:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                end)
            end

            if playerData then
                -- Player exists in PLAYERS_ROOSTER: Print their info
                playerDataText:SetText(string.format("%s%s|r", GetClassColor(classFileName), name))
                dkpAmountText:SetText(string.format("DKP: %d", playerData.dkpAmount or 0))

                -- Get the spec icon
                local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(classFileName)
                local icon = ""
                if playerData.MSChange == -1 then
                    icon = specs[playerData.currentSpecIndex].icon
                else
                    icon = specs[playerData.MSChange].icon
                end
                specIcon:SetTexture(icon)

            else
                -- Player is not in PLAYERS_ROOSTER: Add their name in class color and show DKP if available
                local DKP = DKP_CORE.FindPlayerOtherPlayerDKP(name)
                playerDataText:SetText(string.format("%s%s|r", GetClassColor(classFileName), name))
                dkpAmountText:SetText(string.format("[DKP: %d]", DKP or 0))
                
                -- Add spec icon (question mark for unknown)
                specIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end

            -- Adjust yOffset for the next row
            yOffset = yOffset - (ROW_HEIGHT + PADDING)
        end
    end

    -- Adjust the scroll child's height to fit the content
    local contentHeight = math.abs(yOffset) + PADDING
    scrollChild:SetHeight(contentHeight)
end

local function PopulateWitchRaid()
    -- Reference the ScrollFrame
    local scrollFrame = scrollRoosterFrame
    if not scrollFrame then return end

    -- Create the ScrollChild if it doesn't exist
    if not scrollFrame.scrollChild then
        local scrollChild = CreateFrame("Frame", "ScrollRoosterChild", scrollFrame)
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

    -- Constants for layout
    local ROW_HEIGHT = 20
    local PADDING = 10
    local yOffset = -PADDING -- Start offset

    -- Column widths
    local playerNameWidth = 100
    local dkpWidth = 120
    local iconWidth = 25

    -- Helper function to get class color
    local function GetClassColor(className)
        local classColors = {
            WARRIOR = "|cffc79c6e",
            MAGE = "|cff40c7eb",
            ROGUE = "|cfffff569",
            DRUID = "|cffff7d0a",
            HUNTER = "|cffabd473",
            SHAMAN = "|cff0070de",
            PRIEST = "|cffffffff",
            WARLOCK = "|cff8787ed",
            PALADIN = "|cfff58cba",
            DEATHKNIGHT = "|cffc41f3b",
        }
        return classColors[className] or "|cffffffff"
    end

    -- Create headers
    local headerFrame = CreateFrame("Frame", nil, scrollChild)
    headerFrame:SetSize(scrollChild:GetWidth(), ROW_HEIGHT)
    headerFrame:SetPoint("TOPLEFT", 0, yOffset)

    local playerNameHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerNameHeader:SetPoint("LEFT", 10, 0)
    playerNameHeader:SetText("Name")
    playerNameHeader:SetWidth(playerNameWidth)

    local dkpHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dkpHeader:SetPoint("LEFT", playerNameHeader, "RIGHT", 10, 0)
    dkpHeader:SetText("DKP")
    dkpHeader:SetWidth(dkpWidth)

    local iconHeader = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconHeader:SetPoint("LEFT", dkpHeader, "RIGHT", 10, 0)
    iconHeader:SetText("MS")
    iconHeader:SetWidth(iconWidth)

    -- Adjust yOffset for the next row (after the header)
    yOffset = yOffset - (ROW_HEIGHT + PADDING)

    -- Fetch all players in the raid or party
    local numMembers
    if GetNumRaidMembers() > 0 then
        numMembers = GetNumRaidMembers()
    elseif GetNumPartyMembers() > 0 then
        numMembers = GetNumPartyMembers() + 1  -- +1 for the player themselves
    else
        numMembers = 0
    end

    for i = 1, numMembers do
        local name, _, _, _, class, _, _, online

        -- Get raid member information
        if GetNumRaidMembers() > 0 then
            name, _, _, _, class, _, _, online = GetRaidRosterInfo(i)
        end

        -- For party members, fall back to UnitName and UnitClass
        if not name then
            name = UnitName("player")
            class = UnitClass("player")
        end

        if online then
            -- Remove server name from player name if present
            name = strsplit("-", name)

            -- Check if the player is in PLAYERS_ROOSTER
            local playerData = PLAYERS_ROOSTER[name]

            -- Create a frame for each row
            local rowFrame = CreateFrame("Frame", nil, scrollChild)
            rowFrame:SetSize(scrollChild:GetWidth(), ROW_HEIGHT)
            rowFrame:SetPoint("TOPLEFT", 0, yOffset)

            -- Create player name text (left-aligned)
            local playerDataText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            playerDataText:SetPoint("LEFT", 10, 0)
            playerDataText:SetFont("Fonts\\FRIZQT__.TTF", 14) -- Increase font size
            playerDataText:SetWidth(playerNameWidth)  -- Fixed width for name column
            playerDataText:SetJustifyH("LEFT") -- Ensure text is left-aligned

            -- Create DKP text (left-aligned)
            local dkpAmountText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            dkpAmountText:SetPoint("LEFT", playerDataText, "RIGHT", 10, 0)
            dkpAmountText:SetWidth(dkpWidth)  -- Fixed width for DKP column
            dkpAmountText:SetJustifyH("LEFT") -- Ensure text is left-aligned

            -- Create spec icon (ensure it's a valid texture object)
            local specIcon = rowFrame:CreateTexture(nil, "OVERLAY")
            specIcon:SetSize(25, 25)
            specIcon:SetPoint("LEFT", dkpAmountText, "RIGHT", 10, 0)
            specIcon:SetWidth(iconWidth)  -- Fixed width for icon column

            -- Ensure specIcon is a valid texture and set the script only if it's valid
            if specIcon.SetScript then
                specIcon:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    local specName = ""
                    if playerData then
                        local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(class)
                        if playerData.MSChange == -1 then
                            specName = specs[playerData.currentSpecIndex].name
                        else
                            specName = specs[playerData.MSChange].name
                        end
                    end
                    GameTooltip:SetText(specName or "Unknown Spec", 1, 1, 1)
                    GameTooltip:Show()
                end)

                specIcon:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                end)
            end

            if playerData then
                -- Player exists in PLAYERS_ROOSTER: Print their info
                playerDataText:SetText(string.format("%s%s|r", GetClassColor(class), name))
                dkpAmountText:SetText(string.format("DKP: %d", playerData.dkpAmount or 0))

                -- Get the spec icon
                local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(class)
                local icon = ""
                if playerData.MSChange == -1 then
                    icon = specs[playerData.currentSpecIndex].icon
                else
                    icon = specs[playerData.MSChange].icon
                end
                specIcon:SetTexture(icon)

            else
                -- Player is not in PLAYERS_ROOSTER: Add their name in class color and show DKP if available
                local DKP = DKP_CORE.FindPlayerOtherPlayerDKP(name)
                playerDataText:SetText(string.format("%s%s|r", GetClassColor(class), name))
                dkpAmountText:SetText(string.format("[DKP: %d]", DKP or 0))
                
                -- Add spec icon (question mark for unknown)
                specIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end

            -- Adjust yOffset for the next row
            yOffset = yOffset - (ROW_HEIGHT + PADDING)
        end
    end

    -- Adjust the scroll child's height to fit the content
    local contentHeight = math.abs(yOffset) + PADDING
    scrollChild:SetHeight(contentHeight)
end




function ROOSTER_UI.UpdateFrame()
    if RoosterFrame:IsShown() then
        local checkShowGuild = _G["chkShowGuildRooster"]
        local checkShowRaid = _G["chkShowRaidRooster"]
        if checkShowGuild:GetChecked() then
		    PopulateRoosterScrollFrame()
		end
	    if checkShowRaid:GetChecked() then
		    PopulateWitchRaid()
		end
	end
end

