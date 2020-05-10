extends Spatial

export var lane = 0;

onready var rng = RandomNumberGenerator.new()

var template = preload("enemy.tscn")

var combat;

var spawnCount: int
var done: bool = true

var last_spawn = null
var spawnCooldown: float = 3.0
var spawnVariance: float = 2.0
var currentCooldown: float

var since_last_spawn = 0
var first_in_line = null

func set_next(next):
	last_spawn = next

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	currentCooldown = spawnCooldown + rng.randf() * spawnVariance
	add_to_group("enemy_spawners")
	self.combat = get_tree().get_root().find_node("CombatScene", true, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentCooldown -= delta
	if spawnCount and currentCooldown <= 0:
		call_deferred("spawn_enemy")
		spawnCount -= 1
		currentCooldown = spawnCooldown + rng.randf() * spawnVariance

func onSpawneeDeath():
	if spawnCount < 1 and last_spawn == null:
		self.done = true
		combat.onSpawnerDone()

func queueEnemies(number: int):
	self.done = false
	self.spawnCount = number

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
