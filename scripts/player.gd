extends Area2D
class_name Player

var actualHeight = 1;
var teleporting : bool = false;
var appearingProgress :  float = 0.0;
var mixRatio: float = 1.0;

@onready var teleportTimer : Timer = get_node("TeleportTimer");

@onready var myAnim : AnimatedSprite2D = get_node("AnimatedSprite2D");

func _process(delta):
	appearingProgress = move_toward(appearingProgress, 1.0, 0.069);
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and !teleporting and get_parent().gameStarted:
		actualHeight -= 1;		
		actualHeight = wrap(actualHeight, 0, 3);
		teleporting = true;
		teleportTimer.start()
		Global.playSFX("warp");
	
	if teleporting:
		global_position.y -= 1;
		modulate.a -= 0.05;
		
	manageWarpEffect();
	manageAnimation();
		

func die():
	get_parent().gameOver = true;
	if Global.playerScore > Global.highScore:
		Global.userdata["highScore"] = Global.playerScore;
		Global.newHighScore = true;
		Global.save_game();
		
	queue_free();

## Fim do tempo de teleporte.
func _on_teleport_timer_timeout():
	global_position.y = get_parent().lanesPosY[actualHeight];
	modulate.a = 1.0;
	teleporting = false;

func manageWarpEffect():
	myAnim.material.set("shader_parameter/current_frame", Time.get_ticks_msec() / 100.0)	
	myAnim.material.set("shader_parameter/mix_ratio", mixRatio);
	if teleporting or appearingProgress < 1.0:
		mixRatio = 1.0;
	else:
		mixRatio = move_toward(mixRatio, 0.0, 0.069);

func manageAnimation():
	myAnim.speed_scale = Global.levelRef.gameSpeed;
