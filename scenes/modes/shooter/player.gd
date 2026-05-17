class_name Player
extends Area2D

const SPEED: float = 350.0
const BULLET_COOLDOWN: float = 0.18
const MIN_X: float = 24.0
const MAX_X: float = 1128.0
const BULLET_SCENE: PackedScene = preload("res://scenes/modes/shooter/bullet.tscn")

@export var power: int = 10

var _shoot_cooldown: float = 0.0

@onready var text_label: Label = $TextLabel
@onready var rect: ColorRect = $Rect


func _process(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	position.x += direction * SPEED * delta
	position.x = clampf(position.x, MIN_X, MAX_X)

	_shoot_cooldown -= delta
	if Input.is_action_pressed("shoot") and _shoot_cooldown <= 0.0:
		_shoot()
		_shoot_cooldown = BULLET_COOLDOWN

	text_label.text = "P:%d" % power
	rect.color = Color(0.3, 0.85, 0.4) if power > 0 else Color(0.5, 0.5, 0.5)


func take_damage(amount: int) -> void:
	power -= amount


func _shoot() -> void:
	var bullet: Bullet = BULLET_SCENE.instantiate() as Bullet
	if bullet == null:
		return
	bullet.position = position + Vector2(0.0, -28.0)
	bullet.damage = power
	get_parent().add_child(bullet)
