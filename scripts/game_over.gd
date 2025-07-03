extends CanvasLayer

@onready var play_again_button = $"Panel/Play Again Button"

func _ready():
	if play_again_button:
		print("Play Again button found:", play_again_button)
		print("Play Again button disabled:", play_again_button.disabled)
		print("Play Again button mouse filter:", play_again_button.mouse_filter)
		print("Play Again button signal connected:", play_again_button.pressed.get_connections())
	else:
		print("Error: Play Again button not found at path 'Panel/Play Again Button'")

func _on_play_again_pressed():
	if not visible: return
	print("Play Again button pressed!")
	hide()
	get_tree().paused = false
	GameState.reset_game.emit()
	var scene_path = "res://scenes/Start.tscn"  # 替换为实际路径
	if ResourceLoader.exists(scene_path):
		print("Loading Start scene:", scene_path)
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Error: Start scene not found at", scene_path)


func _on_play_again_button_pressed() -> void:
	pass # Replace with function body.
