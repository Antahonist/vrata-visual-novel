# res://scripts/autoload/GameManager.gd
extends Node

# Сигнал смены локации
signal location_changed(location_name)

# Текущая сцена
var current_scene = null

# Смена локации
func change_location(location_name: String, dialogue_file: String = "") -> void:
	print("[GameManager] Changing location to: ", location_name)
	
	FlagManager.set_flag("current_location", location_name)
	
	var scene_path = "res://scenes/locations/" + location_name.capitalize() + ".tscn"
	
	if not FileAccess.file_exists(scene_path):
		push_error("[GameManager] Location scene not found: " + scene_path)
		return
	
	var new_scene = load(scene_path)
	if new_scene == null:
		push_error("[GameManager] Cannot load location: " + scene_path)
		return
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)
	
	emit_signal("location_changed", location_name)
	print("[GameManager] Location changed successfully")
	
	# Загружаем диалог если указан
	if dialogue_file != "":
		await get_tree().create_timer(0.1).timeout
		DialogueManager.load_dialogue(dialogue_file)

# Новая игра
func new_game() -> void:
	print("[GameManager] Starting new game")
	FlagManager.reset_flags()
	change_location("gatehouse", "res://data/dialogues/prologue.json")

# Выход в главное меню
func return_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

# Выход из игры
func quit_game() -> void:
	get_tree().quit()
