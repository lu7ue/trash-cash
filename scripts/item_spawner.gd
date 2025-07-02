extends Node2D

@onready var timer = $Timer
var game_start_time = 0.0

# Item scene
var item_scene: PackedScene = preload("res://scenes/Item.tscn")

# Item probabilities and values
var items: Array = [
	{"type": "paper_box", "probability": 0.1, "value": 50},
	{"type": "plastic_bottle", "probability": 0.1, "value": 30},
	{"type": "plastic_bag", "probability": 0.1, "value": 20},
	{"type": "can", "probability": 0.1, "value": 40},
	{"type": "apple_core", "probability": 0.08, "value": 10},
	{"type": "banana_peel", "probability": 0.08, "value": 10},
	{"type": "fish_bone", "probability": 0.07, "value": 15},
	{"type": "big_bone", "probability": 0.07, "value": 20},
	{"type": "battery", "probability": 0.05, "value": 100},
	{"type": "medicine_bottle", "probability": 0.05, "value": 80},
	{"type": "poop", "probability": 0.05, "value": 0, "is_poop": true},
	{"type": "cash", "probability": 0.1, "value": 200}
]

# Ground area boundaries
var ground_width: float = 1920
var ground_height: float = 620
var ground_center: Vector2 = Vector2(0, -150)

func _ready() -> void:
	print("Item spawner called")
	game_start_time = Time.get_ticks_msec() / 1000.0
	timer.wait_time = 1.5
	timer.timeout.connect(Callable(self, "_on_spawn_timer"))
	timer.start()

func _on_spawn_timer() -> void:
	# Calculate total probability
	var total_prob: float = 0.0
	for item in items:
		total_prob += item.probability
	
	# Randomly select an item
	var rand = randf() * total_prob
	var cumulative_prob: float = 0.0
	for item in items:
		cumulative_prob += item.probability
		if rand <= cumulative_prob:
			spawn_item(item)
			break
	
	# Increase spawn rate
	var elapsed = Time.get_ticks_msec() / 1000.0 - game_start_time
	timer.wait_time = clamp(1.5 - elapsed * 0.05, 0.5, 1.5)
	timer.start()

func spawn_item(item_data: Dictionary) -> void:
	var item = item_scene.instantiate()
	item.item_type = item_data.type
	item.value = item_data.value
	item.is_poop = item_data.get("is_poop", false)
	
	# Random position within ground area
	var x = ground_center.x - ground_width / 2 + randf() * ground_width
	var y = ground_center.y - ground_height / 2 + randf() * ground_height
	item.position = Vector2(x, y)
	#print("Item spawned:", item.item_type)
	
	get_parent().add_child(item)
