extends CanvasLayer

@onready var close_button = $"Panel/Close Button"

func _ready():
	if close_button:
		print("Close button found:", close_button)
		close_button.pressed.connect(_on_close_pressed)
	else:
		print("Error: Close button not found at path 'Panel/Close Button'")

func _on_close_pressed():
	print("Close button pressed! Hiding Info scene...")
	hide()
	print("Info scene visible after hide:", visible)
	get_tree().paused = false
