extends Area2D

@onready var blocker := $Blocker
@onready var timer := $Timer
var already_triggered := false

func _ready():
	body_entered.connect(_on_body_entered)
	# Garante que o bloqueador comece desativado
	blocker.visible = false
	blocker.set_collision_layer_value(2, false)
	blocker.set_collision_mask_value(1, false)
	if blocker.has_node("CollisionShape2D"):
		blocker.get_node("CollisionShape2D").disabled = true

func _on_body_entered(body):
	if already_triggered: return
	if body.is_in_group("Player"):
		already_triggered = true
		# Limpa elementos
		if body.has_method("clear_elements"):
			body.clear_elements()
		# Aguarda 0.1 s e ativa o bloqueador
		timer.start(0.1)

func _on_timer_timeout():
	blocker.visible = true
	blocker.set_collision_layer_value(2, true)
	blocker.set_collision_mask_value(1, true)
	if blocker.has_node("CollisionShape2D"):
		blocker.get_node("CollisionShape2D").disabled = false
	print("Blocker ativado após delay.")
