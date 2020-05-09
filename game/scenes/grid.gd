extends Spatial

var template = preload("GhoulPlaceholder.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spacing = 6;

var dudes: Array = [
		[null, null, null, null],
		[null, null, null, null],
		[null, null, null, null],
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_dude(template.instance(), Vector2(2, 3))
	add_dude(template.instance(), Vector2(0, 0))
	add_dude(template.instance(), Vector2(0, 3))


func add_dude(dude: Spatial, location: Vector2):
	if self.dudes[location.x][location.y] == null:
		dude.transform = Transform.IDENTITY\
				.translated(Vector3(spacing * (location.x-1), 0, spacing * location.y))
		self.call_deferred("add_child", dude)
		dudes[location.x][location.y] = dude
		print("Doing dude stuff")


func get_first_defender(lane: int) -> Object:
	var result = null
	for dude in dudes[lane]:
		if dude != null:
			result = dude
	return result
