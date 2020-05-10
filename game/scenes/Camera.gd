extends Camera

onready var assembly_transform = get_transform()
export var fight_pos_path: NodePath

var interp_t = 0;

var is_at_fight = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target
	if is_at_fight:
		target = self.get_node(fight_pos_path).get_transform()
	else:
		target = assembly_transform

	if interp_t < 1:
		self.transform = self.transform.interpolate_with(target, interp_t)
	interp_t += delta


func move_to_fight():
	interp_t = 0
	is_at_fight = true

func move_to_assembly():
	interp_t = 0
	is_at_fight = false
