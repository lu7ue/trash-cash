extends Node2D

# Drinks configuration
var drinks: Array = [
	{"drink_name": "Soda", "drink_price": 50},
	{"drink_name": "Juice", "drink_price": 100},
	{"drink_name": "Cola", "drink_price": 150},
	{"drink_name": "Tea", "drink_price": 200},
]

# Cooldown durations in seconds
var cooldowns = {
	"Soda": 30.0,
	"Juice": 30.0,
	"Cola": 30.0,
	"Tea": 30.0
}

# Track active cooldowns
var cooldown_timers: Dictionary = {}

func _ready() -> void:
	for drink_node in $Drinks.get_children():
		# Store price in metadata
		for drink_data in drinks:
			if drink_data["drink_name"] == drink_node.name:
				drink_node.set_meta("drink_price", drink_data["drink_price"])
				
				# Connect button signal
				var button_name = "%s Icon" % drink_node.name
				if drink_node.has_node(button_name):
					var button: Button = drink_node.get_node(button_name)
					button.pressed.connect(Callable(self, "_on_drink_pressed").bind(drink_node))
				else:
					print("Warning: Button not found for drink:", drink_node.name)
				break

func _on_drink_pressed(drink_node: Node) -> void:
	if drink_node.has_meta("drink_price"):
		
		if cooldown_timers.has(drink_node):
			print(drink_node.name, " is on cooldown!")
			return
		
		var price = drink_node.get_meta("drink_price")
		if GameState.player_money < abs(price):
			print("Not enough money!")
			return
			
		GameState.remove_money(price)
		print("Bought %s, applied price %d" % [drink_node.name, price])
		
		# Determine multiplier based on drink
		var multiplier: float
		match drink_node.name:
			"Soda":
				multiplier = 1.5
			"Juice":
				multiplier = 2.0
			"Cola":
				multiplier = 3.0
			"Tea":
				multiplier = 4.0
			_:
				multiplier = 1.0
		
		# Apply item multiplier
		var spawner = get_tree().root.get_node("Game/Ground Area/ItemSpawner") # adjust path
		if spawner:
			spawner.apply_price_multiplier(multiplier, 30.0)

		# Start cooldown with ColorRect overlay
		_start_cooldown(drink_node)

func _start_cooldown(drink_node: Node) -> void:
	var duration = cooldowns[drink_node.name]
	
	# Create ColorRect overlay
	var button = drink_node.get_node("%s Icon" % drink_node.name) as Button
	var mask = ColorRect.new()
	mask.color = Color(0,0,0,0.5)  # semi-transparent black
	mask.size = Vector2(200, 100)
	mask.position = button.position
	drink_node.add_child(mask)
	
	# Store cooldown info
	cooldown_timers[drink_node] = {
		"remaining": duration,
		"mask": mask,
		"total": duration
	}

func _process(delta: float) -> void:
	# Update all active cooldowns
	for drink_node in cooldown_timers.keys():
		var data = cooldown_timers[drink_node]
		data["remaining"] -= delta
		
		var button = drink_node.get_node("%s Icon" % drink_node.name) as Button
		var ratio = max(data["remaining"] / data["total"], 0)
		data["mask"].size.x = button.get_size().x * ratio
		
		if data["remaining"] <= 0:
			data["mask"].queue_free()
			cooldown_timers.erase(drink_node)
