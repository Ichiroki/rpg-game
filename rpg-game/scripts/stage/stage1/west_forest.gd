extends Node2D

func _process(delta):
	change_scene_to_central_forest()

func _ready():
	music.play_music(preload("res://assets/audio/silentForest.wav"))

func _on_central_forest_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true
		music.save_current_time()

func _on_central_forest_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene_to_central_forest():
	if global.transition_scene == true:
		if global.current_scene == "west_forest":
			get_tree().change_scene_to_file("res://scenes/stages/stage_1/central_forest.tscn")
			music.play_music(preload("res://assets/audio/silentForest.wav"))
			global.finish_changescenes()
