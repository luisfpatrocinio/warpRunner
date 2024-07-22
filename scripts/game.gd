extends Node2D
class_name Game

## Objeto responsável por controlar a lógica do jogo.

## Pasta de Levels criados
@onready var levelPiecesNode : Node2D = get_node("LevelPieces");

## Referência do pedaço de level a ser criado.
@onready var levelPieceScene : PackedScene = preload("res://scenes/levelPiece.tscn");

## Velocidade em que os objetos se moverão dentro do jogo.
@export var gameSpeed : float = 1.0;


func _ready():
	createFirstLevelPieces();

func _process(delta):
	# Obter o último level criado:
	var _qntLevels = levelPiecesNode.get_child_count();
	if _qntLevels > 0:
		var _lastLevel = levelPiecesNode.get_child(_qntLevels - 1) as LevelPiece;
		if _lastLevel.endPoint.global_position.x < get_viewport_rect().size.x:
			createRandomLevelPiece();
	

## Cria os pedaços de level iniciaisr
func createFirstLevelPieces():
	var _posX = 0;
	while _posX < get_viewport_rect().size.x:
		createRandomLevelPiece(_posX);
		_posX += 20 * 16;
	

## Cria um pedaço de level aleatório e instancia na borda direita do mapa.
func createRandomLevelPiece(posx = get_viewport_rect().size.x - gameSpeed):
	# Instancia um pedaço de level.
	var _piece = levelPieceScene.instantiate();
	
	# Define sua posição para a borda direita da tela.
	_piece.global_position = Vector2(posx, 0);
	
	# Adiciona o node instanciado como filho de Game.
	levelPiecesNode.add_child(_piece);
