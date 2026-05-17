class_name PowerHistory
extends RefCounted

const DEFAULT_WINDOW: int = 10

var _window: int
var _samples: Array[int] = []


func _init(window: int = DEFAULT_WINDOW) -> void:
	_window = window


func snapshot(value: int) -> void:
	_samples.append(value)
	while _samples.size() > _window:
		_samples.pop_front()


func is_empty() -> bool:
	return _samples.is_empty()


func size() -> int:
	return _samples.size()


func average() -> float:
	if _samples.is_empty():
		return 0.0
	var sum: int = 0
	for v: int in _samples:
		sum += v
	return float(sum) / float(_samples.size())
