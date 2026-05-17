class_name EnemySpawnPolicy
extends RefCounted

const RATIO_MIN: float = 1.5
const RATIO_MAX: float = 10.0
const FLOOR: float = 1.0

const BERNOULLI_TRIALS: int = 10
const BERNOULLI_P: float = 0.2


static func value_range(history: PowerHistory) -> Vector2i:
	var base: float = maxf(FLOOR, absf(history.average()))
	var low: int = maxi(1, roundi(base * RATIO_MIN))
	var high: int = maxi(low, roundi(base * RATIO_MAX))
	return Vector2i(low, high)


static func roll_value(history: PowerHistory) -> int:
	var r: Vector2i = value_range(history)
	var t: float = _bernoulli_unit()
	var v: int = roundi(float(r.x) + (float(r.y) - float(r.x)) * t)
	return clampi(v, r.x, r.y)


# Returns a value in [0, 1] drawn from Binomial(n, p) / n.
# Sum of n independent Bernoulli(p) trials, normalized.
static func _bernoulli_unit() -> float:
	var hits: int = 0
	for _i: int in range(BERNOULLI_TRIALS):
		if randf() < BERNOULLI_P:
			hits += 1
	return float(hits) / float(BERNOULLI_TRIALS)
