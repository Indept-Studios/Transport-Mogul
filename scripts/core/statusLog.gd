extends Node

signal changed

@export var max_entries: int = 200

var _next_id: int = 1
var entries: Array[Dictionary] = []

func add(msg: String, kind: String = "info") -> int:
	var e := {
		"id": _next_id,
		"t": int(Time.get_unix_time_from_system()),
		"msg": msg,
		"kind": kind,
	}
	_next_id += 1
	entries.append(e)
	if entries.size() > max_entries:
		entries.pop_front()

	emit_signal("changed")
	return int(e["id"])

func remove(id: int) -> void:
	for i in range(entries.size()):
		if int(entries[i].get("id", -1)) == id:
			entries.remove_at(i)
			emit_signal("changed")
			return

func clear() -> void:
	entries.clear()
	emit_signal("changed")

func get_latest(n: int) -> Array[Dictionary]:
	var count: Variant = min(n, entries.size())
	if count <= 0:
		return []
	return entries.slice(entries.size() - count, entries.size())
