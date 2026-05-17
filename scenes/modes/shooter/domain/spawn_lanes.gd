class_name SpawnLanes
extends RefCounted

var _xs: Array[float] = []


func _init(screen_width: float, lane_count: int) -> void:
	if lane_count <= 0:
		return
	var slot_width: float = screen_width / float(lane_count)
	for i: int in range(lane_count):
		_xs.append(slot_width * (float(i) + 0.5))


func count() -> int:
	return _xs.size()


func x_at(index: int) -> float:
	return _xs[index]


func random_x() -> float:
	if _xs.is_empty():
		return 0.0
	return _xs[randi() % _xs.size()]
