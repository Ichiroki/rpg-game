extends CharacterBody2D

@export var speed = 60
var direction = Vector2.ZERO

var player_chase = false
var player = null
var player_inattack_zone = false
var health = 30

@export var chase_speed = 80
var random_timer = 0.0
var change_dir_interval = 2.0

var is_dead = false
var can_take_damage = true

func _ready():
	randomize()

func _physics_process(delta: float) -> void:
	deal_damage()
	
	if player_chase:
		position += direction.normalized() * speed * delta
		
		if abs(direction.x) > abs(direction.y) :
			if direction.x > 0 :
				walking_direction("right")
			else:
				walking_direction("left")
		else:
			if direction.y > 0:
				walking_direction("down")
			else:
				walking_direction("up")
	else:
		random_timer -= delta
		if random_timer <= 0:
			change_direction()
			random_timer = change_dir_interval
		velocity = direction * speed
		
	move_and_collide(Vector2.ZERO, 0)

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

func enemy():
	pass

func deal_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true :
			health -= 20
			$take_damage_timer.start()
			can_take_damage = false
			if health <= 0:
				$AnimatedSprite2D.play("dead")
				self.queue_free()

func _on_slime_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true
		deal_damage()

func _on_slime_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		
func _on_take_damage_timer_timeout() -> void:
	can_take_damage = true
