extends Area2D

@onready var blocker := $Blocker
var already_triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if already_triggered:
		return
	if body.is_in_group("Player"):
		already_triggered = true
		
		# 1. Limpa todos os elementos do jogador
		if body.has_method("clear_elements"):
			body.clear_elements()
			print("Inventário limpo pela transição de sala.")
		
		# 2. Bloqueia o caminho de volta (ativa a barreira)
		blocker.visible = true
		blocker.set_collision_layer_value(2, true)
		blocker.set_collision_mask_value(1, true)
		# ou simplesmente: blocker.get_node("CollisionShape2D").disabled = false
