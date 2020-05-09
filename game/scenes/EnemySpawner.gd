extends Spatial

var lane = 0
var template = preload("enemy.tscn")

var since_last_spawn = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.since_last_spawn += delta
	if self.since_last_spawn > 3:
		var new_enemy = template.instance()
		new_enemy.init(self.transform)
		# add_child(new_enemy)
		# new_enemy.set_owner(get_tree().get_root())
		get_tree().get_root().call_deferred("add_child", new_enemy)
		self.since_last_spawn = 0
