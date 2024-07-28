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

## Velocidade em que os objetos se moverão dentro do jogo.
@export var gameSpeed : float = 0.0;

## Referência da Scene do Player
@onready var playerSpawn : PackedScene = preload("res://scenes/player_spawn.tscn");

@onready var parallaxBackground : ParallaxBackground = get_node("ParallaxBackground");

@onready var interfaceNode: CanvasLayer = get_node("Interface");
@onready var flashAmount : float = 0.0;

var traveledDistance: float = 0.0;

func _ready():
	Global.playBGM("game");
	Global.levelRef = self;
	createFirstLevelPieces();
	spawnPlayer();
	interfaceNode.get_node("Flash").visible = false;

func _process(delta):
	tryToCreatePieces();
	parallaxBackground.scroll_base_offset.x -= gameSpeed;
	manageFlash();
	manageScore();

func manageScore():
	traveledDistance += gameSpeed/10;
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
