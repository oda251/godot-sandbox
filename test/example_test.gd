extends GdUnitTestSuite


func test_string_equality() -> void:
	assert_str("Hello, Godot!").is_equal("Hello, Godot!")


func test_arithmetic() -> void:
	assert_int(2 + 3).is_equal(5)
