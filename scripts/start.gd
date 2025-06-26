extends Node2D

func _ready():
	$"Items/Drone/Drone Animation".play("move_to_right")

func _on_start_button_pressed():
	var game_scene = load("res://scenes/Game.tscn")
	get_tree().change_scene_to_packed(game_scene)
	
