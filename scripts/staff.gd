extends Area2D

var staff_type: String = ""
var speed: float = 100.0
var target_position: Vector2
var ground_width: float = 1920
var ground_height: float = 720
var ground_center: Vector2 = Vector2(0, -124)

func _ready() -> void:
	var animated_sprite = AnimatedSprite2D.new()
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("move")
	
	var texture = load("res://assets/graphics/equipment/staff_%s_sprite_sheet.png" % staff_type)
	var frame_width = 64
	var frame_height = 64
	
	for frame_idx in range(3):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(frame_idx * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame("move", atlas)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.animation = "move"
	animated_sprite.frame = 0
	animated_sprite.playing = true
	animated_sprite.speed_scale = 5.0
	add_child(animated_sprite)
	
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(32, 32)
	collision_shape.shape = shape
	add_child(collision_shape)
	area_entered.connect(_on_area_entered)	
	_pick_new_target()

func _process(delta: float) -> void:
	var direction = (target_position - position).normalized()
	position += direction * speed * delta
	
	if position.distance_to(target_position) < 10:
		_pick_new_target()

func _pick_new_target() -> void:
	var x = ground_center.x - ground_width / 2 + randf() * ground_width
	var y = ground_center.y - ground_height / 2 + randf() * ground_height
	target_position = Vector2(x, y)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("items") and not area.is_poop:
		var value = area.value
		GameState.add_money(value)
		var floating_text = preload("res://scenes/FloatingText.tscn").instantiate()
		floating_text.global_position = area.global_position
		floating_text.set_text("+%d" % value)
		get_tree().get_root().add_child(floating_text)
		area.queue_free()
