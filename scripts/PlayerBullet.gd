extends "res://scripts/Bullet.gd"


export var damage: int

func _ready():
	bigger_than = false
	clear_y = 0


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("enemy"):
		area.queue_free()
