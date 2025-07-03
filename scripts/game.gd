extends Node2D

# References
@onready var money_label = $"Tool Bar/Money/Money Label"
@onready var ground_area = $"Ground Area"
@onready var info_button = $"Tool Bar/Info/Info Button"
var info_instance: CanvasLayer
const InfoScene := preload("res://scenes/Info.tscn")

func _ready() -> void:
	# Connect money changed signal
	GameState.money_changed.connect(_on_money_changed)
	
	# Add item spawner
	var spawner = preload("res://scenes/ItemSpawner.tscn").instantiate()
	ground_area.add_child(spawner)
	print("Spawner added:", spawner)
	print("Ground area valid:", ground_area)
	
	# Update initial money display
	_on_money_changed(GameState.player_money)
	
	# create instance for Info scene and add sub nodes for it
	info_instance = InfoScene.instantiate()
	info_instance.visible = false
	add_child(info_instance)
	print("Info instance added:", info_instance)
	
	# connect with info btn
	if info_button:
		info_button.pressed.connect(_on_info_pressed)
	else:
		print("Error: Info button not found at path 'Tool Bar/Info/Info Button'")

func _on_money_changed(amount: int) -> void:
	money_label.text = "$ " + str(amount)

func _on_info_pressed():
	print("Info button pressed!")
	info_instance.visible = true
	get_tree().paused = true
