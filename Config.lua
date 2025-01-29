local eventFrame = CreateFrame("Frame")

local function InitUI()
    SaveButton = _G["btnSaveConfig"]
    WipeConfigButton = _G["btnWipeConfig"]
    WipeItemsButton = _G["btnWipeItems"]

    PNoteCheck = _G["chkPublicNote"] --
    ONoteCheck = _G["chkOfficerNote"] --
    ONoteVisCheck = _G["chkOfficerNoteVisible"] --
    DKPFrameEnCheck = _G["chkDKPFrameEnable"] --
    DKPFrameSmallCheck = _G["chkDKPFrameSmall"] --
    CustomChatEnableCheck = _G["chkCustomChatEnable"] --
    ShowDKPInChat = _G["chkShowDkpInChat"] --
    ShowGSInChat = _G["chkShowGSInChat"] --
    ShowMSInChat = _G["chkShowMSInChat"] --


    WipeConfigButton:SetScript("OnClick",function()
	    DKP_Config = {}
        ReloadUI()
	end)

    ONoteCheck:SetScript("OnClick", function() 
	    PNoteCheck:SetChecked(false)
        DKP_CORE.config.dkpStorage = "Officer Note"
        ONoteVisCheck:Enable()
	end)
    PNoteCheck:SetScript("OnClick", function() 
	    ONoteCheck:SetChecked(false)
        DKP_CORE.config.dkpStorage = "Public Note"
        ONoteVisCheck:Disable()
	end)
    ONoteVisCheck:SetScript("OnClick", function() 
        DKP_CORE.config.officerNoteVisible = ONoteVisCheck:GetChecked() == 1
	end)
    DKPFrameEnCheck:SetScript("OnClick", function() 
        DKP_CORE.config.showDkpFrame = DKPFrameEnCheck:GetChecked() == 1
        if DKPFrameEnCheck:GetChecked() then
		    DKPFrameSmallCheck:Enable()
		else
            DKPFrameSmallCheck:Disable()
		end
	end)
    DKPFrameSmallCheck:SetScript("OnClick", function() 
        DKP_CORE.config.smallDkpFrame = DKPFrameSmallCheck:GetChecked() == 1
	end)
    CustomChatEnableCheck:SetScript("OnClick", function() 
        DKP_CORE.config.useCustomChat = CustomChatEnableCheck:GetChecked() == 1
        if CustomChatEnableCheck:GetChecked() then
		    ShowDKPInChat:Enable()
            ShowGSInChat:Enable()
            ShowMSInChat:Enable()
		else
		    ShowDKPInChat:Disable()
            ShowGSInChat:Disable()
            ShowMSInChat:Disable()
		end
	end)
    ShowDKPInChat:SetScript("OnClick", function() 
        DKP_CORE.config.showDkpInRaidChat = ShowDKPInChat:GetChecked() == 1
	end)
    ShowGSInChat:SetScript("OnClick", function() 
        DKP_CORE.config.showGSInRaidChat = ShowGSInChat:GetChecked() == 1
	end)
    ShowMSInChat:SetScript("OnClick", function() 
        DKP_CORE.config.showMSInRaidChat = ShowMSInChat:GetChecked() == 1
	end)

    SaveButton:SetScript("OnClick", function() 
        DKP_CORE.SaveConfig()
        ReloadUI()
	end)
    DKP_CORE.GetGuildName()
    DKP_CORE.LoadConfig()

    if DKP_CORE.config then
	    if DKP_CORE.config.dkpStorage == "Officer Note" then
		    PNoteCheck:SetChecked(false)
            ONoteCheck:SetChecked(true)
            if DKP_CORE.config.officerNoteVisible then
			    ONoteVisCheck:SetChecked(true)
			else
                ONoteVisCheck:SetChecked(false)
            end
            ONoteVisCheck:Enable()
        elseif DKP_CORE.config.dkpStorage == "Public Note" then
		    PNoteCheck:SetChecked(true)
            ONoteCheck:SetChecked(false)
            ONoteVisCheck:Disable()
		end
        DKPFrameEnCheck:SetChecked(DKP_CORE.config.showDkpFrame)
        if DKPFrameEnCheck:GetChecked() then
		    DKPFrameSmallCheck:Enable()
		else
            DKPFrameSmallCheck:Disable()
		end
        DKPFrameSmallCheck:SetChecked(DKP_CORE.config.smallDkpFrame)
        CustomChatEnableCheck:SetChecked(DKP_CORE.config.useCustomChat)
        if CustomChatEnableCheck:GetChecked() then
		    ShowDKPInChat:Enable()
            ShowGSInChat:Enable()
            ShowMSInChat:Enable()
		else
		    ShowDKPInChat:Disable()
            ShowGSInChat:Disable()
            ShowMSInChat:Disable()
		end
        ShowDKPInChat:SetChecked(DKP_CORE.config.showDkpInRaidChat)
        ShowGSInChat:SetChecked(DKP_CORE.config.showGSInRaidChat)
        ShowMSInChat:SetChecked(DKP_CORE.config.showMSInRaidChat)
	end

end





local function OnFrameShown()
    InitUI()
end

-- Access the frame defined in XML using _G["Config"]
local ConfigFrame = _G["DKPConfig"]
if ConfigFrame then
    -- Set the OnShow event handler for when the frame is shown
    ConfigFrame:SetScript("OnShow", OnFrameShown)
else
    print("Error: Config frame not found.")
end

-- Register the ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")

-- Set the event script for handling addon load events
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "DKPBidder" then
        if ConfigFrame then
            ConfigFrame:Hide() -- Hide the frame initially
        end
    end
end)
