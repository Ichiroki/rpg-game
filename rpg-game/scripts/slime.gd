extends CharacterBody2D

@export var speed = 80
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed
		
		if (player.position.x - position.x) < 0 :
			walking_direction("left")
		elif(player.position.x - position.x) > 0 :
			walking_direction("right")
		elif(player.position.y - position.y) < 0 :
			walking_direction("up")
		elif(player.position.y - position.y) > 0 :
			walking_direction("down")
	else:
		$AnimatedSprite2D.play("front_idle")
		
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

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
