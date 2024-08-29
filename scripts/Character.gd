extends Node2D


signal die

export var speed = 400
export var skill_active = false

var screen_size;
var bullet_speed = 1000

export var bullet_cooldown: float
var bullet_timer_timeout = true


func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "default"


func _on_BulletTimer_timeout():
	bullet_timer_timeout = true


func _on_Character_die():
	queue_free()
