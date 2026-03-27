class_name CompanyLevel

var level: int
var minrep: int
var duration: Vector2
var rep_mod: float
var rew_mod: float

func _init(l, m, d, rp, rw):
	level = l
	minrep = m
	duration = d
	rep_mod = rp
	rew_mod = rw
