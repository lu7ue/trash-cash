extends Node

signal money_changed(new_amount: int)
signal tool_changed(tool_type: String, durability: int)
signal drink_multiplier_changed(multiplier: float)
signal reset_game

# Variables
var active_tool: String = ""
var tool_durability: int = 0
var drink_multiplier: float = 1.0

@export var player_money: int = 0:
	set(value):
		player_money = max(0, value)
		money_changed.emit(player_money)
	get:
		return player_money

func add_money(amount: int) -> void:
	player_money += amount

func remove_money(amount: int) -> void:
	player_money -= amount

func set_tool(tool_type: String, durability: int) -> void:
	active_tool = tool_type
	tool_durability = durability
	emit_signal("tool_changed", tool_type, tool_durability)

func use_tool() -> void:
	if tool_durability > 0:
		tool_durability -= 1
		if tool_durability <= 0:
			active_tool = ""
		emit_signal("tool_changed", active_tool, tool_durability)

func set_drink_multiplier(multiplier: float) -> void:
	drink_multiplier = multiplier
	emit_signal("drink_multiplier_changed", drink_multiplier)

func reset_drink_multiplier() -> void:
	drink_multiplier = 1.0
	emit_signal("drink_multiplier_changed", drink_multiplier)

func reset() -> void:
	player_money = 0
	money_changed.emit(player_money)

func _ready() -> void:
	emit_signal("money_changed", player_money)
	emit_signal("tool_changed", active_tool, tool_durability)
	emit_signal("drink_multiplier_changed", drink_multiplier)
