extends CanvasLayer

@onready var label := $ElementsLabel

func _ready():
	add_to_group("HUD")
	update_elements([])

func update_elements(elements: Array) -> void:
	var text := ""
	for elem in elements:
		var color_tag := "white"
		match elem:
			"A": color_tag = "red"
			"B": color_tag = "blue"
			"C": color_tag = "green"
			"D": color_tag = "yellow"
			_:   color_tag = "white"
		text += "[color=" + color_tag + "]" + elem + "[/color]  "
	label.text = text
