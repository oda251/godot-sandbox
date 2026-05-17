class_name Bullet
extends Area2D

const SPEED: float = 520.0
const OFFSCREEN_Y: float = -40.0

var damage: int = 0


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.y < OFFSCREEN_Y:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	var target: NonPlayerObject = area as NonPlayerObject
	if target == null:
		return
	target.hit_by_bullet(damage)
	queue_free()
