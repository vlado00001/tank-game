extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.kill()
	elif body.is_in_group("Tank"):
		# "call_deferred" waits for physics calculations to finish
		get_tree().call_deferred("reload_current_scene")
