extends Spatial

class_name Grid

onready var ghoul_template = load("res://scenes/ghoul/Ghoul.tscn")

var spacing = 6;

var ghouls: Array = [
	[null, null, null, null],
	[null, null, null, null],
	[null, null, null, null],
]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_ghoul(2, 3)
	add_ghoul(0, 0)
	add_ghoul(0, 3)


func lane_position(lane: int, column: int) -> Vector3:
	return Vector3(spacing * (lane-1), 0, spacing * column)


func add_ghoul(lane: int, column: int):
	if ghouls[lane][column] == null:
		var new_ghoul = ghoul_template.instance()
		new_ghoul.init(self, lane, column)
		new_ghoul.transform.origin = lane_position(lane, column)
		self.call_deferred("add_child", new_ghoul)
		new_ghoul.grid = self
		ghouls[lane][column] = new_ghoul


func remove_ghoul(lane: int, column: int):
	if ghouls[lane][column] != null:
		remove_child(ghouls[lane][column])
	ghouls[lane][column] = null


func get_first_defender(lane: int) -> Object:
	var i = -1
	while i >= -4:
		if ghouls[lane][i] != null:
			return ghouls[lane][i]
		i -= 1
	return null
