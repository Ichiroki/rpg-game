extends Node2D

func _process(delta: float) -> void:
	change_scene_to_west_forest()

func _on_west_forest_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		change_scene_to_west_forest()
		global.transition_scene = true

func _on_west_forest_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene_to_west_forest():
	if global.transition_scene == true:
		get_tree().change_scene_to_file("res://scenes/stages/stage_1/west_forest.tscn")
		global.finish_changescenes()
