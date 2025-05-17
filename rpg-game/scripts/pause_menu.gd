extends CanvasLayer

func _ready():
	hide()
	
func input_pause():
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	get_tree().paused = true
	show()

func resume_game():
	get_tree().paused = false
	hide()

func _on_resume_pressed():
	resume_game()

func _on_restart_pressed():
	get_tree().reload_current_scene()

#func _on_quit_pressed():
	#get
