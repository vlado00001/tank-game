extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = 300.0
const GRAVITY = 1000
const SHOOTING_FORCE = 900.0
const MUZZLE_OFFSET = 40.0
const BULLET_SCENE = preload("res://scenes/bullet.tscn")

@onready var body_animated_sprite_2d: AnimatedSprite2D = $CollisionShape2D/Body_AnimatedSprite2D
@onready var cannon_sprite_2d: Sprite2D = $Cannon_Sprite2D
@onready var trajectory_line: Line2D = $Cannon_Sprite2D/Line2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = max(velocity.y, 0)

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JUMP_FORCE

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.length() > 0.1:
		body_animated_sprite_2d.play("moving")
	else:
		body_animated_sprite_2d.play("idle")
	# Cannon rotation
	cannon_sprite_2d.rotation = (get_global_mouse_position() - cannon_sprite_2d.global_position).angle() - PI
	_update_trajectory()
	move_and_slide()

func _update_trajectory() -> void:
	var dir = (get_global_mouse_position() - cannon_sprite_2d.global_position).normalized()
	var pos = cannon_sprite_2d.global_position + dir * MUZZLE_OFFSET
	var vel = dir * SHOOTING_FORCE

	trajectory_line.clear_points()
	for i in 100:
		trajectory_line.add_point(trajectory_line.to_local(pos))
		vel.y += GRAVITY / 60.0
		pos += vel / 60.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_shoot()

func _shoot() -> void:
	var dir: Vector2 = (get_global_mouse_position() - cannon_sprite_2d.global_position).normalized()
	var ball: RigidBody2D = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(ball)
	ball.global_position = cannon_sprite_2d.global_position + dir * MUZZLE_OFFSET
	ball.add_collision_exception_with(self)
	ball.apply_central_impulse(dir * SHOOTING_FORCE * ball.mass)

func die() -> void:
	get_tree().call_deferred("reload_current_scene")
