extends CharacterBody2D

const SPEED = 90

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var Tank: Node2D = null
@export var dead: bool = false

func _ready() -> void:
	animated_sprite_2d.play("walking")
	if Tank == null:
		Tank = get_tree().get_first_node_in_group("Tank")

func _physics_process(delta: float) -> void:
	if dead:
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0
		
	# Walking toward the tank
	if is_instance_valid(Tank):
		var difference: float = (Tank.global_position - global_position).normalized().x
		velocity = Vector2(difference * SPEED, max(velocity.y, 0))
		# Face the direction of movement
		if abs(difference) > 0.0:
			if difference < 0.0:
				animated_sprite_2d.flip_h = true
			else:
				animated_sprite_2d.flip_h = false
		else:
			velocity.x = 0.0

	move_and_slide()
	
func kill() -> void:
	if dead:
		return
		
	dead = true
	velocity.x = 0
	
	$CollisionShape2D.set_deferred("disabled", true)
	$HitArea/CollisionShape2D.set_deferred("disabled", true)
	
	animated_sprite_2d.play("dying2")


func _on_hit_area_body_entered(body: Node2D) -> void:
	# Tank shall only die once
	if dead:
		return
	if body.is_in_group("Tank") and body.has_method("die"):
		body.die()
		queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if dead:
		queue_free()
