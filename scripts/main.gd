extends Node2D

const LEVEL = preload("res://scenes/level_root.tscn")
var level_root = null

func _ready() -> void:
	_load_level()

func _load_level() -> void:
	level_root = LEVEL.instantiate()
	level_root.name = "LevelRoot"
	add_child(level_root)
