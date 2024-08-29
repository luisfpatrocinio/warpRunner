extends Node2D

@onready var endPoint = get_node("EndPoint");

func _process(delta):
	movePiece();
	destroyIfOutside();

## Move o pedaço de level atual.
func movePiece():
	var _speed = get_parent().get_parent().gameSpeed;
	global_position.x -= _speed;
	
## Função responsável por destruir o objeto caso ele saia da tela pela esquerda.
func destroyIfOutside():
	if endPoint.global_position.x < 0:
		queue_free();
