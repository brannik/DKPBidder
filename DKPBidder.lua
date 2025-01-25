DKPBidder = LibStub("AceAddon-3.0"):NewAddon("DKPBidder", "AceConsole-3.0", "AceEvent-3.0" );

function DKPBidder:OnInitialize()
		-- Called when the addon is loaded
	--DKP_CORE.LoadConfig()
end

function DKPBidder:OnEnable()
	-- Called when the addon is enabled
	
	
	EVENTS.RegisterGlobalEvents()
	DKP_CORE.GetGuildName()
	DKP_CORE.LoadConfig()	
	DKP_CORE.GatherDKP(false)
	DKP_CORE.UpdateLocalPlayerInfo()
	ADDON_COMUNICATION.SendMyData()
	ADDON_COMUNICATION.RequestOtherData()

	if DKP_CORE.config and DKP_CORE.config.useCustomChat == true then
		CUSTOM_CHAT.CreateCustomRaidTab()
		CUSTOM_CHAT.registerFilters()
	end
end

function DKPBidder:OnDisable()
		-- Called when the addon is disabled
end
