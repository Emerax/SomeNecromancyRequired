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

onready var dropOffs = [$Dropoff1, $Dropoff2, $Dropoff3, $Dropoff4, $Dropoff5]

onready var packed_part = preload("res://scenes/draggable_parts/DraggablePart.tscn")

onready var rng = RandomNumberGenerator.new()

var first = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first && get_node(ghoulAssemblyPath):
		fillDropOffs()
		first = false

func createRandomPart():
	var partType = packedSpriteScenes.keys()[rng.randi() % packedSpriteScenes.keys().size()]
	var newPartSprite = packedSpriteScenes[partType]
	var newPart: Spatial = packed_part.instance()
	var ghoulAssembly = get_node(ghoulAssemblyPath)
	newPart.initialize(newPartSprite, partType, ghoulAssembly)
	get_tree().root.call_deferred("add_child", newPart)
	return newPart

func fillDropOffs():
	for dropOff in dropOffs:
		var newDraggablePart = createRandomPart()
		newDraggablePart.global_transform = dropOff.global_transform.translated(Vector3(0, 1.5, 0))
