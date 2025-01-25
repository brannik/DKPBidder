
ADDON_COMUNICATION = {}
PLAYERS_ROOSTER = {}

local CommunicationFrame = CreateFrame("Frame")
local prefix = "DKP_PLAYER_DATA" -- Your addon message prefix
local requestPrefix = "GET_PLAYER_DATA"
 -- call the function manualy
-- Serialize the table into a string for transmission
local function ValidateMyData(data)
    if not data.playerName or data.playerName == "" then
        error("playerName is missing or empty")
    end
    if type(data.dkpAmount) ~= "number" then
        error("dkpAmount must be a number")
    end
    if type(data.currentSpecIndex) ~= "number" then
        error("currentSpecIndex must be a number")
    end
    if type(data.MSChange) ~= "number" then
        error("MSChange must be a number")
    end
end

local function SerializeMyData(data)
    ValidateMyData(data) -- Ensure data is valid before serialization
    return string.format("%s;%d;%d;%d",
        data.playerName,
        data.dkpAmount,
        data.currentSpecIndex,
        data.MSChange
    )
end

-- Deserialize the string back into a table (optional, for receiving)
local function DeserializeMyData(message)
    local playerName, dkpAmount, currentSpecIndex, MSChange = strsplit(";", message)
    return {
        playerName = playerName,
        dkpAmount = tonumber(dkpAmount),
        currentSpecIndex = tonumber(currentSpecIndex),
        MSChange = tonumber(MSChange)
    }
end

-- Handle addon messages and events
local function AddonMessage(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        -- Extract arguments from the event
        local receivedPrefix, message, channel, sender = ...
        if receivedPrefix == prefix then
            -- Deserialize the message
            local receivedData = DeserializeMyData(message)
            if receivedData then
                -- Store or update the player's data in PLAYERS_ROOSTER
                PLAYERS_ROOSTER[receivedData.playerName] = {
                    dkpAmount = receivedData.dkpAmount,
                    currentSpecIndex = receivedData.currentSpecIndex,
                    MSChange = receivedData.MSChange
                }
                -- Confirm the update
                print("Updated player data for: " .. receivedData.playerName)
            end
        elseif receivedPrefix == requestPrefix then
            -- get otherd data
            local playerName = UnitName("player")
            if sender ~= playerName then
			    ADDON_COMUNICATION.SendMyData()
			end
        end
    end
end

function ADDON_COMUNICATION.SendMyData()
    local serializedData = SerializeMyData(DKP_CORE.MyData)

    -- Send the serialized data to the guild channel
    if IsInGuild() then
        SendAddonMessage(prefix, serializedData, "GUILD")
    else
        print("|cffff0000[ERROR] You are not in a guild. Cannot send the message to GUILD.")
    end
end
function ADDON_COMUNICATION.RequestOtherData()

    -- Send the serialized data to the guild channel
    if IsInGuild() then
        SendAddonMessage(requestPrefix, "request", "GUILD")
    else
        print("|cffff0000[ERROR] You are not in a guild. Cannot send the message to GUILD.")
    end
end

-- Register events
CommunicationFrame:RegisterEvent("ADDON_LOADED")
CommunicationFrame:RegisterEvent("CHAT_MSG_ADDON")
CommunicationFrame:SetScript("OnEvent", AddonMessage)
