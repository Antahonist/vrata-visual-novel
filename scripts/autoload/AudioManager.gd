# res://scripts/autoload/AudioManager.gd
extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var current_track: String = ""

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Master"
	add_child(music_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	print("[AudioManager] Ready")

func play_music(track_name: String, fade_in: bool = true) -> void:
	if current_track == track_name:
		return
	
	var path = "res://assets/music/" + track_name + ".mp3"
	
	if not FileAccess.file_exists(path):
		push_error("[AudioManager] Track not found: " + path)
		return
	
	current_track = track_name
	music_player.stream = load(path)
	
	if fade_in:
		music_player.volume_db = -40
		music_player.play()
		_fade_in()
	else:
		music_player.volume_db = 0
		music_player.play()
	
	print("[AudioManager] Playing: " + track_name)

func _fade_in() -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0, 1.5)

func stop_music(fade_out: bool = true) -> void:
	if fade_out:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40, 1.0)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()
	current_track = ""

func play_sfx(sound_name: String) -> void:
	var path = "res://assets/sounds/" + sound_name + ".mp3"
	
	if not FileAccess.file_exists(path):
		push_error("[AudioManager] Sound not found: " + path)
		return
	
	sfx_player.stream = load(path)
	sfx_player.play()

func set_music_volume(volume: float) -> void:
	music_player.volume_db = linear_to_db(volume)

func set_sfx_volume(volume: float) -> void:
	sfx_player.volume_db = linear_to_db(volume)
