# res://scripts/Main.gd
extends Node

func _ready():
	print("[Main] Starting game...")
	
	# Используем change_scene вместо ручной загрузки
	get_tree().change_scene_to_file("res://scenes/locations/Gatehouse.tscn")
