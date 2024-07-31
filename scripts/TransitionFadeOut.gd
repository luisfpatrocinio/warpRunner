extends CanvasLayer

@onready var rect: ColorRect = get_node("ColorRect");
var progress: float = 1.0;

func _ready():
	visible = true;

func _process(delta):
	progress = move_toward(progress, 0.0, 0.069 / 4);
	rect.color.a = progress;

	if progress <= 0.0:
		queue_free();
