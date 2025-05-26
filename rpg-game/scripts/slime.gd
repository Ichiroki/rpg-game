extends CharacterBody2D

var speed = 20
var direction = Vector2.ZERO

#	Player Variable
var player_chase = false
var player = null
var player_inattack_zone = false

#	Health Variable
var health = 30

#	Speed Variable
var chase_speed = 40
var random_timer = 0.0
var change_dir_interval = 2.0

#	Damage Variable
@export var damage = 10

#	Other Variable
var is_dead = false
var can_take_damage = true
@onready var hitsound = $slime_hitbox/hitbox_sound

var knockback_vector: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
const knockback_duration := 0.0001
const knockback_force := 200

func _ready():
	randomize()
	random_timer = change_dir_interval

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if knockback_timer > 0:
		var collision = move_and_collide(knockback_vector * delta)
		if collision:
			knockback_vector = Vector2.ZERO
			knockback_timer = 0
		else :
			knockback_timer -= delta
		velocity = knockback_vector
		knockback_timer -= delta
	else:
		if player_chase and player != null:
			direction = player.global_position - global_position
			position += direction.normalized() * speed * delta
			play_animation_by_direction(direction)
		else:
			random_timer -= delta
			if random_timer <= 0:
				change_direction()
				random_timer = change_dir_interval
			
			velocity = direction.normalized() * speed
			if direction == Vector2.ZERO:
				walking_direction("none")
			else: 
				play_animation_by_direction(direction)
	move_and_slide()

func play_animation_by_direction(_dir):
	if abs(_dir.x) > abs(_dir.y) :
		if _dir.x > 0:
			walking_direction("right")
		else:
			walking_direction("left")
	else:
		if _dir.y > 0:
			walking_direction("down")
		else:
			walking_direction("up")

func walking_direction(dir):
	if dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_walk")
	elif dir == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_walk")
	elif dir == "up":
		$AnimatedSprite2D.play("back_walk")
	elif dir == "down":
		$AnimatedSprite2D.play("front_walk")
	elif dir == "none":
		$AnimatedSprite2D.play("front_idle")

func change_direction():
	var dirs = [
		Vector2(1, 0), Vector2(-1, 0),
		Vector2(0, 1), Vector2(0, -1),
		Vector2(1, 1).normalized(), Vector2(-1, 1).normalized(),
		Vector2(1, -1).normalized(), Vector2(-1, -1).normalized()
	]
	direction = dirs[randi() % dirs.size()]

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
		direction = Vector2.ZERO

#	Enemy & Categorize Func
func enemy():
	pass
	
func plant():
	pass

func apply_damage(amount: int):
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true :
			health -= amount
			
			if player != null:
				var push_dir = (global_position - player.global_position).normalized()
				knockback_vector = push_dir * knockback_force
				knockback_timer = knockback_duration
				
			play_slash_sound()
			print(health)
			$take_damage_timer.start()
			can_take_damage = false
			
			if health <= 0 and not is_dead:
				is_dead = true
				$AnimatedSprite2D.play("dead")
				$slime_hitbox/dead_delay.start()
				
func play_slash_sound():
	if hitsound.playing:
		hitsound.stop()
	hitsound.play()

func _on_slime_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true
		apply_damage(player.damage)

func _on_slime_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		
func _on_take_damage_timer_timeout() -> void:
	can_take_damage = true

func _on_hitbox_delay_timeout() -> void:
	hitsound.stop()

func _on_dead_delay_timeout() -> void:
	self.queue_free()
