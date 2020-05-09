extends Spatial

onready var sprite = $PartSprite

var part

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var cameraPos: Vector3 = get_viewport().get_camera().get_global_transform().origin
	sprite.look_at(cameraPos, Vector3(0, 1, 0))

func initialize(part):
	self.part = part


func _on_SpriteCollisionArea_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button clicked!")
