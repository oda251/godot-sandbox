class_name NonPlayerObject
extends Area2D

signal player_damaged(amount: int)

enum Kind { ENEMY, POWERUP_ADD, POWERUP_MUL }

const FALL_SPEED: float = 110.0
const OFFSCREEN_Y: float = 720.0
const COLOR_ENEMY: Color = Color(0.85, 0.25, 0.3)
const COLOR_ADD: Color = Color(0.2, 0.55, 0.85)
const COLOR_MUL: Color = Color(0.9, 0.6, 0.2)

@export var label: Kind = Kind.ENEMY
@export var value: int = 1

@onready var rect: ColorRect = $Rect
@onready var text_label: Label = $TextLabel


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_refresh_visual()


func _process(delta: float) -> void:
	position.y += FALL_SPEED * delta
	if position.y > OFFSCREEN_Y:
		on_exit_bottom()
		queue_free()


func contact_with_player(player: Player) -> void:
	match label:
		Kind.ENEMY:
			player.take_damage(value)
		Kind.POWERUP_ADD:
			player.power += value
		Kind.POWERUP_MUL:
			player.power *= value
	queue_free()


func on_exit_bottom() -> void:
	match label:
		Kind.ENEMY:
			player_damaged.emit(value)
		Kind.POWERUP_ADD, Kind.POWERUP_MUL:
			pass


func hit_by_bullet(damage: int) -> void:
	match label:
		Kind.ENEMY:
			value -= damage
			if value <= 0:
				queue_free()
			else:
				_refresh_visual()
		Kind.POWERUP_ADD, Kind.POWERUP_MUL:
			value += 1
			_refresh_visual()


func _refresh_visual() -> void:
	match label:
		Kind.ENEMY:
			rect.color = COLOR_ENEMY
			text_label.text = "E:%d" % value
		Kind.POWERUP_ADD:
			rect.color = COLOR_ADD
			text_label.text = "%+d" % value
		Kind.POWERUP_MUL:
			rect.color = COLOR_MUL
			text_label.text = "x%d" % value


func _on_area_entered(area: Area2D) -> void:
	var player: Player = area as Player
	if player != null:
		contact_with_player(player)
