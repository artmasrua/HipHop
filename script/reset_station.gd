extends Area2D

var player_in_range := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if event.is_action_pressed("interact") and player_in_range:
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.has_method("clear_elements"):
			player.clear_elements()
			# Feedback opcional:
			if has_node("InteractHint"):
				$InteractHint.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		if has_node("InteractHint"):
			$InteractHint.visible = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		if has_node("InteractHint"):
			$InteractHint.visible = false
