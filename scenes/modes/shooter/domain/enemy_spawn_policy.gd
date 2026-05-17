class_name EnemySpawnPolicy
extends RefCounted

const RATIO_MIN: float = 0.5
const RATIO_MAX: float = 2.0
const FLOOR: float = 1.0


static func value_range(history: PowerHistory) -> Vector2i:
	var base: float = maxf(FLOOR, absf(history.average()))
	var low: int = maxi(1, roundi(base * RATIO_MIN))
	var high: int = maxi(low, roundi(base * RATIO_MAX))
	return Vector2i(low, high)


static func roll_value(history: PowerHistory) -> int:
	var r: Vector2i = value_range(history)
	return randi_range(r.x, r.y)
