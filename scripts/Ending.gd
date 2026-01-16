extends Control

@onready var ending_text = $EndingText

func _ready():
	$Button.pressed.connect(_on_menu)
	
	var ending = FlagManager.get_flag("ending_type")
	
	match ending:
		"denial":
			ending_text.text = "КОНЦОВКА 1: ОТРИЦАНИЕ\n\nАнна не смогла принять выбор брата.\nОна вернулась домой опустошённой,\nтак и не найдя ответов."
		"acceptance":
			ending_text.text = "КОНЦОВКА 2: ПРИНЯТИЕ\n\nАнна приняла выбор брата.\nОна поняла, что каждый идёт своим путём.\nТеперь она готова найти свой собственный."
		"escape":
			ending_text.text = "КОНЦОВКА 3: БЕГСТВО\n\nАнна решила остаться с братом в Обители.\nНо это был путь бегства от мира,\nа не путь к истинному освобождению."
		_:
			ending_text.text = "КОНЕЦ"

func _on_menu():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
