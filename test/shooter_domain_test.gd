extends GdUnitTestSuite


func test_power_history_starts_empty() -> void:
	var h: PowerHistory = PowerHistory.new()
	assert_bool(h.is_empty()).is_true()
	assert_int(h.size()).is_equal(0)
	assert_float(h.average()).is_equal_approx(0.0, 0.001)


func test_power_history_single_sample() -> void:
	var h: PowerHistory = PowerHistory.new()
	h.snapshot(10)
	assert_int(h.size()).is_equal(1)
	assert_float(h.average()).is_equal_approx(10.0, 0.001)


func test_power_history_average_of_multiple() -> void:
	var h: PowerHistory = PowerHistory.new(5)
	h.snapshot(10)
	h.snapshot(20)
	h.snapshot(30)
	assert_float(h.average()).is_equal_approx(20.0, 0.001)


func test_power_history_drops_oldest_beyond_window() -> void:
	var h: PowerHistory = PowerHistory.new(3)
	for i: int in range(5):
		h.snapshot(i + 1)
	assert_int(h.size()).is_equal(3)
	assert_float(h.average()).is_equal_approx(4.0, 0.001)


func test_enemy_spawn_policy_empty_history_uses_floor() -> void:
	var h: PowerHistory = PowerHistory.new()
	var r: Vector2i = EnemySpawnPolicy.value_range(h)
	# base = 1.0, low = 1 (max(1, 2)), high = 10
	assert_int(r.x).is_equal(2)
	assert_int(r.y).is_equal(10)


func test_enemy_spawn_policy_positive_average() -> void:
	var h: PowerHistory = PowerHistory.new()
	h.snapshot(10)
	var r: Vector2i = EnemySpawnPolicy.value_range(h)
	# base = 10, low = 15, high = 100
	assert_int(r.x).is_equal(15)
	assert_int(r.y).is_equal(100)


func test_enemy_spawn_policy_negative_average_uses_abs() -> void:
	var h: PowerHistory = PowerHistory.new()
	h.snapshot(-10)
	var r: Vector2i = EnemySpawnPolicy.value_range(h)
	assert_int(r.x).is_equal(15)
	assert_int(r.y).is_equal(100)


func test_enemy_spawn_policy_roll_stays_in_range() -> void:
	var h: PowerHistory = PowerHistory.new()
	h.snapshot(10)
	var r: Vector2i = EnemySpawnPolicy.value_range(h)
	for _i: int in range(200):
		var v: int = EnemySpawnPolicy.roll_value(h)
		assert_int(v).is_greater_equal(r.x)
		assert_int(v).is_less_equal(r.y)


func test_enemy_spawn_policy_roll_mean_is_low_biased() -> void:
	# Binomial(10, 0.2) → mean = 2 → normalized t = 0.2
	# Expected roll mean ≈ low + 0.2 * (high - low) = 15 + 17 = 32
	# Allow generous tolerance for sampling variance.
	var h: PowerHistory = PowerHistory.new()
	h.snapshot(10)
	var samples: int = 500
	var total: int = 0
	for _i: int in range(samples):
		total += EnemySpawnPolicy.roll_value(h)
	var mean: float = float(total) / float(samples)
	assert_float(mean).is_between(24.0, 40.0)


func test_spawn_lanes_three_clustered_at_center() -> void:
	var lanes: SpawnLanes = SpawnLanes.new(576.0, 384.0, 3)
	assert_int(lanes.count()).is_equal(3)
	assert_float(lanes.x_at(0)).is_equal_approx(448.0, 0.001)
	assert_float(lanes.x_at(1)).is_equal_approx(576.0, 0.001)
	assert_float(lanes.x_at(2)).is_equal_approx(704.0, 0.001)


func test_spawn_lanes_full_width_three_lanes() -> void:
	var lanes: SpawnLanes = SpawnLanes.new(576.0, 1152.0, 3)
	assert_float(lanes.x_at(0)).is_equal_approx(192.0, 0.001)
	assert_float(lanes.x_at(1)).is_equal_approx(576.0, 0.001)
	assert_float(lanes.x_at(2)).is_equal_approx(960.0, 0.001)


func test_spawn_lanes_single_lane_is_at_center() -> void:
	var lanes: SpawnLanes = SpawnLanes.new(500.0, 200.0, 1)
	assert_int(lanes.count()).is_equal(1)
	assert_float(lanes.x_at(0)).is_equal_approx(500.0, 0.001)


func test_spawn_lanes_zero_count_is_empty() -> void:
	var lanes: SpawnLanes = SpawnLanes.new(500.0, 200.0, 0)
	assert_int(lanes.count()).is_equal(0)


func test_spawn_lanes_zero_span_is_empty() -> void:
	var lanes: SpawnLanes = SpawnLanes.new(500.0, 0.0, 3)
	assert_int(lanes.count()).is_equal(0)
