extends "res://scripts/Character.gd"


export (PackedScene) var PlayerBullet
export (PackedScene) var MobBullet
export (PackedScene) var Item


var _move_to: Vector2
var player_position: Vector2
var item_drop_chance: float = 0.99


func _shoot_bullet():
	var velocity = (player_position - position).normalized()
	var bullet = MobBullet.instance()
	bullet.position = position
	bullet.velocity = velocity
	bullet.speed = bullet_speed
	get_tree().root.add_child(bullet)
	
	
func _drop_item():
	if randf() < item_drop_chance:
		var velocity = Vector2(0, 1).normalized()
		var item = Item.instance()
		item.position = position
		item.velocity = velocity
		item.speed = 200
		get_tree().root.add_child(item)


func _ready():
	bullet_cooldown = 0.1
	bullet_speed = 1200


func _process(delta):
	if bullet_timer_timeout:
		bullet_timer_timeout = false
		$BulletTimer.start(bullet_cooldown)
		_shoot_bullet()
		
	if position != _move_to:
		position += (_move_to - position) * delta
	


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("player"):
		_drop_item()
		queue_free()


func _on_CollisionArea_body_entered(body):
	pass


func _on_MoveTimer_timeout():
	var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	_move_to = position + velocity * speed
