extends Node

var current_time = 0.0
@onready var stream_player := $AudioStreamPlayer

var time_memory = {
	"stage_1_map_a": 0.0,
	"stage_1_map_b": 0.0,
}

func play_music(stream: AudioStream):
	stream_player.stream = stream
	stream_player.play(current_time)
	print(current_time)
	
func save_current_time():
	current_time = stream_player.get_playback_position()
	
func stop_music():
	save_current_time()
	stream_player.stop()
