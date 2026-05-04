extends CharacterBody2D

# Movimento
@export var speed := 300.0
@export var jump_velocity := -400.0
@export var gravity := 980.0

# Elementos
var current_elements := []
const COLOR_ELEMENTS := ["A", "B", "C", "D"]

# Interação
var items_in_range := []

# Referências
@onready var animated_sprite := $AnimatedSprite2D
@onready var interact_area := $InteractArea
@onready var invulnerability_timer := $InvulnerabilityTimer

func _ready():
	add_to_group("Player")
	interact_area.area_entered.connect(_on_interact_area_entered)
	interact_area.area_exited.connect(_on_interact_area_exited)

	if not has_node("InvulnerabilityTimer"):
		var timer = Timer.new()
		timer.name = "InvulnerabilityTimer"
		timer.one_shot = true
		timer.wait_time = 1.5
		timer.timeout.connect(_on_invulnerability_timeout)
		add_child(timer)
		invulnerability_timer = timer

	add_to_group("Player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 10 * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")
	else:
		if direction != 0:
			if animated_sprite.animation != "andando":
				animated_sprite.play("andando")
		else:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")

	move_and_slide()

# Interação
func _input(event):
	if event.is_action_pressed("interact") and items_in_range.size() > 0:
		var item = items_in_range[0]
		if item.has_method("collect"):
			item.collect()

func _on_interact_area_entered(area: Area2D):
	if area.has_method("collect"):
		items_in_range.append(area)
		if area.has_node("InteractHint"):
			area.get_node("InteractHint").visible = true

func _on_interact_area_exited(area: Area2D):
	items_in_range.erase(area)
	if area.has_node("InteractHint"):
		area.get_node("InteractHint").visible = false

# Elementos
func _is_color_element(element: String) -> bool:
	return element in COLOR_ELEMENTS

func add_element(element_name: String) -> void:
	if _is_color_element(element_name):
		# Remove cores anteriores e adiciona a nova
		for color in COLOR_ELEMENTS:
			if color in current_elements:
				current_elements.erase(color)
		current_elements.append(element_name)
		print("Cor coletada: ", element_name, " -> ", current_elements)
	else:
		# Números etc.
		if element_name not in current_elements:
			current_elements.append(element_name)
			print("Número coletado: ", element_name, " -> ", current_elements)
		else:
			print("Elemento já existe: ", element_name)

	update_visual()
	_notify_hud()

func remove_element(element_name: String) -> void:
	if element_name in current_elements:
		current_elements.erase(element_name)
	update_visual()
	_notify_hud()

func has_element(element_name: String) -> bool:
	return element_name in current_elements

func update_visual() -> void:
	var color := Color.WHITE
	for elem in current_elements:
		if _is_color_element(elem):
			match elem:
				"A": color = Color.RED
				"B": color = Color.BLUE
				"C": color = Color.GREEN
				"D": color = Color.YELLOW
			break
	animated_sprite.modulate = color
	animated_sprite.modulate.a = 1.0   # opacidade total (dano restaura)

func _notify_hud() -> void:
	var hud = get_tree().get_first_node_in_group("HUD")
	if hud and hud.has_method("update_elements"):
		hud.update_elements(current_elements)
# Dano (opcional)
@export var max_health := 3
var health := max_health
var invulnerable := false

func take_damage(amount: int) -> void:
	if invulnerable:
		return
	health -= amount
	invulnerable = true
	animated_sprite.modulate.a = 0.5
	invulnerability_timer.start()
	if health <= 0:
		die()

func _on_invulnerability_timeout() -> void:
	invulnerable = false
	animated_sprite.modulate.a = 1.0

func die() -> void:
	get_tree().reload_current_scene()

func clear_elements() -> void:
	current_elements.clear()
	update_visual()
	_notify_hud()
	print("Inventário limpo!")
