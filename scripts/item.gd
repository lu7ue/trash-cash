extends Area2D

# Item properties
var item_type: String = ""
var value: int = 0
var is_poop: bool = false

# References
var floating_text_scene: PackedScene = preload("res://scenes/FloatingText.tscn")

func _ready() -> void:
	# Connect input event for clicks
	self.input_event.connect(_on_input_event)
	
	# Add collision shape
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(32, 32)  # Assuming 64x64 sprite
	collision_shape.shape = shape
	add_child(collision_shape)
	
	# Add sprite
	var sprite = Sprite2D.new()
	sprite.texture = load(get_texture_path())
	sprite.scale = Vector2(0.25, 0.25)
	add_child(sprite)
	
	
	# Start poop penalty if applicable
	if is_poop:
		var timer = Timer.new()
		timer.wait_time = 1.0
		timer.autostart = true
		timer.timeout.connect(_on_poop_penalty)
		add_child(timer)

func get_texture_path() -> String:
	match item_type:
		"paper_box": return "res://assets/graphics/items/waste_paper_box.png"
		"plastic_bottle": return "res://assets/graphics/items/plastic_bottle.png"
		"plastic_bag": return "res://assets/graphics/items/plastic_bag.png"
		"can": return "res://assets/graphics/items/can.png"
		"apple_core": return "res://assets/graphics/items/apple_core.png"
		"banana_peel": return "res://assets/graphics/items/banana_peel.png"
		"fish_bone": return "res://assets/graphics/items/fish_bone.png"
		"big_bone": return "res://assets/graphics/items/big_bone.png"
		"battery": return "res://assets/graphics/items/waste_battery.png"
		"medicine_bottle": return "res://assets/graphics/items/medicine_bottle.png"
		"poop": return "res://assets/graphics/items/poop.png"
		"cash": return "res://assets/graphics/items/cash.png"
		_: return ""

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Update money
		if is_poop:
			GameState.remove_money(value)  # Poop stops deducting when clicked
		else:
			GameState.add_money(value)
			
			var floating_text = floating_text_scene.instantiate()
			floating_text.global_position = global_position
			floating_text.set_text("+%d" % value)
			get_tree().get_root().add_child(floating_text)

		# Remove item
		queue_free()

func _on_poop_penalty() -> void:
	if is_poop:
		GameState.remove_money(10)
		var floating_text = floating_text_scene.instantiate()
		floating_text.position = global_position
		floating_text.set_text("-10")
		get_parent().add_child(floating_text)
