# res://scripts/GameScene.gd
extends Node2D

# Ссылка на контейнер с кнопками выбора
@onready var choices_container = $ChoicesContainer

func _ready():
	# Подключаемся к сигналу выборов
	DialogueManager.connect("choices_displayed", _on_choices_displayed)
	# Подключаемся к сигналу начала новой строки диалога
	DialogueManager.connect("dialogue_line_displayed", _on_dialogue_line_displayed)
	
	print("[GameScene] Loading test dialogue...")
	DialogueManager.load_dialogue("res://data/dialogues/test_dialogue.json")

# Вызывается когда нужно показать выборы
func _on_choices_displayed(choices: Array):
	print("[GameScene] Displaying ", choices.size(), " choices")
	
	# Очистить предыдущие кнопки (если были)
	for child in choices_container.get_children():
		child.queue_free()
	
	# Создать новые кнопки
	for i in range(choices.size()):
		var choice = choices[i]
		
		# Загружаем сцену кнопки
		var button = preload("res://scenes/ui/ChoiceButton.tscn").instantiate()
		
		# Настраиваем кнопку
		button.setup(choice["text"], i)
		
		# Добавляем в контейнер
		choices_container.add_child(button)
	
	# Показываем контейнер
	choices_container.visible = true

# Вызывается при каждой новой строке диалога
func _on_dialogue_line_displayed(_character: String, _text: String, _emotion: String):
	# Скрываем контейнер выборов когда появляется новая реплика
	if is_instance_valid(choices_container):
		choices_container.visible = false
