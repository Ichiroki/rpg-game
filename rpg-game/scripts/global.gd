extends Node

# Player Behavior Variable
var player_current_attack = false

# Player UI Variabel
var player_health

# Scene Variabel
var transition_scene = false
var current_scene = "west_forest"

var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_cliffside_posx = 0
var player_start_cliffside_posy = 0

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "west_forest":
			current_scene = "central_forest"
		else:
			current_scene = "west_forest"
