extends Node2D

var label: Label
var timer: Timer

func _ready() -> void:
	set_z_index(100)
	# Create text label
	label = Label.new()
	label.text = ""
	label.add_theme_font_override("font", load("res://assets/font/ComicRelief-Regular.ttf"))
	label.set("theme_override_colors/font_color", Color.BLACK)
	label.set("theme_override_font_sizes/font_size", 20)
	label.position = Vector2(-20, -50)

	add_child(label)
	
	# Create timer
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()


func set_text(text: String) -> void:
	await ready
	if label:
		label.text = text
