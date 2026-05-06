extends Node2D

@export var tela_inicial : Sprite2D
@export var tela_morte : Sprite2D
@export var tela_final : Sprite2D

@onready var player := $Player
@export var death_y_threshold := 700.0   # Aumente para um valor seguro (ex: 700)

var jogo_pausado := true

func _ready():
	# Conexões
	if tela_inicial:
		tela_inicial.jogar_pressed.connect(_on_jogar)
		tela_inicial.sair_pressed.connect(_on_sair)
	if tela_morte:
		tela_morte.reiniciar_pressed.connect(_on_reiniciar)
		tela_morte.sair_pressed.connect(_on_sair)
	if tela_final:
		tela_final.reiniciar_pressed.connect(_on_reiniciar)
		tela_final.sair_pressed.connect(_on_sair)

	if not GameState.jogo_iniciado:
		# Primeira execução: mostrar tela inicial
		if tela_inicial: tela_inicial.visible = true
		if tela_morte: tela_morte.visible = false
		if tela_final: tela_final.visible = false
		jogo_pausado = true
	else:
		# Reinício: pular tela inicial e iniciar jogo automaticamente
		if tela_inicial: tela_inicial.visible = false
		if tela_morte: tela_morte.visible = false
		if tela_final: tela_final.visible = false
		jogo_pausado = false
		# Pequeno atraso para evitar morte instantânea no recarregamento
		await get_tree().create_timer(0.2).timeout

	if has_node("FinalArea"):
		$FinalArea.body_entered.connect(_on_final_area_entered)

func _process(_delta):
	if not jogo_pausado and player:
		if player.global_position.y > death_y_threshold:
			_player_died()

func _on_jogar():
	if tela_inicial:
		tela_inicial.visible = false
	GameState.jogo_iniciado = true
	jogo_pausado = false
	# Pequeno delay para estabilizar
	await get_tree().create_timer(0.2).timeout

func _player_died():
	jogo_pausado = true
	if tela_morte:
		tela_morte.visible = true

func _on_reiniciar():
	# Mantém que o jogo já foi iniciado
	GameState.jogo_iniciado = true
	# Recarrega a cena (a Main será recriada)
	get_tree().reload_current_scene()

func _on_sair():
	GameState.jogo_iniciado = false
	get_tree().quit()

func _on_final_area_entered(body):
	if body.is_in_group("Player"):
		jogo_pausado = true
		if tela_final:
			tela_final.visible = true
