# res://scripts/ui/DialogueBox.gd
extends Control

@onready var character_avatar = $MarginContainer/VBoxContainer/NameRow/CharacterAvatar
@onready var character_name = $MarginContainer/VBoxContainer/NameRow/CharacterName
@onready var dialogue_text = $MarginContainer/VBoxContainer/DialogueText
@onready var continue_prompt = $MarginContainer/VBoxContainer/ContinuePrompt

var is_typing = false
var text_speed = 0.03
var current_text = ""

func _ready():
	continue_prompt.visible = false
	visible = false
	
	# Ограничиваем размер аватара
	# Ограничиваем размер аватара
	if character_avatar:
		character_avatar.custom_minimum_size = Vector2(64, 64)
		character_avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		character_avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Подключаемся к сигналам
	DialogueManager.connect("dialogue_line_displayed", _on_dialogue_line)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)
	DialogueManager.connect("choices_displayed", _on_choices_displayed)
	
	print("[DialogueBox] Ready and connected to DialogueManager")

func _input(event):
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		# Проверяем видны ли кнопки выбора
		var scene = get_tree().current_scene
		if scene:
			var choices_container = scene.get_node_or_null("CanvasLayer/ChoicesContainer")
			if is_instance_valid(choices_container) and choices_container.visible and choices_container.get_child_count() > 0:
				return
		
		if is_typing:
			dialogue_text.visible_ratio = 1.0
			is_typing = false
			continue_prompt.visible = true
		else:
			DialogueManager.next_line()

func _on_dialogue_line(character: String, text: String, _emotion: String):
	visible = true
	continue_prompt.visible = false
	
	# Устанавливаем имя и аватар
	if character == "narrator" or character == "":
		character_name.text = ""
		character_avatar.texture = null
		character_avatar.visible = false
	else:
		character_name.text = character.capitalize()
		
		# Загружаем аватар (с суффиксом _portrait)
		var avatar_path = "res://assets/portraits/" + character + "_portrait.jpg"
		if FileAccess.file_exists(avatar_path):
			character_avatar.texture = load(avatar_path)
			character_avatar.visible = true
			print("[DialogueBox] Avatar loaded: ", avatar_path)
		else:
			character_avatar.texture = null
			character_avatar.visible = false
			print("[DialogueBox] Avatar not found: ", avatar_path)
	
	current_text = text
	dialogue_text.text = text
	dialogue_text.visible_ratio = 0.0
	is_typing = true
	
	print("[DialogueBox] Displaying line: ", character, " - ", text)
	_type_text()

func _type_text():
	var total_chars = current_text.length()
	
	for i in range(total_chars + 1):
		if not is_typing:
			break
		
		dialogue_text.visible_ratio = float(i) / float(total_chars)
		await get_tree().create_timer(text_speed).timeout
	
	is_typing = false
	continue_prompt.visible = true

func _on_choices_displayed(_choices: Array):
	visible = false
	is_typing = false
	continue_prompt.visible = false
	print("[DialogueBox] Hidden for choices")

func _on_dialogue_ended():
	visible = false
	print("[DialogueBox] Dialogue ended, hiding box")
