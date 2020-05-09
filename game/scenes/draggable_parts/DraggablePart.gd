extends Spatial

onready var sprite: Sprite3D = $PartSprite

var renderSprite
var partType
var assembly

var dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = renderSprite
	var camera_rotation = get_viewport().get_camera().global_transform.basis;
	global_transform.basis = camera_rotation
	assembly.connect("mouse_input", self, "_on_Assembly_mouse_input_event")

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func initialize(sprite, partType, assembly):
	self.renderSprite = sprite
	self.partType = partType
	self.assembly = assembly

func _on_DragDetector_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button clicked!")

func _on_Assembly_mouse_input_event(_event: InputEventMouseButton):
	print("Does it work though?")
