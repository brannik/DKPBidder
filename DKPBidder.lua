DKPBidder = LibStub("AceAddon-3.0"):NewAddon("DKPBidder", "AceConsole-3.0", "AceEvent-3.0" );

function DKPBidder:OnInitialize()
		-- Called when the addon is loaded

		-- Print a message to the chat frame
		self:Print("OnInitialize Event Fired: Hello")
end

function DKPBidder:OnEnable()
		-- Called when the addon is enabled
		EVENTS.RegisterGlobalEvents()
		DKP_CORE.GetGuildName()
		DKP_CORE.GatherDKP(false)
end

function DKPBidder:OnDisable()
		-- Called when the addon is disabled
end
