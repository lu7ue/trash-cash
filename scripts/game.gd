extends Node2D

# References
@onready var money_label = $"Tool Bar/Money/Money Label"
@onready var ground_area = $"Ground Area"
@onready var info_button = $"Tool Bar/Info/Info Button"
var info_instance: CanvasLayer
var game_over_instance: CanvasLayer
const InfoScene := preload("res://scenes/Info.tscn")
const GameOverScene := preload("res://scenes/GameOver.tscn")

var game_ended: bool = false

func _ready() -> void:
	# Connect signals
	GameState.money_changed.connect(_on_money_changed)
	GameState.reset_game.connect(_on_reset_game)
	
	# Add item spawner
	var spawner = preload("res://scenes/ItemSpawner.tscn").instantiate()
	ground_area.add_child(spawner)
	print("Spawner added:", spawner)
	print("Ground area valid:", ground_area)
	
	# Update initial money display
	_on_money_changed(GameState.player_money)
	
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
	print("Money updated to:", amount)
	if amount >= 1000000 and not game_ended:
		print("Money reached 50! Showing Game Over popup...")
		game_ended = true
		game_over_instance.visible = true
		get_tree().paused = true

func _on_info_pressed():
	print("Info button pressed!")
	info_instance.visible = true
	get_tree().paused = true

func _on_reset_game():
	print("Resetting game...")
	game_ended = false
	GameState.reset()
