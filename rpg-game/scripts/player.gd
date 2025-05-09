extends CharacterBody2D

const speed = 100
var curr_dir = "none"
@onready var camera = $Camera2D
var target_offset := Vector2.ZERO
const camera_offset_value = 20
const camera_lerp_speed = 30

func _physics_process(delta: float) -> void:
	player_movement(delta)
	update_camera(delta)

func player_movement(delta):
	var input_vector = Vector2.ZERO
	var moving = false
	
	if Input.is_action_pressed("ui_right"):
		curr_dir = "right"
		input_vector.x += 1
		target_offset = Vector2(camera_offset_value, 0)
		moving = true
	if Input.is_action_pressed("ui_left"):
		curr_dir = "left"
		input_vector.x -= 1
		target_offset = Vector2(-camera_offset_value, 0)
		moving = true
	if Input.is_action_pressed("ui_up"):
		curr_dir = "up"
		input_vector.y -= 1
		target_offset = Vector2(0, -camera_offset_value)
		moving = true
	if Input.is_action_pressed("ui_down"):
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
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

func player():
	pass
