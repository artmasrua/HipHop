extends Node2D

@export var required_element := "A":
	set(value):
		required_element = value
		if is_inside_tree():
			update_appearance()

@onready var sprite := $Sprite2D
@onready var blocker := $Blocker
@onready var sensor := $Sensor
@onready var label := $Label   # <-- referência ao nó Label

func _ready():
	sensor.body_entered.connect(_on_sensor_body_entered)
	sensor.body_exited.connect(_on_sensor_body_exited)
	update_appearance()

func update_appearance():
	# Cor do sprite conforme o elemento
	var color = Color.WHITE
	match required_element:
		"A": color = Color.RED
		"B": color = Color.BLUE
		"C": color = Color.GREEN
		"D": color = Color.YELLOW
	sprite.modulate = color
	sprite.modulate.a = 1.0   # opacidade total (reset)
	
	# Atualiza o texto da label (apenas texto, sem mexer na posição)
	if label:
		label.text = required_element
		# Não centralizamos automaticamente; posição manual no editor

func _on_sensor_body_entered(body):
	if body.has_method("has_element") and body.has_element(required_element):
		# Desliga o bloqueador
		blocker.set_collision_layer_value(2, false)
		blocker.set_collision_mask_value(1, false)
		sprite.modulate.a = 0.5   # transparente
		# Se quiser, também pode esconder a label ou mantê-la

func _on_sensor_body_exited(body):
	# Reativa o bloqueador
	blocker.set_collision_layer_value(2, true)
	blocker.set_collision_mask_value(1, true)
	sprite.modulate.a = 1.0
