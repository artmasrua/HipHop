extends CanvasLayer

func _ready():
	add_to_group("DicasMenu")
	visible = false  # começa escondido

func toggle():
	visible = not visible
