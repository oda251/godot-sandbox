class_name SpawnLanes
extends RefCounted

var _xs: Array[float] = []


func _init(center_x: float, span: float, lane_count: int) -> void:
	if lane_count <= 0 or span <= 0.0:
		return
	var slot: float = span / float(lane_count)
	var start: float = center_x - span * 0.5
	for i: int in range(lane_count):
		_xs.append(start + slot * (float(i) + 0.5))


func count() -> int:
	return _xs.size()


func x_at(index: int) -> float:
	return _xs[index]


func random_x() -> float:
	if _xs.is_empty():
		return 0.0
	return _xs[randi() % _xs.size()]
