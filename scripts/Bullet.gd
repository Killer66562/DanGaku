extends Node2D


export var velocity: Vector2
export var speed: float
export var clear_y: float
var bigger_than: bool


func _ready():
	pass
	
	
func _shoot_bullet():
	pass


func _process(delta):
	position += velocity * speed * delta


func _on_DisappearTimer_timeout():
	queue_free()
