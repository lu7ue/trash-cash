extends Node2D

# References
@onready var money_label = $"Tool Bar/Money/Money Label"
@onready var ground_area = $"Ground Area"

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

func _on_money_changed(amount: int) -> void:
	money_label.text = "$ %d" % amount
