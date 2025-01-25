REGEX = {}

REGEX.strings = {
	dkpWhisperRegex = "You have (%d+) DKP",
	spendRegex = "Spends (%d+)", -- fix
	noteDkpRegex = "N%a*:%s*(%d+)",
	noteMainRegex = "^[%w]+$",
	rwBidStartRegex = "Rolling for (.+) started.",
	rwBidCancellRegex = "(.+) has been cancelled.",
	reBidWonRegex = "^(%S+) won (.-) with (%d+) DKP%.?",
	rwRollStartRegex = "",
	rwRollCancelRegex = "",
	rwRollWonRegex = "",
	placeBidRegex = "^(%d+)$"
}