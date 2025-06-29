extends Node2D

var label: Label
var timer: Timer

func _ready() -> void:
	# Create label
	label = Label.new()
	label.add_font_override("font", load("res://assets/font/DeliusUnicase-Regular.ttf"))
	label.set("custom_colors/font_color", Color(0.192157, 0.192157, 0.192157, 1))
	label.set("custom_constants/font_size", 20)
	add_child(label)
	
	# Create timer for disappearance
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func set_text(text: String) -> void:
	label.text = text

func _on_timer_timeout() -> void:
	queue_free()
