extends Sprite2D

signal reiniciar_pressed
signal sair_pressed

func _on_button_pressed():
	reiniciar_pressed.emit()

func _on_button_2_pressed():
	sair_pressed.emit()
