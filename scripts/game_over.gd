extends CanvasLayer

@onready var play_again_button = $"Panel/Play Again Button"

func _ready():
	layer = 3
	
	if play_again_button:
		print("Play Again button debug info:")
		print("- Disabled:", play_again_button.disabled)
		print("- Visible:", play_again_button.visible)
		print("- Mouse Filter:", play_again_button.mouse_filter)
		
		play_again_button.pressed.connect(_on_play_again_pressed)
		
		play_again_button.disabled = false
		play_again_button.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		printerr("Error: Play Again button not found at path: Panel/Play Again Button")

func _on_play_again_pressed():
	print("Play Again button pressed!")
	
	visible = false
	get_tree().paused = false
	
	GameState.reset_game.emit()
	
	var start_scene = load("res://scenes/Start.tscn")
	get_tree().change_scene_to_packed(start_scene)
