extends Area2D

@export var element_value := "A":
	set(value):
		element_value = value
		if is_inside_tree():
			update_appearance()

# Se true, o item NÃO some quando coletado (fica no cenário para ser reutilizado)
@export var persistent := false

var player_in_range := false
var current_player: Node2D = null

@onready var sprite := $Sprite2D
@onready var label := $Label

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	update_appearance()

func update_appearance():
	var color := Color.WHITE
	match element_value:
		"A": color = Color.RED
		"B": color = Color.BLUE
		"C": color = Color.GREEN
		"D": color = Color.YELLOW
		_:   color = Color.WHITE
	sprite.modulate = color
	if label:
		label.text = element_value
		# Você posiciona manualmente no editor – sem centralização automática

func _on_body_entered(body):
	if body.has_method("add_element"):
		player_in_range = true
		current_player = body
		if has_node("InteractHint"):
			$InteractHint.visible = true

func _on_body_exited(body):
	if body == current_player:
		player_in_range = false
		current_player = null
		if has_node("InteractHint"):
			$InteractHint.visible = false

func collect():
	if current_player and current_player.has_method("add_element"):
		current_player.add_element(element_value)
		if not persistent:
			queue_free()
		else:
			# Se persistente, podemos dar um pequeno feedback (ex: piscar)
			if has_node("InteractHint"):
				$InteractHint.visible = false  # Esconde a dica momentaneamente
