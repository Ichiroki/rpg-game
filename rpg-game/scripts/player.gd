extends CharacterBody2D

const speed = 100
@export var damage = 10
var curr_dir = "none"

# Miscellaneous Variable
@onready var hit_area = $hit_area
@onready var anim = $AnimatedSprite2D
@onready var pause_menu = $PauseMenu

# Camera Variable
@onready var camera = $Camera2D
var target_offset := Vector2.ZERO
const camera_offset_value = 20
const camera_lerp_speed = 30

# Enemy Variable
var enemy = null
var enemy_inattack_range = false
var enemy_attack_cooldown = true

# Animation Variable
var attack_ip = false
@onready var hitsound = $hitsound

# Health Bar Variable
var max_health := 175.0
var curr_health = max_health
var player_alive = true

signal health_changed(curr_health: float, max_health: float)

# Mana Bar Variable
var max_mana := 123
var curr_mana := max_mana

signal mana_changed(curr_mana: float, max_mana: float)

# Stamina Bar Variable
var max_stamina := 147
var curr_stamina := max_stamina

signal stamina_changed(curr_stamina: float, max_stamina: float)

func _input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			get_tree().paused = true
			pause_menu.show()
		else:
			get_tree().paused = false
			pause_menu.hide()

func _ready():
	var ui = $CanvasLayer/UI
	connect("health_changed", Callable(ui, "_on_health_changed"))
	connect("mana_changed", Callable(ui, "_on_mana_changed"))
	connect("stamina_changed", Callable(ui, "_on_stamina_changed"))
	
	emit_signal("health_changed", curr_health, max_health)
	emit_signal("mana_changed", curr_mana, max_mana)
	emit_signal("stamina_changed", curr_stamina, max_stamina)

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - global_position).normalized()
	
	hit_area.rotation = to_mouse.angle()
	
	var offset_distance = 20
	hit_area.position = to_mouse
	
	update_direction_by_mouse(to_mouse)

func _pause_game():
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause_game")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	attack()
	
	if curr_health <= 0 :
		player_alive = false
		self.queue_free()

func player_movement(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("walk_right"):
		input_vector.x += 1
	if Input.is_action_pressed("walk_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("walk_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("walk_down"):
		input_vector.y += 1

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

	if attack_ip:
		return
	
	if input_vector != Vector2.ZERO:
		play_walk_anim()
	else:
		play_idle_anim()

func play_idle_anim():
	match curr_dir:
		"right":
			anim.flip_h = false
			anim.play("side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_idle")
		"down":
			anim.flip_h = false
			anim.play("front_idle")
		"up":
			anim.flip_h = false
			anim.play("back_idle")
		
func play_walk_anim():
	if curr_dir == "right":
		anim.flip_h = false
		anim.play("side_walk")
	elif curr_dir == "left":
		anim.flip_h = true
		anim.play("side_walk")
	if curr_dir == "down":
		anim.flip_h = false
		anim.play("front_walk")
	if curr_dir == "up":
		anim.flip_h = false
		anim.play("back_walk")

func update_direction_by_mouse(to_mouse: Vector2):
	if abs(to_mouse.x) > abs(to_mouse.y) :
		if to_mouse.x > 0:
			curr_dir = "right"
		else:
			curr_dir = "left"
	else:
		if to_mouse.y > 0:
			curr_dir = "down"
		else:
			curr_dir = "up"

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy = body
		enemy_inattack_range = true
		$attack_cooldown.start()
		received_damage(enemy.damage)
 
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy = null
		enemy_inattack_range = false
		$attack_cooldown.stop()
		
func received_damage(amount: int):
	if enemy_inattack_range and enemy_attack_cooldown == true:
		curr_health -= amount
		curr_health = clamp(curr_health, 0, max_health)
		emit_signal("health_changed", curr_health, max_health)
		
		if curr_health <= 0:
			self.queue_free()

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if curr_dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if curr_dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if curr_dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if curr_dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy = body
		body.received_damage(damage)
