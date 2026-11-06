extends RigidBody2D

const EXPLOSION_SCENE = preload("res://scenes/explosion.tscn")

@onready var destruction_area_2d: Area2D = $Destruction_Area2D
var exploded: bool = false

func _ready() -> void:
	# Monitoring collision
	contact_monitor = true
	max_contacts_reported = 4
	# Makes the air drag 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	# Removing bullets after 5 seconds of existence
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _on_body_entered(body: Node) -> void:
	# The bullet shall only explode once
	if exploded:
		return
	exploded = true

	var ground = get_tree().get_first_node_in_group("Ground")
	if ground is Ground:
		ground.update_polygon_2d(global_position)

	if body is Ground:
		body.play_impact_sound(global_position)
	# Gets bodies in explosion area and kills enemies + explodes the ground
	for overlap in destruction_area_2d.get_overlapping_bodies():
		if overlap.is_in_group("Enemy") and overlap.has_method("kill"):
			overlap.kill()

	var explosion = EXPLOSION_SCENE.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()
