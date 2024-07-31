extends Node2D

## Objeto responsável por controlar a lógica do jogo.

## Posições das Lanes
var lanesPosY = [80, 160, 240];

## Pasta de Levels criados
@onready var levelPiecesNode : Node2D = get_node("LevelPieces");

## Referência do pedaço de level a ser criado.
@export var levelPieceScenes : Array[PackedScene] = [
	preload("res://scenes/Level Pieces/levelPiece1.tscn"),
	preload("res://scenes/Level Pieces/levelPiece2.tscn"),
	preload("res://scenes/Level Pieces/levelPiece3.tscn"),
	preload("res://scenes/Level Pieces/levelPiece4.tscn"),
	preload("res://scenes/Level Pieces/levelPiece5.tscn"),
	preload("res://scenes/Level Pieces/levelPiece6.tscn"),
	preload("res://scenes/Level Pieces/levelPiece7.tscn"),
	preload("res://scenes/Level Pieces/levelPiece8.tscn"),
	preload("res://scenes/Level Pieces/levelPiece9.tscn"),
];

var gameStarted : bool = false;

## Velocidade em que os objetos se moverão dentro do jogo.
@export var gameSpeed : float = 0.0;

## Referência da Scene do Player
@onready var playerSpawn : PackedScene = preload("res://scenes/player_spawn.tscn");

@onready var parallaxBackground : ParallaxBackground = get_node("ParallaxBackground");

@onready var interfaceNode: CanvasLayer = get_node("Interface");
@onready var flashAmount : float = 0.0;

var traveledDistance: float = 0.0;
var showingInstructions: bool = false;

var gameOver : bool = false;


func _ready():
	# Instruções começam invisíveis.
	interfaceNode.get_node("Instructions").modulate.a = 0.0;
	interfaceNode.get_node("GameOver").modulate.a = 0.0;
	
	Global.playBGM("game");
	Global.levelRef = self;
	createFirstLevelPieces();
	spawnPlayer();
	interfaceNode.get_node("Flash").visible = false;

func _process(delta):
	var _canMove = gameStarted and !gameOver;
	gameSpeed = move_toward(gameSpeed, float(_canMove), 0.069 / 2.0);
	tryToCreatePieces();
	parallaxBackground.scroll_base_offset.x -= gameSpeed;
	manageFlash();
	manageScore();
	manageInstructions();
	manageGameOver();

func manageInstructions():
	var _instructions = interfaceNode.get_node("Instructions") as Control;
	_instructions.modulate.a = move_toward(_instructions.modulate.a, float(showingInstructions), 0.069);
	
	if Input.is_action_just_pressed("ui_accept") and showingInstructions and !gameStarted:
		showingInstructions = false;
		await get_tree().create_timer(0.75).timeout;
		gameStarted = true;

func manageGameOver():
	var _gameOver = interfaceNode.get_node("GameOver") as Control;
	_gameOver.modulate.a = move_toward(_gameOver.modulate.a, float(gameOver), 0.069);
	
	if gameOver:
		# Definir mensagem aleatória de gameover:
		var _msg = [
			"GAME OVER!",
			"YOU DIED!",
			"OH NO! YOU DIED!"
		][0];
		#].pick_random();
		
		var _messageLabel = _gameOver.get_node("GameOverLabel");
		_messageLabel.text = _msg;
		
		
		var _scoreLabel = _gameOver.get_node("ScoreLabel");
		_scoreLabel.text = "Your score: " + str(Global.playerScore);
		
		if Input.is_action_just_pressed("ui_accept"):
			Global.transitionToScene("title");

func startGame():
	gameStarted = true;

func manageScore():
	# Aumentar pontuação caso o jogo não tenha acabado.
	if !gameOver:
		traveledDistance += gameSpeed/10;
	
	# Atualizar texto da pontuação.
	var _scoreLabel = interfaceNode.get_node("ScoreLabel") as Label;
	_scoreLabel.text = str("%0.1f" % [traveledDistance]) + "m";

func manageFlash():
	var _flash = interfaceNode.get_node("Flash") as ColorRect;
	_flash.color.a = flashAmount;
	flashAmount = move_toward(flashAmount, 0.0, 0.069);

## Cria os pedaços de level iniciaisr
func createFirstLevelPieces():
	var _posX = 0;
	while _posX < get_viewport_rect().size.x:
		createLevelPiece(0, _posX);
		_posX += 20 * 16;
	

## Cria um pedaço de level aleatório e instancia na borda direita do mapa.
func createLevelPiece(levelInd = -1, posx = get_viewport_rect().size.x - gameSpeed):
	if levelInd == -1:
		levelInd = randi() % len(levelPieceScenes);
	# Instancia um pedaço de level.
	var _piece = levelPieceScenes[levelInd].instantiate();
	
	# Define sua posição para a borda direita da tela.
	_piece.global_position = Vector2(posx - gameSpeed, 0);
	
	# Adiciona o node instanciado como filho de Game.
	levelPiecesNode.add_child(_piece);


func tryToCreatePieces():
	# Obter o último level criado:
	var _qntLevels = levelPiecesNode.get_child_count();
	if _qntLevels > 0:
		var _lastLevel = levelPiecesNode.get_child(_qntLevels - 1);
		if _lastLevel.endPoint.global_position.x < get_viewport_rect().size.x:
			createLevelPiece();

func spawnPlayer():
	var _player = playerSpawn.instantiate();
	# Define sua posição para a ponta esquerda, e lane do meio.
	_player.global_position = Vector2(64, lanesPosY[1]);
	# Adiciona o node instanciado como filho de Level
	add_child(_player);
