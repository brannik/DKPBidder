REGEX = {}

REGEX.strings = {
	dkpWhisperRegex = "You have (%d+) DKP",
	spendRegex = "Spends (%d+)", -- fix
	noteDkpRegex = "N%a*:%s*(%d+)",
	noteMainRegex = "^[%w]+$",
	rwBidStartRegex = "Bidding for (.+) started.",
	rwBidCancellRegex = "(.+) has been cancelled.",
	reBidWonRegex = "^(%S+) won (.-) with (%d+) DKP%.?",
	rwRollStartRegex = "roll%s*(.+)",
	rwRollCancelRegex = "",
	rwRollWonRegex = "",
	placeBidRegex = "^(%d+)$",
	rollRegex = "^(%S+) rolls (%d+) %((%d+)%-(%d+)%)$"
}