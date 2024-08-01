extends Control
var pressedStart = false;
@onready var gameLogo = get_node("GameLogo");
var teleportTimer: float = 0.40;
var teleportCount: int = 0;
var animationFinished: bool = false;
var startTween : Tween = null;


func _ready():
	#Global.resetValues();
	#Global.playBGM("title");
	
	startTween = get_tree().create_tween();
	startTween.tween_property(gameLogo, "position", Vector2(-2400, 270), 3.0);
	await startTween.finished;
	
	get_tree().create_tween().tween_property($Vignette, "modulate", Color(1, 1, 1, 0.50), 1.0);
	
	gameLogo.position = Vector2(960.0/2.0, 96.0);
	gameLogo.scale = Vector2(1, 1);
	$Flash.color.a = 1.0
	animationFinished = true;


func _process(delta):
	$Flash.color.a = lerp($Flash.color.a, 0.0, 0.069);
	$Labels.visible = animationFinished;
	if Input.is_action_just_pressed("ui_accept"):
		if animationFinished:
			if !pressedStart:
				pressedStart = true;
				$PressStartTimer.wait_time = 0.10;
				$StartTimer.start();
				Global.playSFX("warp")
		else:
			startTween.stop()
			gameLogo.position = Vector2(960.0/2.0, 96.0);
			gameLogo.scale = Vector2(1, 1);
			$Flash.color.a = 1.0
			get_tree().create_tween().tween_property($Vignette, "modulate", Color(1, 1, 1, 0.50), 1.0);
			animationFinished = true;
	
	if Global.userdata.get("highScore", 0) > 0:
		$Labels/ScoreLabel.visible = true;
		$Labels/ScoreLabel.text = "High Score: " + str(Global.userdata.get("highScore", 0));
	else:
		$Labels/ScoreLabel.visible = false;


func _on_press_start_timer_timeout():
	$Labels/PressStartLabel.visible = !$Labels/PressStartLabel.visible;


func _on_start_timer_timeout():
	Global.transitionToScene("game");


func _on_logo_teleport_timer_timeout():
	teleportCount += 1;
	teleportTimer -= 0.025;
	if teleportCount >= 10:
		$LogoTeleportTimer.stop();
		$GameLogo.position = Vector2(960/2, 96);
	else:
		var _x = randf_range(0, 960)
		var _y = randf_range(0, 540)
		$GameLogo.position = Vector2(_x, _y);
		$LogoTeleportTimer.wait_time = teleportTimer;
