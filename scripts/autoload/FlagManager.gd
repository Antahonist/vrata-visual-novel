# res://scripts/autoload/FlagManager.gd
extends Node

# Словарь всех флагов игры
var flags = {
	# Флаги отношений
	"shows_respect": false,
	"kai_opens": false,
	"mara_confession": false,
	"velir_trust": 0,  # 0-3
	
	# Флаги прогресса
	"found_diary": false,
	"read_note": false,
	"night_approach": false,
	
	# Флаг концовки
	"ending_type": "",  # "denial", "acceptance", "false_path"
	
	# Служебные
	"current_day": 1,
	"current_location": "gatehouse"
}

# Установить флаг
func set_flag(flag_name: String, value) -> void:
	if flags.has(flag_name):
		flags[flag_name] = value
		print("[FlagManager] Flag set: ", flag_name, " = ", value)
	else:
		push_warning("Flag not found: " + flag_name)

# Получить флаг
func get_flag(flag_name: String):
	if flags.has(flag_name):
		return flags[flag_name]
	else:
		push_warning("Flag not found: " + flag_name)
		return null

# Проверить условие
func check_condition(condition: String) -> bool:
	# Отрицание (! в начале)
	if condition.begins_with("!"):
		var flag = condition.substr(1)
		return not get_flag(flag)
	
	# Сравнение (>=)
	if ">=" in condition:
		var parts = condition.split(">=")
		var flag = parts[0]
		var value = int(parts[1])
		return get_flag(flag) >= value
	
	# Простая проверка boolean
	return get_flag(condition) == true

# Сброс флагов
func reset_flags() -> void:
	flags = {
		"shows_respect": false,
		"kai_opens": false,
		"mara_confession": false,
		"velir_trust": 0,
		"found_diary": false,
		"read_note": false,
		"night_approach": false,
		"ending_type": "",
		"current_day": 1,
		"current_location": "gatehouse"
	}
	print("[FlagManager] Flags reset")

# Получить все флаги (для сохранения)
func get_all_flags() -> Dictionary:
	return flags.duplicate()

# Загрузить флаги (из сохранения)
func load_flags(loaded_flags: Dictionary) -> void:
	flags = loaded_flags
	print("[FlagManager] Flags loaded")
