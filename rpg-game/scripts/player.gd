extends CharacterBody2D

const speed = 100
var curr_dir = "none"

# Camera Variable
@onready var camera = $Camera2D
var target_offset := Vector2.ZERO
const camera_offset_value = 20
const camera_lerp_speed = 30

# Enemy Variable
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

# Animation Variable
var attack_ip = false

func _physics_process(delta: float) -> void:
	player_movement(delta)
	update_camera(delta)
	attack()
	#enemy_attack()
	
	if health <= 0 :
		player_alive = false
		health = 0
		print("player have been killed")
		self.queue_free()

func player_movement(delta):
	var input_vector = Vector2.ZERO
	var moving = false
	
	if Input.is_action_pressed("walk_right"):
		curr_dir = "right"
		input_vector.x += 1
		target_offset = Vector2(camera_offset_value, 0)
		moving = true
	if Input.is_action_pressed("walk_left"):
		curr_dir = "left"
		input_vector.x -= 1
		target_offset = Vector2(-camera_offset_value, 0)
		moving = true
	if Input.is_action_pressed("walk_up"):
		curr_dir = "up"
		input_vector.y -= 1
		target_offset = Vector2(0, -camera_offset_value)
		moving = true
	if Input.is_action_pressed("walk_down"):
		curr_dir = "down"
		input_vector.y += 1
		target_offset = Vector2(0, camera_offset_value)
		moving = true
	
	if moving:
		play_anim(1)
	else:
		play_anim(0)

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

func update_camera(delta):
	camera.offset = camera.offset.move_toward(target_offset, camera_lerp_speed * delta)

func play_anim(movement) : 
	var dir = curr_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
 
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	var dir = curr_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
