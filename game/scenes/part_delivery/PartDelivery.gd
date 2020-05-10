extends Spatial

export(NodePath) var ghoulAssemblyPath

onready var packedSpriteScenes = {
	"ARM_DRAKE": preload("res://scenes/ghoul-parts/sprites/drake-arm.png"),
	"ARM_SCORPION":preload("res://scenes/ghoul-parts/sprites/scorption-arm.png"),
	"ARM_TROLL": preload("res://scenes/ghoul-parts/sprites/troll-arm.png"),
	"BODY_DRAKE": preload("res://scenes/ghoul-parts/sprites/drake-body.png"),
	"BODY_HORSE": preload("res://scenes/ghoul-parts/sprites/horse-body.png"),
	"BODY_SCORPION": preload("res://scenes/ghoul-parts/sprites/scorption-body.png"),
	"BODY_TROLL": preload("res://scenes/ghoul-parts/sprites/troll-body.png"),
	"HEAD_DRAKE": preload("res://scenes/ghoul-parts/sprites/drake-head.png"),
	"HEAD_HORSE": preload("res://scenes/ghoul-parts/sprites/horse-head.png"),
	"HEAD_SCORPION": preload("res://scenes/ghoul-parts/sprites/scorption-head.png"),
	"HEAD_TROLL": preload("res://scenes/ghoul-parts/sprites/troll-head.png"),
	"LEG_DRAKE": preload("res://scenes/ghoul-parts/sprites/drake-leg.png"),
	"LEG_HORSE": preload("res://scenes/ghoul-parts/sprites/horse-leg.png"),
	"LEG_SCORPION": preload("res://scenes/ghoul-parts/sprites/scorption-leg.png"),
	"LEG_TROLL": preload("res://scenes/ghoul-parts/sprites/troll-leg.png")
}

var arm_types = []
var body_types = []
var head_types = []
var leg_types = []

onready var dropOffs = [
	$Dropoff1,
	$Dropoff2,
	$Dropoff3,
	$Dropoff4,
	$Dropoff5,
	$Dropoff6,
	$Dropoff7,
	$Dropoff8,
	$Dropoff9
]

var parts_to_give: int = 20

var slots = []

onready var packed_part = preload("res://scenes/draggable_parts/DraggablePart.tscn")

onready var rng = RandomNumberGenerator.new()

var first = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	for dropOff in dropOffs:
		slots.append(null)
	rng.randomize()
	for part_name in packedSpriteScenes.keys():
		if "ARM" in part_name:
			arm_types.append(part_name)
		elif "BODY" in part_name:
			body_types.append(part_name)
		elif "HEAD" in part_name:
			head_types.append(part_name)
		elif "LEG" in part_name:
			leg_types.append(part_name)
		else:
			assert(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if first && get_node(ghoulAssemblyPath):
		fillDropOffs()
		first = false

func create_part(partType, index):
	var newPartSprite = packedSpriteScenes[partType]
	var newPart: Spatial = packed_part.instance()
	var ghoulAssembly = get_node(ghoulAssemblyPath)
	newPart.initialize(newPartSprite, partType, ghoulAssembly, self, index)
	get_tree().root.call_deferred("add_child", newPart)
	return newPart

func fillDropOffs():
	var seeded_parts = []
	seeded_parts.append(arm_types[rng.randi() % arm_types.size()])
	seeded_parts.append(body_types[rng.randi() % body_types.size()])
	seeded_parts.append(head_types[rng.randi() % head_types.size()])
	seeded_parts.append(leg_types[rng.randi() % leg_types.size()])
	seeded_parts.shuffle()
	
	var i = 0
	for dropOff in dropOffs:
		var part_type
		if !seeded_parts.empty():
			part_type = seeded_parts.pop_back()
		else:
			part_type = packedSpriteScenes.keys()[rng.randi() % packedSpriteScenes.keys().size()]

		add_part_at_dropoff(i, dropOff, part_type)

		i += 1


func add_part_at_dropoff(i: int, dropOff, part_type):
	if parts_to_give > 0:
		var newDraggablePart = create_part(part_type, i)
		newDraggablePart.global_transform = dropOff.global_transform.translated(Vector3(0, 2.5, 0))
		slots[i] = newDraggablePart
		parts_to_give -= 1


func on_part_used(part_index: int):
	var part_type = packedSpriteScenes.keys()[rng.randi() % packedSpriteScenes.keys().size()]
	add_part_at_dropoff(part_index, dropOffs[part_index], part_type)



func clear_current_parts():
	var i = 0
	for dropOff in dropOffs:
		if slots[i] != null:
			slots[i].queue_free()
			slots[i] = null
		i += 1

func on_assembly_start():
	parts_to_give = 20
	clear_current_parts()
	fillDropOffs()
