extends CanvasLayer

@onready var close_button = $"Panel/Close Button"
	
func _ready():
	# 确保按钮连接成功
	close_button.pressed.connect(_on_close_pressed)
	
func _on_close_pressed():
	hide()
	get_tree().paused = false  # 恢复游戏
