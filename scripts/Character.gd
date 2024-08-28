extends Node2D

export var speed = 400
export (PackedScene) var PlayerBullet

export var health = 10
export var skill_count_remain = 5
export var skill_lasting_time = 5

export var skill_active = false

var screen_size;
var bullet_speed = 1000

export var bullet_cooldown: float
var bullet_timer_timeout = true

signal character_die
signal character_use_skill

func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, screen_size.y / 6 * 5)
	bullet_cooldown = 0.1
	$AnimatedSprite.animation = "default"
	
	
func shoot_bullet():
	bullet_timer_timeout = false
	
	var bullet_l = PlayerBullet.instance()
	var bullet_m = PlayerBullet.instance()
	var bullet_r = PlayerBullet.instance()
	
	var bullet_velocity_l = Vector2(-0.6, -1).normalized()
	var bullet_velocity_m = Vector2(0, -1).normalized()
	var bullet_velocity_r = Vector2(0.6, -1).normalized()
	
	bullet_l.position = position
	bullet_m.position = position
	bullet_r.position = position
	
	bullet_l.velocity = bullet_velocity_l
	bullet_m.velocity = bullet_velocity_m
	bullet_r.velocity = bullet_velocity_r
	
	bullet_l.speed = bullet_speed
	bullet_m.speed = bullet_speed
	bullet_r.speed = bullet_speed
	
	get_tree().root.add_child(bullet_l)
	get_tree().root.add_child(bullet_m)
	get_tree().root.add_child(bullet_r)
	
	$BulletTimer.start(bullet_cooldown)


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
		if skill_count_remain > 0 && !skill_active:
			emit_signal("character_use_skill")
			
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("shoot") && bullet_timer_timeout:
		shoot_bullet()


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("MobBullet"):
		health -= 1
	if health <= 0:
		emit_signal("character_die")


func _on_Character_character_die():
	queue_free()


func _on_Character_character_use_skill():
	skill_count_remain -= 1
	$SkillRemainTimer.start(skill_lasting_time)
	skill_active = true


func _on_SkillRemainTimer_timeout():
	skill_active = false


func _on_SkillArea_area_entered(area):
	if skill_active:
		if area.is_in_group("MobBullet"):
			area.queue_free()


func _on_BulletTimer_timeout():
	bullet_timer_timeout = true
