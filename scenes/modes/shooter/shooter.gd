extends Node2D

const NON_PLAYER_SCENE: PackedScene = preload("res://scenes/modes/shooter/non_player.tscn")
const SCREEN_WIDTH: float = 1152.0
const SPAWN_MARGIN: float = 60.0

const SPAWN_WEIGHT_ENEMY: int = 70
const SPAWN_WEIGHT_ADD: int = 15
const ADD_VALUE_MIN: int = -5
const ADD_VALUE_MAX: int = 5
const MUL_VALUE_MIN: int = -2
const MUL_VALUE_MAX: int = 3

const ENEMY_RATIO_MIN: float = 0.5
const ENEMY_RATIO_MAX: float = 2.0
const POWER_SAMPLE_WINDOW: int = 10

var _is_game_over: bool = false
var _power_samples: Array[int] = []

@onready var player: Player = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var sample_timer: Timer = $SampleTimer
@onready var hud_power: Label = $HUD/PowerLabel
@onready var game_over_panel: Control = $HUD/GameOverPanel
@onready var final_label: Label = $HUD/GameOverPanel/Center/VBox/FinalScore
@onready var pause_panel: Control = $HUD/PausePanel


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	sample_timer.timeout.connect(_on_sample_timer_timeout)
	game_over_panel.visible = false
	pause_panel.visible = false
	_power_samples.append(player.power)


func _process(_delta: float) -> void:
	if _is_game_over or get_tree().paused:
		return
	hud_power.text = "POWER: %d" % player.power
	if player.power <= 0:
		_game_over()


func _unhandled_input(event: InputEvent) -> void:
	if _is_game_over:
		return
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
		get_viewport().set_input_as_handled()


func _toggle_pause() -> void:
	var should_pause: bool = not get_tree().paused
	get_tree().paused = should_pause
	pause_panel.visible = should_pause


func _on_sample_timer_timeout() -> void:
	_power_samples.append(player.power)
	while _power_samples.size() > POWER_SAMPLE_WINDOW:
		_power_samples.pop_front()


func _avg_power() -> float:
	if _power_samples.is_empty():
		return float(player.power)
	var sum: int = 0
	for v: int in _power_samples:
		sum += v
	return float(sum) / float(_power_samples.size())


func _on_spawn_timer_timeout() -> void:
	var spawned: NonPlayerObject = NON_PLAYER_SCENE.instantiate() as NonPlayerObject
	if spawned == null:
		return
	spawned.position = Vector2(randf_range(SPAWN_MARGIN, SCREEN_WIDTH - SPAWN_MARGIN), -40.0)
	var roll: int = randi_range(0, 99)
	if roll < SPAWN_WEIGHT_ENEMY:
		spawned.label = NonPlayerObject.Kind.ENEMY
		spawned.value = _roll_enemy_value()
	elif roll < SPAWN_WEIGHT_ENEMY + SPAWN_WEIGHT_ADD:
		spawned.label = NonPlayerObject.Kind.POWERUP_ADD
		spawned.value = randi_range(ADD_VALUE_MIN, ADD_VALUE_MAX)
	else:
		spawned.label = NonPlayerObject.Kind.POWERUP_MUL
		spawned.value = randi_range(MUL_VALUE_MIN, MUL_VALUE_MAX)
	spawned.player_damaged.connect(player.take_damage)
	add_child(spawned)


func _roll_enemy_value() -> int:
	var base: float = maxf(1.0, absf(_avg_power()))
	var low: int = maxi(1, roundi(base * ENEMY_RATIO_MIN))
	var high: int = maxi(low, roundi(base * ENEMY_RATIO_MAX))
	return randi_range(low, high)


func _game_over() -> void:
	_is_game_over = true
	spawn_timer.stop()
	sample_timer.stop()
	final_label.text = "Final Power: %d" % player.power
	game_over_panel.visible = true


func _on_restart_pressed() -> void:
	var err: Error = get_tree().reload_current_scene()
	if err != OK:
		push_error("Reload failed: %d" % err)


func _on_back_pressed() -> void:
	var err: Error = get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	if err != OK:
		push_error("Back failed: %d" % err)


func _on_pause_resume_pressed() -> void:
	_toggle_pause()


func _on_pause_quit_pressed() -> void:
	get_tree().paused = false
	var err: Error = get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	if err != OK:
		push_error("Quit to menu failed: %d" % err)
