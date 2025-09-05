extends Node

signal money_changed(new_amount: int)
signal reset_game

@export var player_money: int = 0:
	set(value):
		player_money = value
		money_changed.emit(player_money)
	get:
		return player_money

func add_money(amount: int) -> void:
	player_money += amount

func remove_money(amount: int) -> void:
	player_money -= amount

func reset() -> void:
	player_money = 0
	money_changed.emit(player_money)

func _ready() -> void:
	money_changed.emit(player_money)
