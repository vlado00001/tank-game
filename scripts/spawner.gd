extends Node2D

@export var scenes_to_spawn: Array[PackedScene]
@export var markers: Array[Marker2D]
@export var tank: CharacterBody2D
@export var max_enemies: int = 40

func _ready() -> void:
	var timer: Timer = Timer.new()
	self.add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(2)

func _on_timer_timeout() -> void:
	var enemies = []
	for child in get_children():
		if child is CharacterBody2D:
			enemies.push_back(child)

	if enemies.size() <= max_enemies:
		var marker: Marker2D = markers.pick_random()
		var instance = scenes_to_spawn.pick_random().instantiate()
		instance.global_position = marker.global_position
		instance.dead = false
		instance.Tank = tank
		add_child(instance)
