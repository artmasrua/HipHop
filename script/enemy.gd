extends CharacterBody2D

@export var weakness := "A"     # Elemento que derrota o inimigo
@export var speed := 100.0
@export var damage := 1

var direction := 1              # 1 = direita, -1 = esquerda
var gravity = 980.0             # Pode usar gravidade se quiser que caia

@onready var sprite := $Sprite2D
@onready var hitbox := $Hitbox
@onready var label := $Label
@onready var collision_body := $CollisionShape2D

func _ready():
	# Conecta o sinal de detecção do jogador
	hitbox.body_entered.connect(_on_player_entered)
	update_appearance()

func _physics_process(delta):
	# Movimento simples: patrulha horizontal (não usa gravidade, fica flutuando)
	velocity.x = direction * speed
	
	# Se quiser que o inimigo caia e ande no chão, descomente:
	 if not is_on_floor():
		 velocity.y += gravity * delta
	 else:
		 velocity.y = 0
	
	move_and_slide()
	
	# Muda de direção ao bater em uma parede
	if is_on_wall():
		direction *= -1
		sprite.flip_h = direction < 0

func update_appearance():
	# Cor e letra conforme a fraqueza
	var color = Color.WHITE
	match weakness:
		"A": color = Color.RED
		"B": color = Color.BLUE
		"C": color = Color.GREEN
		"D": color = Color.YELLOW
	sprite.modulate = color
	
	if label:
		label.text = weakness
		# Centraliza a letra
		label.reset_size()
		label.position = -label.size * 0.5

func _on_player_entered(body):
	# Detecta o jogador
	if body.has_method("has_element") and body.has_element(weakness):
		# Jogador possui o elemento → inimigo morre
		die()
	else:
		# Jogador não tem o elemento → causa dano
		if body.has_method("take_damage"):
			body.take_damage(damage)

func die():
	# Aqui você pode tocar uma animação de morte, por enquanto removemos
	queue_free()
