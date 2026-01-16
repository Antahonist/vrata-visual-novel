# res://scripts/locations/BaseLocation.gd
extends Node2D

# Параметры локации (будут устанавливаться в дочерних локациях)
@export var location_name = "base"
@export var background_texture: Texture2D
@export var music_track = ""

# Ссылки на дочерние ноды
@onready var background = $Background
@onready var character_left = $CharacterLeft
@onready var character_right = $CharacterRight
@onready var dialogue_box = $CanvasLayer/DialogueBox

func _ready():
	print("[BaseLocation] Location ready: ", location_name)
	
	# ДОБАВЬ ПРОВЕРКИ:
	print("[BaseLocation] Checking nodes...")
	
	if has_node("Background"):
		print("[BaseLocation] ✓ Background found")
	else:
		print("[BaseLocation] ✗ Background NOT found")
	
	if has_node("CharacterLeft"):
		print("[BaseLocation] ✓ CharacterLeft found")
	else:
		print("[BaseLocation] ✗ CharacterLeft NOT found")
	
	if has_node("CharacterRight"):
		print("[BaseLocation] ✓ CharacterRight found")
	else:
		print("[BaseLocation] ✗ CharacterRight NOT found")
	
	if has_node("CanvasLayer/DialogueBox"):
		print("[BaseLocation] ✓ DialogueBox found")
	else:
		print("[BaseLocation] ✗ DialogueBox NOT found!")
		push_error("DialogueBox is missing! Add it to CanvasLayer!")
	
	# Установить фон
	if background_texture and has_node("Background"):
		background.texture = background_texture
	
	# Скрыть персонажей по умолчанию
	if has_node("CharacterLeft"):
		character_left.visible = false
	if has_node("CharacterRight"):
		character_right.visible = false

# Показать персонажа слева
func show_character_left(character_name: String, emotion: String = "neutral"):
	var sprite_path = "res://assets/characters/" + character_name + "/" + character_name + "_" + emotion + ".png"
	
	if FileAccess.file_exists(sprite_path):
		var texture = load(sprite_path)
		character_left.texture = texture
		character_left.visible = true
		print("[BaseLocation] Showing ", character_name, " (left) with emotion: ", emotion)
	else:
		push_warning("[BaseLocation] Character sprite not found: " + sprite_path)

# Показать персонажа справа
func show_character_right(character_name: String, emotion: String = "neutral"):
	var sprite_path = "res://assets/characters/" + character_name + "/" + character_name + "_" + emotion + ".png"
	
	if FileAccess.file_exists(sprite_path):
		var texture = load(sprite_path)
		character_right.texture = texture
		character_right.visible = true
		print("[BaseLocation] Showing ", character_name, " (right) with emotion: ", emotion)
	else:
		push_warning("[BaseLocation] Character sprite not found: " + sprite_path)

# Скрыть персонажа слева
func hide_character_left():
	character_left.visible = false

# Скрыть персонажа справа
func hide_character_right():
	character_right.visible = false

# Скрыть всех персонажей
func hide_all_characters():
	character_left.visible = false
	character_right.visible = false
