extends Spatial

onready var sprite: Sprite3D = $PartSprite
onready var selectionSprite: Sprite3D = $SelectionSprite
onready var tooltip = $Tooltip

var renderSprite
var partType
var assembly
var delivery
var delivery_index: int;

var dragged: bool = false

signal select_part(part)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = renderSprite
	selectionSprite.visible = false
	var camera_rotation = get_viewport().get_camera().global_transform.basis;
	global_transform.basis = camera_rotation
	self.connect("select_part", assembly, "_on_part_select_event")
	tooltip.visible = false;
	var partInfo = Abilities.classes[partType].new()
	tooltip.setText(partInfo.name, partInfo.description)

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func initialize(sprite, partType, assembly, delivery, delivery_index: int):
	self.renderSprite = sprite
	self.partType = partType
	self.assembly = assembly
	self.delivery = delivery
	self.delivery_index = delivery_index

func onSelect():
	selectionSprite.visible = true

func onDeselect():
	selectionSprite.visible = false

#Stuff to do when added to ghoul.
func onAdd():
	self.delivery.on_part_used(delivery_index)
	self.queue_free()

func _on_DragDetector_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("select_part", self)

func _on_DragDetector_mouse_entered():
	tooltip.visible = true

func _on_DragDetector_mouse_exited():
	tooltip.visible = false
