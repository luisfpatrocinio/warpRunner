extends Node2D

var fading := false;
var appearingProgress: float = 0.0;
@onready var playerScene : PackedScene = preload("res://scenes/player.tscn");

func _process(delta):
	appearingProgress = 1.0 - float(fading);		
	#modulate.a = appearingProgress;	
	
	$Back.emitting = !fading;
	$Front.emitting = !fading;

func _on_timer_timeout():
	var _player = playerScene.instantiate();
	_player.global_position = Vector2(64, get_parent().lanesPosY[1]);
	get_parent().add_child(_player);
	fading = true;
	
	$DestroyTimer.start();


func _on_destroy_timer_timeout():
	get_parent().showingInstructions = true;
	queue_free();
