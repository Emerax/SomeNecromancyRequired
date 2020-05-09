extends Spatial

onready var dropOffs = [$Dropoff1, $Dropoff2, $Dropoff3, $Dropoff4, $Dropoff5]

onready var packed_part = preload("res://scenes/parts/Part.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fillDropOffs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func fillDropOffs():
	for dropOff in dropOffs:
		var newPart: Spatial = packed_part.instance()
		newPart.global_transform = dropOff.global_transform.translated(Vector3(0, 1.5, 0))
		
		get_tree().root.call_deferred("add_child", newPart)
