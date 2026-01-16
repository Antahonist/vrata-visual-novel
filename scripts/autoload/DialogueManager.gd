# res://scripts/autoload/DialogueManager.gd
extends Node

signal dialogue_started
signal dialogue_line_displayed(character, text, emotion)
signal choices_displayed(choices)
signal dialogue_ended

var current_dialogue = []
var current_index = 0
var is_active = false

func load_dialogue(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Cannot open dialogue file: " + file_path)
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error != OK:
		push_error("JSON Parse Error in " + file_path + ": " + json.get_error_message())
		return
	
	current_dialogue = json.data
	current_index = 0
	is_active = true
	
	print("[DialogueManager] Dialogue loaded: ", file_path)
	emit_signal("dialogue_started")
	display_current_line()

func display_current_line() -> void:
	if current_index >= current_dialogue.size():
		end_dialogue()
		return
	
	var line = current_dialogue[current_index]
	
	# Проверка условий
	if line.has("condition"):
		if not FlagManager.check_condition(line["condition"]):
			current_index += 1
			display_current_line()
			return
	
	# Обработка типов
	match line["type"]:
		"dialogue":
			emit_signal("dialogue_line_displayed", 
				line.get("character", ""), 
				line["text"], 
				line.get("emotion", "neutral"))
		
		"choice":
			display_choices(line["choices"])
			return
		
		"set_flag":
			FlagManager.set_flag(line["flag"], line["value"])
			next_line()
		
		"change_location":
			print("[DialogueManager] Change location to: ", line["location"])
			next_line()
		
		"end":
			end_dialogue()

# Отображение выборов
func display_choices(choices: Array) -> void:
	is_active = false  # Останавливаем диалог пока игрок выбирает
	emit_signal("choices_displayed", choices)

func next_line() -> void:
	if not is_active:
		return
	
	current_index += 1
	display_current_line()

func make_choice(choice_index: int) -> void:
	var line = current_dialogue[current_index]
	if line["type"] != "choice":
		return
	
	var choice = line["choices"][choice_index]
	
	# Установить флаг
	if choice.has("set_flag"):
		FlagManager.set_flag(choice["set_flag"], choice.get("flag_value", true))
	
	# Включаем диалог обратно
	is_active = true
	
	# Продолжить
	if choice.has("next_dialogue"):
		load_dialogue(choice["next_dialogue"])
	else:
		next_line()

@warning_ignore("unused_parameter")
func show_ending(ending_type: String):
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Ending.tscn")

func end_dialogue() -> void:
	is_active = false
	current_dialogue = []
	current_index = 0
	print("[DialogueManager] Dialogue ended")
	
	# Проверяем концовку
	var ending = FlagManager.get_flag("ending_type")
	if ending != "" and ending != null:
		print("[DialogueManager] Ending detected: ", ending)
		show_ending(ending)
		return
	
	# Проверяем день
	var day = int(FlagManager.get_flag("current_day"))
	print("[DialogueManager] Current day value: ", day)
	
	match day:
		1:
			print("[DialogueManager] Loading day 1...")
			await get_tree().create_timer(0.5).timeout
			load_dialogue("res://data/dialogues/day1_kai.json")
		2:
			print("[DialogueManager] Loading day 2...")
			await get_tree().create_timer(0.5).timeout
			load_dialogue("res://data/dialogues/day2.json")
		3:
			print("[DialogueManager] Loading day 3...")
			await get_tree().create_timer(0.5).timeout
			load_dialogue("res://data/dialogues/day3_final.json")
		_:
			print("[DialogueManager] Default case")
			emit_signal("dialogue_ended")
