extends Node2D

# References
@onready var money_label = $"Tool Bar/Money/Money Label"
@onready var ground_area = $"Ground Area"
@onready var info_button = $"Tool Bar/Info/Info Button"
@onready var equipment = $"Equipment"

# Equipment data
var equipment_data = {
	"staff": {
		"dog": {"price": 5, "scene": preload("res://scenes/Staff.tscn")},
		"human": {"price": 15, "scene": preload("res://scenes/Staff.tscn")},
		"robot": {"price": 30, "scene": preload("res://scenes/Staff.tscn")},
		"drone": {"price": 40, "scene": preload("res://scenes/Staff.tscn")}
	},
	"tools": {
		"spoon": {"price": 10, "durability": 10},
		"broom": {"price": 30, "durability": 20},
		"net": {"price": 50, "durability": 30},
		"vacuum": {"price": 100, "durability": 50}
	},
	"drinks": {
		"soda": {"price": 20, "multiplier": 1.5, "duration": 10.0},
		"juice": {"price": 50, "multiplier": 2.0, "duration": 15.0},
		"cola": {"price": 80, "multiplier": 3.0, "duration": 20.0},
		"tea": {"price": 60, "multiplier": 2.5, "duration": 30.0}
	}
}

var info_instance: CanvasLayer
var game_over_instance: CanvasLayer
const InfoScene := preload("res://scenes/Info.tscn")
const GameOverScene := preload("res://scenes/GameOver.tscn")

var game_ended: bool = false

func _ready() -> void:
	# Connect signals
	GameState.money_changed.connect(_on_money_changed)
	GameState.tool_changed.connect(_on_tool_changed)
	#GameState.rink_multiplier_changed.connect(_on_drink_multiplier_changed)
	GameState.reset_game.connect(_on_reset_game)
	
	# Add item spawner
	var spawner = preload("res://scenes/ItemSpawner.tscn").instantiate()
	ground_area.add_child(spawner)
	print("Spawner added:", spawner)
	print("Ground area valid:", ground_area)
	
	# Connect equipment buttons
	for category in ["Staff", "Tools", "Drinks"]:
		for item in equipment_data[category.to_lower()]:
			var button = equipment.get_node("%s/%s/%sIcon" % [category, item.capitalize(), item.capitalize()])
			button.pressed.connect(Callable(self, "_on_equipment_pressed").bind(category.to_lower(), item))
	
	# Initialize progress bars
	for tool in equipment_data.tools:
		var progress = TextureProgressBar.new()
		progress.name = "%sProgress" % tool.capitalize()
		progress.max_value = equipment_data.tools[tool].durability
		progress.value = 0
		progress.rect_position = equipment.get_node("Tools/%s" % tool.capitalize()).position + Vector2(-945, 400)
		progress.rect_size = Vector2(108, 10)
		progress.tint_progress = Color.GREEN
		equipment.get_node("Tools").add_child(progress)
	
	for drink in equipment_data.drinks:
		var progress = TextureProgressBar.new()
		progress.name = "%sProgress" % drink.capitalize()
		progress.max_value = equipment_data.drinks[drink].duration * 100
		progress.value = 0
		progress.rect_position = equipment.get_node("Drinks/%s" % drink.capitalize()).position + Vector2(-945, 400)
		progress.rect_size = Vector2(108, 10)
		progress.tint_progress = Color.BLUE
		equipment.get_node("Drinks").add_child(progress)
	
	# Update initial states
	_on_money_changed(GameState.player_money)
	_on_tool_changed(GameState.active_tool, GameState.tool_durability)
	_on_drink_multiplier_changed(GameState.drink_multiplier)
	
	# Create Info instance
	info_instance = InfoScene.instantiate()
	info_instance.visible = false
	info_instance.layer = 0
	add_child(info_instance)
	print("Info instance added:", info_instance)
	
	# Create GameOver instance
	game_over_instance = GameOverScene.instantiate()
	game_over_instance.visible = false
	game_over_instance.layer = 3
	add_child(game_over_instance)
	game_over_instance.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	# Connect info button
	if info_button:
		info_button.pressed.connect(_on_info_pressed)
	else:
		print("Error: Info button not found at path 'Tool Bar/Info/Info Button'")

func _on_money_changed(amount: int) -> void:
	money_label.text = "$ " + str(amount)
	_update_button_states()

	print("Money updated to:", amount)
	if amount >= 1000000 and not game_ended:
		print("Money reached 50! Showing Game Over popup...")
		game_ended = true
		game_over_instance.visible = true
		get_tree().paused = true

func _on_equipment_pressed(category: String, item: String) -> void:
	var data = equipment_data[category][item]
	if GameState.player_money >= data.price:
		GameState.remove_money(data.price)
		if category == "staff":
			var staff = data.scene.instantiate()
			staff.staff_type = item
			staff.position = Vector2(0, -124)  # Center of GroundArea
			ground_area.add_child(staff)
		elif category == "tools":
			if GameState.active_tool == "":
				GameState.set_tool(item, data.durability)
		elif category == "drinks":
			if equipment.get_node("Drinks/%sProgress" % item.capitalize()).value == 0:
				GameState.set_drink_multiplier(data.multiplier)
				var timer = Timer.new()
				timer.wait_time = data.duration
				timer.one_shot = true
				timer.timeout.connect(Callable(self, "_on_drink_timeout").bind(item))
				add_child(timer)
				timer.start()
				var progress = equipment.get_node("Drinks/%sProgress" % item.capitalize())
				var tween = create_tween()
				tween.tween_property(progress, "value", 0, data.duration).from(data.duration * 100)
	_update_button_states()

func _on_tool_changed(tool_type: String, durability: int) -> void:
	# Update cursor
	if tool_type == "":
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	else:
		var texture = load("res://assets/graphics/equipment/tool_%s.PNG" % tool_type)
		Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW, Vector2(16, 16))
	
	# Update progress bars
	for tool in equipment_data.tools:
		var progress = equipment.get_node("Tools/%sProgress" % tool.capitalize())
		progress.value = durability if tool_type == tool else 0
		_update_button_states()

func _on_drink_multiplier_changed(_multiplier: float) -> void:
	_update_button_states()

func _on_drink_timeout(drink: String) -> void:
	#GameState.reset_drink_multiplier()
	_update_button_states()
	
func _update_button_states() -> void:
	for category in ["staff", "tools", "drinks"]:
		for item in equipment_data[category]:
			var button = equipment.get_node("%s/%s/%sIcon" % [category.capitalize(), item.capitalize(), item.capitalize()])
			var price = equipment_data[category][item].price
			var enabled = GameState.player_money >= price
			if category == "tools":
				enabled = enabled and GameState.active_tool == "" and equipment.get_node("Tools/%sProgress" % item.capitalize()).value == 0
			elif category == "drinks":
				enabled = enabled and equipment.get_node("Drinks/%sProgress" % item.capitalize()).value == 0
			button.disabled = not enabled
			button.modulate = Color.WHITE if enabled else Color(0.5, 0.5, 0.5)
	
func _on_info_pressed():
	print("Info button pressed!")
	info_instance.visible = true
	get_tree().paused = true

func _on_reset_game():
	print("Resetting game...")
	game_ended = false
	GameState.reset()
