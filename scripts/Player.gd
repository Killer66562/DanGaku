extends "res://scripts/Character.gd"


signal use_skill

var _health: int
var _skill_count_remain: int = 10
var _skill_active: bool = false
var _skill_lasting_sec: float = 3.5

export (PackedScene) var PlayerBullet


func _ready():
	bullet_cooldown = 0.1
	pass # Replace with function body.
	
	
func _shoot_bullet():
	var velocity = Vector2(0, -1).normalized()
	var bullet = PlayerBullet.instance()
	bullet.position = position
	bullet.velocity = velocity
	bullet.speed = bullet_speed
	get_tree().root.add_child(bullet)

func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if Input.is_action_pressed("use_skill"):
		if _skill_count_remain > 0 and not _skill_active:
			emit_signal("use_skill")
			
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("shoot") and bullet_timer_timeout:
		bullet_timer_timeout = false
		$BulletTimer.start(bullet_cooldown)
		_shoot_bullet()


func _on_Player_use_skill():
	skill_active = true
	$SkillTimer.start(_skill_lasting_sec)
	bullet_speed = 1200


func _on_SkillArea_area_entered(area):
	if skill_active:
		if area.is_in_group("enemy"):
			area.queue_free()
		if area.is_in_group("healing"):
			_health += 1


func _on_SkillTimer_timeout():
	skill_active = false
	bullet_speed = 800


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("enemy"):
		_health -= 1
		if _health <= 0:
			emit_signal("die")
