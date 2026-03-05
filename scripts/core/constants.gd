extends Node

#const DEBUGFLAG = false
const DEBUGFLAG = true

#region Start
const START_MONEY = 500
const START_REPUTATION = 0
const START_TIER  = 0
#endregion

#region Contract
const MIN_DURATION = 5
const MAX_DURATION = 20
const REPUTATION_MODIFYER = 0.05
const REWARD_MODIFYER = 10
#endregion

#region Vehicle
const VEHICLE_COST = 10000
#endregion

#region Helpers
static func format_duration(seconds: float) -> String:
	var s := int(ceil(seconds))
	if s < 60:
		return "%ds" % s

	var m := s / 60
	if m < 60:
		return "%dm" % m

	var h := m / 60
	var rem_m := m % 60
	if rem_m == 0:
		return "%dh" % h
	return "%dh%dm" % [h, rem_m]
#endregion
