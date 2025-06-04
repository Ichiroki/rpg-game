extends CanvasLayer

@onready var resume_button = $Panel/Resume
@onready var quit_button = $Panel/Quit

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	
func _unpause_game():
	get_tree().paused = false
	visible = false

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	_unpause_game()
