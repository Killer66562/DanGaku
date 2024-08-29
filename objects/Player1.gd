extends "res://scripts/Player.gd"


func _ready():
	_strength = 0
	bullet_speed = 800
	speed = 400


func _shoot_bullet():
	for s in range(-_strength, _strength + 1):
		print(s)
		var bullet = PlayerBullet.instance()
		var velocity = Vector2(sin(s * -(PI / 6)), -cos(s * (PI / 6))).normalized()
		bullet.velocity = velocity
		bullet.speed = bullet_speed
		bullet.position = position
		get_tree().root.add_child(bullet)
		
