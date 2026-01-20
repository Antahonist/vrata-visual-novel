# res://scripts/locations/Gatehouse.gd
extends Node2D

func _ready():
	print("[Gatehouse] Location ready")
	
	# Скрываем персонажей
	var character_left = get_node_or_null("CanvasLayer/CharacterLeft")
	var character_right = get_node_or_null("CanvasLayer/CharacterRight")
	
	if character_left:
		character_left.visible = false
	if character_right:
		character_right.visible = false
	
	# Подключаемся к сигналам
	DialogueManager.connect("dialogue_line_displayed", _on_dialogue_line)
	DialogueManager.connect("choices_displayed", _on_choices_displayed)
	DialogueManager.connect("dialogue_started", _on_dialogue_started)
	
	await get_tree().create_timer(0.1).timeout
	
	var day = int(FlagManager.get_flag("current_day"))
	print("[Gatehouse] Current day on load: ", day)
	
	# Меняем фон
	change_background(day)
	
	# Включаем игровую музыку
	if day == 3:
		AudioManager.play_music("final_stage_theme")
	else:
		AudioManager.play_music("in_game_theme")
	
	# Загружаем диалог
	match day:
		0:
			DialogueManager.load_dialogue("res://data/dialogues/prologue.json")
		1:
			DialogueManager.load_dialogue("res://data/dialogues/day1_kai.json")
		2:
			DialogueManager.load_dialogue("res://data/dialogues/day2.json")
		3:
			DialogueManager.load_dialogue("res://data/dialogues/day3_final.json")
		_:
			DialogueManager.load_dialogue("res://data/dialogues/prologue.json")
	
	print("[Gatehouse] Dialogue loaded for day ", day)

func _on_dialogue_line(character: String, _text: String, _emotion: String):
	var choices_container = get_node_or_null("CanvasLayer/ChoicesContainer")
	if choices_container:
		choices_container.visible = false
	
	var character_left = get_node_or_null("CanvasLayer/CharacterLeft")
	var character_right = get_node_or_null("CanvasLayer/CharacterRight")
	
	if character_left and character_right:
		match character:
			"anna":
				character_left.visible = true
				character_right.visible = false
				update_character_sprite(character_left, "anna")
				print("[Gatehouse] Showing Anna (left)")
			
			"velir", "kai", "mara", "mikhail":
				character_left.visible = false
				character_right.visible = true
				update_character_sprite(character_right, character)
				print("[Gatehouse] Showing ", character, " (right)")
			
			_:
				character_left.visible = false
				character_right.visible = false

func _on_choices_displayed(choices: Array):
	print("[Gatehouse] Displaying ", choices.size(), " choices")
	
	var choices_container = get_node_or_null("CanvasLayer/ChoicesContainer")
	if not choices_container:
		push_error("[Gatehouse] ChoicesContainer not found!")
		return
	
	# Очистить кнопки
	for child in choices_container.get_children():
		child.queue_free()
	
	# Создать новые
	for i in range(choices.size()):
		var choice = choices[i]
		var button = preload("res://scenes/ui/ChoiceButton.tscn").instantiate()
		button.setup(choice["text"], i)
		choices_container.add_child(button)
	
	choices_container.visible = true

func _on_dialogue_started():
	var day = int(FlagManager.get_flag("current_day"))
	print("[Gatehouse] Dialogue started, checking day: ", day)
	change_background(day)

func change_background(day: int) -> void:
	print("[Gatehouse] Changing background for day: ", day)
	
	var background = get_node_or_null("CanvasLayer/Background")
	if not background:
		push_error("[Gatehouse] Background not found!")
		return
	
	var texture_path = ""
	
	match day:
		0, 1:
			texture_path = "res://assets/background/gatehouse.png"
		2:
			texture_path = "res://assets/background/interior.png"
		3:
			texture_path = "res://assets/background/forest.png"
		_:
			texture_path = "res://assets/background/gatehouse.png"
	
	print("[Gatehouse] Loading texture: ", texture_path)
	
	if not FileAccess.file_exists(texture_path):
		push_error("[Gatehouse] Texture file not found: " + texture_path)
		return
	
	var texture = load(texture_path)
	if texture:
		background.texture = texture
		print("[Gatehouse] Background changed successfully!")
	else:
		push_error("[Gatehouse] Failed to load texture!")

func update_character_sprite(character_node, character_name: String) -> void:
	var sprite_path = "res://assets/characters/" + character_name + ".png"
	
	if not FileAccess.file_exists(sprite_path):
		print("[Gatehouse] Character sprite not found: ", sprite_path)
		return
	
	var color_rect = character_node.get_node_or_null("ColorRect")
	if not color_rect:
		return
	
	var texture_rect = color_rect.get_node_or_null("CharacterSprite")
	
	if not texture_rect:
		texture_rect = TextureRect.new()
		texture_rect.name = "CharacterSprite"
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.anchor_left = 0.0
		texture_rect.anchor_top = 0.1  # Немного отступ сверху
		texture_rect.anchor_right = 1.0
		texture_rect.anchor_bottom = 1.0
		texture_rect.offset_left = 0
		texture_rect.offset_right = 0
		texture_rect.offset_top = 0
		texture_rect.offset_bottom = -120  # Отступ снизу для диалогового окна
		color_rect.add_child(texture_rect)
	
	texture_rect.texture = load(sprite_path)
	color_rect.color = Color(1, 1, 1, 0)
	
	print("[Gatehouse] Character sprite loaded: ", sprite_path)
