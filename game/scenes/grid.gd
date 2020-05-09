extends Spatial

var ghoul_template = preload("ghoul/Ghoul.tscn")

var spacing = 6;

var ghouls: Array = [
	[null, null, null, null],
	[null, null, null, null],
	[null, null, null, null],
]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_ghoul(ghoul_template.instance(), 2, 3)
	add_ghoul(ghoul_template.instance(), 0, 0)
	add_ghoul(ghoul_template.instance(), 0, 3)


func add_ghoul(dude: Spatial, lane: int, column: int):
	if ghouls[lane][column] == null:
		dude.transform.origin = \
			Vector3(spacing * (lane-1), 0, spacing * column)
		self.call_deferred("add_child", dude)
		ghouls[lane][column] = dude


func get_first_defender(lane: int) -> Object:
	var i = -1
	while i >= -4:
		if ghouls[lane][i] != null:
			return ghouls[lane][i]
		i -= 1
	return null
