extends Node2D


var velocity: Vector2
var speed: int


func _ready():
	pass
	
	
func _process(delta):
	position += velocity * speed * delta
