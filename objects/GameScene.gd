extends Node2D


export (PackedScene) var Player
export (PackedScene) var Mob


func _ready():
	$Player.position = Vector2(400, 400)
	$MobTimer.start()


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	mob.player_position = $Player.position
	add_child(mob)
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.


func _on_Player_die():
	for n in get_children():
		remove_child(n)
		n.queue_free()
