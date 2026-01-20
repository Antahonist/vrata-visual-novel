extends Button

var choice_index = 0

func _ready():
	connect("pressed", _on_pressed)

func setup(choice_text: String, index: int):
	text = str(index + 1) + ". " + choice_text  # Добавляем номер
	choice_index = index
	print("[ChoiceButton] Created: ", choice_text)

func _input(event):
	if not visible or disabled:
		return
	
	# Обработка клавиш 1, 2
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1 and choice_index == 0:
			_on_pressed()
		elif event.keycode == KEY_2 and choice_index == 1:
			_on_pressed()

func _on_pressed():
	AudioManager.play_sfx("select_button")
	print("[ChoiceButton] Pressed: ", text)
	DialogueManager.make_choice(choice_index)
	get_parent().visible = false
