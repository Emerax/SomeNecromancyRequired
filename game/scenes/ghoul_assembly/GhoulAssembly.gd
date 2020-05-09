extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parts: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("HELLO I AM ASSEMBLY")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AssemblyArea_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("mouse_input", event)
