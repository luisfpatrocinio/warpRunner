extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	Global.playerScore += 50;
	$anim.play("collect")
	


func _on_anim_animation_finished():
	queue_free()
