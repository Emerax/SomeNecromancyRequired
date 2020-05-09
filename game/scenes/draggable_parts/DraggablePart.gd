extends Spatial

onready var sprite: Sprite3D = $PartSprite
onready var selectionSprite: Sprite3D = $SelectionSprite

var renderSprite
var partType
var assembly

var dragged: bool = false

signal select_part(part)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = renderSprite
	selectionSprite.visible = false
	var camera_rotation = get_viewport().get_camera().global_transform.basis;
	global_transform.basis = camera_rotation
	self.connect("select_part", assembly, "_on_part_select_event")

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func initialize(sprite, partType, assembly):
	self.renderSprite = sprite
	self.partType = partType
	self.assembly = assembly

func onSelect():
	selectionSprite.visible = true

func onDeselect():
	selectionSprite.visible = false

#Stuff to do when added to ghoul.
func onAdd():
	self.queue_free()

func _on_DragDetector_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("select_part", self)
