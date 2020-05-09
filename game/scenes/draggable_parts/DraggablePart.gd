extends Spatial

onready var sprite: Sprite3D = $PartSprite

var renderSprite
var partType
var assemblyPath

var dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = renderSprite
	var assembly = get_node(assemblyPath)
	assembly.connect("mouse_input", self, "_on_Assembly_mouse_input_event")

func _process(delta):
	var cameraPos: Vector3 = get_viewport().get_camera().get_global_transform().origin
	sprite.look_at(cameraPos, Vector3(0, 1, 0))

func initialize(sprite, partType, assemblyPath):
	self.renderSprite = sprite
	self.partType = partType
	self.assemblyPath = assemblyPath

func _on_DragDetector_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button clicked!")

func _on_Assembly_mouse_input_event(event: InputEventMouseButton):
	print("Does it work though?")
