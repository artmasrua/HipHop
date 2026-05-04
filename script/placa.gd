extends Node2D

@export var message := "Conjunto X = {x ∈ X | x/2 = 0}"
@onready var area := $Area2D
@onready var label := $Label

var player_in_range := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	label.visible = false
	label.text = message
	print("Placa pronta. Mensagem: ", message)

func _on_body_entered(body):
	print("Corpo entrou na área da placa: ", body.name)
	if body.is_in_group("Player"):
		player_in_range = true
		print("É o jogador!")
	else:
		print("Não é o jogador.")

func _on_body_exited(body):
	print("Corpo saiu: ", body.name)
	if body.is_in_group("Player"):
		player_in_range = false
		label.visible = false
		print("Jogador saiu, label escondido.")

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_in_range:
		label.visible = not label.visible
		print("Label visível agora: ", label.visible)
