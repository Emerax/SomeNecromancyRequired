extends Spatial

export var lane = 0;
var template = preload("enemy.tscn")

var grid;

var since_last_spawn = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.grid = get_tree().get_root().find_node("Grid", true, false)
	print("lane: ", self.lane)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.since_last_spawn += delta
	if self.since_last_spawn > 3:
		var new_enemy = template.instance()
		print(self.lane)
		new_enemy.init(self.transform, self.lane, self.grid)
		# add_child(new_enemy)
		# new_enemy.set_owner(get_tree().get_root())
		get_tree().get_root().call_deferred("add_child", new_enemy)
		self.since_last_spawn = 0
