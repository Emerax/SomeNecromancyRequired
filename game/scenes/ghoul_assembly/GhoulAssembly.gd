extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parts: Array = [
	"ARM_DRAKE",
	"ARM_SCORPION",
	"ARM_TROLL",
	"BODY_DRAKE",
	"BODY_HORSE",
	"BODY_SCORPION",
	"BODY_TROLL",
	"HEAD_DRAKE",
	"HEAD_HORSE",
	"HEAD_SCORPION",
	"HEAD_TROLL",
	"LEG_DRAKE",
	"LEG_HORSE",
	"LEG_SCORPION",
	"LEG_TROLL"
]

onready var packedPartScenes = {
	"ARM_DRAKE": preload("res://scenes/ghoul-parts/ArmDrake.tscn"),
	"ARM_SCORPION":preload("res://scenes/ghoul-parts/ArmScorpion.tscn"),
	"ARM_TROLL": preload("res://scenes/ghoul-parts/ArmTroll.tscn"),
	"BODY_DRAKE": preload("res://scenes/ghoul-parts/BodyDrake.tscn"),
	"BODY_HORSE": preload("res://scenes/ghoul-parts/BodyHorse.tscn"),
	"BODY_SCORPION": preload("res://scenes/ghoul-parts/BodyScorpion.tscn"),
	"BODY_TROLL": preload("res://scenes/ghoul-parts/BodyTroll.tscn"),
	"HEAD_DRAKE": preload("res://scenes/ghoul-parts/HeadDrake.tscn"),
	"HEAD_HORSE": preload("res://scenes/ghoul-parts/HeadHorse.tscn"),
	"HEAD_SCORPION": preload("res://scenes/ghoul-parts/HeadScorpion.tscn"),
	"HEAD_TROLL": preload("res://scenes/ghoul-parts/HeadTroll.tscn"),
	"LEG_DRAKE": preload("res://scenes/ghoul-parts/LegDrake.tscn"),
	"LEG_HORSE": preload("res://scenes/ghoul-parts/LegHorse.tscn"),
	"LEG_SCORPION": preload("res://scenes/ghoul-parts/LegScorpion.tscn"),
	"LEG_TROLL": preload("res://scenes/ghoul-parts/LegTroll.tscn")
}

var ghoul_in_progress

# Called when the node enters the scene tree for the first time.
func _ready():
	try_add_part("LEG_DRAKE")
	try_add_part("BODY_TROLL")
	try_add_part("HEAD_HORSE")
	try_add_part("LEG_SCORPION")
	try_add_part("ARM_DRAKE")

func try_add_part(part_name):
	assert(packedPartScenes.has(part_name))
	var part = packedPartScenes[part_name].instance()
	
	if "BODY" in part_name:
		if ghoul_in_progress == null:
			ghoul_in_progress = part
			ghoul_in_progress.global_transform.basis = ghoul_in_progress.global_transform.basis.rotated(Vector3.UP, -0.5*PI)
			add_child(ghoul_in_progress)
			return true
	elif ghoul_in_progress != null:
		if "ARM" in part_name:
			return ghoul_in_progress.try_add_arms(part)
		elif "HEAD" in part_name:
			return ghoul_in_progress.try_add_head(part)
		elif "LEG" in part_name:
			return ghoul_in_progress.try_add_legs(part)
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AssemblyArea_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("mouse_input", event)
