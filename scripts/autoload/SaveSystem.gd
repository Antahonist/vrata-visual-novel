# res://scripts/autoload/SaveSystem.gd
extends Node

const SAVE_PATH = "user://savegame.save"

func save_game() -> bool:
	var save_data = {
		"flags": FlagManager.get_all_flags()
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("[SaveSystem] Game saved")
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		return false
	
	FlagManager.load_flags(json.data["flags"])
	print("[SaveSystem] Game loaded")
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
