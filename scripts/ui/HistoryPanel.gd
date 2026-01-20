# res://scripts/ui/HistoryPanel.gd
extends Control

@onready var scroll_container = $Panel/ScrollContainer
@onready var history_list = $Panel/ScrollContainer/HistoryList
@onready var close_btn = $Panel/CloseButton

func _ready():
	close_btn.pressed.connect(_on_close)
	visible = false

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_H:
		toggle_history()
	
	if visible and event.is_action_pressed("ui_cancel"):
		hide_history()
	
	# Также можно открыть колёсиком мыши вверх
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and not visible:
			show_history()

func toggle_history():
	if visible:
		hide_history()
	else:
		show_history()

func show_history():
	_populate_history()
	visible = true
	AudioManager.play_sfx("select_button")

func hide_history():
	visible = false

func _on_close():
	AudioManager.play_sfx("select_button")
	hide_history()

func _populate_history():
	for child in history_list.get_children():
		child.queue_free()
	
	if DialogueManager.dialogue_history.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "История пуста"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		history_list.add_child(empty_label)
		return
	
	for entry in DialogueManager.dialogue_history:
		var label = RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.custom_minimum_size = Vector2(350, 0)
		
		var character = entry["character"]
		var text = entry["text"]
		
		if character == "" or character == "narrator":
			label.text = "[i][color=gray]" + text + "[/color][/i]"
		elif character == "player":
			label.text = "[color=cyan]" + text + "[/color]"
		else:
			label.text = "[b][color=yellow]" + character.capitalize() + ":[/color][/b] " + text
		
		history_list.add_child(label)
	
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
