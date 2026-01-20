extends Control

@onready var continue_button = $VBoxContainer/ContinueButton

func _ready():
	$VBoxContainer/NewGameButton.pressed.connect(_on_new_game)
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit)
	
	continue_button.disabled = not SaveSystem.has_save()
	
	# Включаем музыку меню
	AudioManager.play_music("main_menu_theme")

func _on_new_game():
	AudioManager.play_sfx("select_button")
	FlagManager.reset_flags()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_continue():
	AudioManager.play_sfx("select_button")
	if SaveSystem.load_game():
		var location = FlagManager.get_flag("current_location")
		get_tree().change_scene_to_file("res://scenes/locations/Gatehouse.tscn")

func _on_quit():
	AudioManager.play_sfx("select_button")
	get_tree().quit()
