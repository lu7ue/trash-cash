extends Node

signal money_changed(new_amount: int)

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

func _ready() -> void:
	money_changed.emit(player_money)
