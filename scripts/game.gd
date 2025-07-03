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
	
	# 实例化 Info 场景并加为子节点
	info_instance = InfoScene.instantiate()
	info_instance.visible = false       # 默认隐藏
	add_child(info_instance)

	# 连接 info 按钮
	info_button.pressed.connect(_on_info_pressed)

func _on_money_changed(amount: int) -> void:
	money_label.text = "$ " + str(amount)
	
	
@onready var info_button = $"Tool Bar/Info/Info Button"  # 替换为你实际的按钮路径
var info_instance: CanvasLayer                # 用来引用 Info 场景的实例

const InfoScene := preload("res://scenes/Info.tscn")  # 替换路径为你实际路径

func _on_info_pressed():
	info_instance.visible = true        # 显示 Info 场景
