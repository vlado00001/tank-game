extends StaticBody2D
class_name Ground

const CRATER_RADIUS = 50

@onready var polygon_2d = $Polygon2D
@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var impact_sound = $ImpactSound

var chunks = []
var pieces = []

func _ready():
	# Starts with one chunk
	chunks = [polygon_2d.polygon]
	polygon_2d.visible = false
	collision_polygon_2d.disabled = true
	rebuild()

func update_polygon_2d(pos):
	# Makes a circle around the explosion
	var crater = PackedVector2Array()
	for i in 20:
		var angle = i * 2 * PI / 20
		# Moves each point away from the center by the radius
		crater.append(polygon_2d.to_local(pos) + Vector2(cos(angle), sin(angle)) * CRATER_RADIUS)

	# Cuts the circle out of every chunk
	var new_chunks = []
	for chunk in chunks:
		for piece in Geometry2D.clip_polygons(chunk, crater):
			if piece.size() >= 3:
				new_chunks.append(piece)
	chunks = new_chunks
	call_deferred("rebuild")

func rebuild():
	# Delete the nodes from last time
	for node in pieces:
		node.queue_free()
	pieces.clear()

	for chunk in chunks:
		var dup = polygon_2d.duplicate()
		dup.visible = true
		dup.polygon = chunk
		# Reseted so the colors and texture are not messed up on the new shape
		dup.uv = chunk
		dup.vertex_colors = PackedColorArray()
		dup.polygons = []

		var shape = CollisionPolygon2D.new()
		shape.polygon = chunk

		add_child(dup)
		add_child(shape)
		pieces.append(dup)
		pieces.append(shape)

func play_impact_sound(pos):
	if impact_sound.stream != null:
		impact_sound.global_position = pos
		impact_sound.play()
