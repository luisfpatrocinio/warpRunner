extends Node2D
class_name Game

## Objeto responsável por controlar a lógica do jogo.

## Posições das Lanes
var lanesPosY = [80, 160, 240];

## Pasta de Levels criados
@onready var levelPiecesNode : Node2D = get_node("LevelPieces");

## Referência do pedaço de level a ser criado.
@export var levelPieceScenes : Array[PackedScene] = [];

## Velocidade em que os objetos se moverão dentro do jogo.
@export var gameSpeed : float = 1.0;

## Referência da Scene do Player
@onready var playerScene : PackedScene = preload("res://player/player.tscn");


func _ready():
	createFirstLevelPieces();
	spawnPlayer();

func _process(delta):
	tryToCreatePieces();
	

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
	_piece.global_position = Vector2(posx, 0);
	
	# Adiciona o node instanciado como filho de Game.
	levelPiecesNode.add_child(_piece);


func tryToCreatePieces():
	# Obter o último level criado:
	var _qntLevels = levelPiecesNode.get_child_count();
	if _qntLevels > 0:
		var _lastLevel = levelPiecesNode.get_child(_qntLevels - 1) as LevelPiece;
		if _lastLevel.endPoint.global_position.x < get_viewport_rect().size.x:
			createLevelPiece();

func spawnPlayer():
	var _player = playerScene.instantiate();
	# Define sua posição para a ponta esquerda, e lane do meio.
	_player.global_position = Vector2(64, lanesPosY[1]);
	# Adiciona o node instanciado como filho de Level
	add_child(_player);
