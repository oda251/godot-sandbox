extends Node2D

const NON_PLAYER_SCENE: PackedScene = preload("res://scenes/modes/shooter/non_player.tscn")
const SCREEN_WIDTH: float = 1152.0
const SPAWN_MARGIN: float = 60.0

const SPAWN_WEIGHT_ENEMY: int = 70
const SPAWN_WEIGHT_ADD: int = 15
const ENEMY_VALUE_MIN: int = 1
const ENEMY_VALUE_MAX: int = 15
const ADD_VALUE_MIN: int = -5
const ADD_VALUE_MAX: int = 5
const MUL_VALUE_MIN: int = -2
const MUL_VALUE_MAX: int = 3

var _is_game_over: bool = false

@onready var player: Player = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud_power: Label = $HUD/PowerLabel
@onready var game_over_panel: Control = $HUD/GameOverPanel
@onready var final_label: Label = $HUD/GameOverPanel/Center/VBox/FinalScore


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	game_over_panel.visible = false


func _process(_delta: float) -> void:
	if _is_game_over:
		return
	hud_power.text = "POWER: %d" % player.power
	if player.power <= 0:
		_game_over()


func _on_spawn_timer_timeout() -> void:
	var spawned: NonPlayerObject = NON_PLAYER_SCENE.instantiate() as NonPlayerObject
	if spawned == null:
		return
	spawned.position = Vector2(randf_range(SPAWN_MARGIN, SCREEN_WIDTH - SPAWN_MARGIN), -40.0)
	var roll: int = randi_range(0, 99)
	if roll < SPAWN_WEIGHT_ENEMY:
		spawned.label = NonPlayerObject.Label.ENEMY
		spawned.value = randi_range(ENEMY_VALUE_MIN, ENEMY_VALUE_MAX)
	elif roll < SPAWN_WEIGHT_ENEMY + SPAWN_WEIGHT_ADD:
		spawned.label = NonPlayerObject.Label.POWERUP_ADD
		spawned.value = randi_range(ADD_VALUE_MIN, ADD_VALUE_MAX)
	else:
		spawned.label = NonPlayerObject.Label.POWERUP_MUL
		spawned.value = randi_range(MUL_VALUE_MIN, MUL_VALUE_MAX)
	add_child(spawned)


func _game_over() -> void:
	_is_game_over = true
	spawn_timer.stop()
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
