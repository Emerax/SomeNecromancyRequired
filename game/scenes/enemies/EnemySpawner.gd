extends Spatial

export var lane = 0;
var template = preload("enemy.tscn")

var combat;

var last_spawn = null
var since_last_spawn = 0
var first_in_line = null

func set_next(next):
	last_spawn = next

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy_spawners")
	self.combat = get_tree().get_root().find_node("CombatScene", true, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.since_last_spawn += delta
	if self.since_last_spawn > 3:
		call_deferred("spawn_enemy")

func spawn_enemy():
	var new_enemy = template.instance()
	new_enemy.init(get_global_transform(), self.lane, self.combat, self.last_spawn, self)
	get_tree().get_root().add_child(new_enemy)
	self.since_last_spawn = 0
	new_enemy.set_next(self.last_spawn)
	new_enemy.set_prev(self)
	if self.last_spawn != null:
		self.last_spawn.set_prev(new_enemy)
	if self.last_spawn == null:
		first_in_line = new_enemy
	self.last_spawn = new_enemy
