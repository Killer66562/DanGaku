extends Node2D


var goal setget set_goal, get_goal


func set_goal(node: Node2D):
	goal = node
	
	
func get_goal():
	return goal
	
func _ready():
	pass
