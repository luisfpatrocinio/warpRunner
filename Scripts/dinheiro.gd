extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print ('o player roubou')
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
