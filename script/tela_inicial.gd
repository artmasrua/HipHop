extends Sprite2D

signal jogar_pressed
signal sair_pressed

func _on_button_pressed():
	jogar_pressed.emit()

func _on_button_2_pressed():
	sair_pressed.emit()
