# res://scripts/TestScene.gd
extends Node2D

func _ready():
	# Тест FlagManager
	print("=== ТЕСТ FLAGMANAGER ===")
	
	# Установить флаг
	FlagManager.set_flag("shows_respect", true)
	
	# Получить флаг
	var respect = FlagManager.get_flag("shows_respect")
	print("shows_respect = ", respect)
	
	# Установить число
	FlagManager.set_flag("velir_trust", 2)
	
	# Проверить условие
	if FlagManager.check_condition("velir_trust>=2"):
		print("Велир доверяет!")
	
	# Проверить отрицание
	if FlagManager.check_condition("!kai_opens"):
		print("Кай не открылся")
	
	print("=== ТЕСТ ЗАВЕРШЁН ===")
