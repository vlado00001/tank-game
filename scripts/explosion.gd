extends Node2D

@onready var fire: GPUParticles2D = $Fire
@onready var debris: GPUParticles2D = $Debris
@onready var sound: AudioStreamPlayer2D = $ExplosionSound

func _ready() -> void:
	fire.emitting = true
	debris.emitting = true
	sound.play()

	await get_tree().create_timer(2).timeout
	queue_free()
