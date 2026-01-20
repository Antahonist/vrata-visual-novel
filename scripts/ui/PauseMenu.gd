# res://scripts/ui/PauseMenu.gd
extends Control

@onready var resume_btn = get_node_or_null("Panel/VBoxContainer/ResumeButton")
@onready var save_btn = get_node_or_null("Panel/VBoxContainer/SaveButton")
@onready var menu_btn = get_node_or_null("Panel/VBoxContainer/MainMenuButton")

func _ready():
	if resume_btn:
		resume_btn.pressed.connect(_on_resume)
	if save_btn:
		save_btn.pressed.connect(_on_save)
	if menu_btn:
		menu_btn.pressed.connect(_on_main_menu)
	
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	visible = not visible
	get_tree().paused = visible

func _on_resume():
	AudioManager.play_sfx("select_button")
	toggle_pause()

func _on_save():
	AudioManager.play_sfx("select_button")
	SaveSystem.save_game()

func _on_main_menu():
	get_tree().paused = false
	AudioManager.play_sfx("select_button")
	GameManager.return_to_menu()
