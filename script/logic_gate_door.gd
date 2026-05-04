extends Node2D

# Tipo de condição lógica
@export_enum("union", "intersection", "custom") var condition_type := "union"

# Para union e intersection
@export var element_a := "A"
@export var element_b := "B"

# Para custom
@export var required_elements := []   # Ex: ["1", "3", "5"]
@export var forbidden_elements := []  # Ex: ["C"]

@onready var sprite := $Sprite2D
@onready var blocker := $Blocker
@onready var sensor := $Sensor
@onready var label := $Label

func _ready():
	sensor.body_entered.connect(_on_sensor_body_entered)
	update_appearance()

func update_appearance():
	var color = Color.WHITE
	var text = ""
	
	match condition_type:
		"union":
			text = element_a + " ∪ " + element_b
			color = Color.ORANGE
		"intersection":
			text = element_a + " ∩ " + element_b
			color = Color.PURPLE
		"custom":
			text = "⚙️"
			color = Color.GRAY
	
	sprite.modulate = color
	if label:
		label.text = text
		label.reset_size()
		label.position = -label.size * 0.5  # centraliza

func _on_sensor_body_entered(body):
	if body.has_method("has_element") and evaluate_condition(body):
		open_door()

func evaluate_condition(player) -> bool:
	match condition_type:
		"union":
			return player.has_element(str(element_a)) or player.has_element(str(element_b))
		"intersection":
			return player.has_element(str(element_a)) and player.has_element(str(element_b))
		"custom":
			for elem in required_elements:
				if not player.has_element(str(elem)):
					return false
			for elem in forbidden_elements:
				if player.has_element(str(elem)):
					return false
			return true
	return false

func open_door():
	# Remove o bloqueador e o sensor (porta "abre")
	blocker.queue_free()
	sensor.queue_free()
	# Opcional: animação de abertura, fade, etc.
	sprite.modulate.a = 0.3   # Fica transparente para indicar que está aberta
	if label:
		label.visible = false
