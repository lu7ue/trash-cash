extends CanvasLayer

@onready var play_again_button = $"Panel/Play Again Button"

func _ready():
	layer = 3  # 保持与实例化时一致
	
	if play_again_button:
		print("Play Again button debug info:")
		print("- Disabled:", play_again_button.disabled)
		print("- Visible:", play_again_button.visible)
		print("- Mouse Filter:", play_again_button.mouse_filter)
		
		# 关键修复：添加信号连接
		play_again_button.pressed.connect(_on_play_again_pressed)
		
		# 确保按钮可交互
		play_again_button.disabled = false
		play_again_button.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		printerr("Error: Play Again button not found at path: Panel/Play Again Button")

func _on_play_again_pressed():
	print("Play Again button pressed!")  # 确认是否执行到这里
	
	visible = false  # 使用visible而不是hide()确保完全隐藏
	get_tree().paused = false
	
	# 重置游戏状态
	GameState.reset_game.emit()
	
	# 加载开始场景 - 使用change_scene_to_packed更可靠
	var start_scene = load("res://scenes/Start.tscn")
	get_tree().change_scene_to_packed(start_scene)
