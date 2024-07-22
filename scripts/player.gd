extends Area2D
class_name Player 

var actualHeight = 1;
var teleporting : bool = false;

@onready var teleportTimer : Timer = get_node("TeleportTimer");

func _process(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and !teleporting:
		actualHeight -= 1;		
		actualHeight = wrap(actualHeight, 0, 3);
		teleporting = true;
		teleportTimer.start()
	
	if teleporting:
		global_position.y -= 1;
		modulate.a -= 0.05;

## Fim do tempo de teleporte.
func _on_teleport_timer_timeout():
	global_position.y = get_parent().lanesPosY[actualHeight];
	modulate.a = 1.0;
	teleporting = false;
