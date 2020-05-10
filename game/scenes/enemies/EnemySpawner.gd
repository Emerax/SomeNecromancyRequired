extends Spatial

export var lane = 0;

onready var rng = RandomNumberGenerator.new()

var template = preload("enemy.tscn")

var combat;
var index

var spawnCount: int

var last_spawn = null
var spawnCooldown: float = 3.0
var spawnVariance: float = 2.0
var currentCooldown: float = spawnCooldown

func init(index):
	self.index = index

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	self.combat = get_tree().get_root().find_node("CombatScene", true, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentCooldown -= delta
	if spawnCount and currentCooldown <= 0:
		var new_enemy = template.instance()
		new_enemy.init(get_global_transform(), self.lane, self.combat, self.last_spawn)
		get_tree().get_root().call_deferred("add_child", new_enemy)
		self.last_spawn = new_enemy
		spawnCount -= 1
		currentCooldown = spawnCooldown + rng.randf() * spawnVariance
	if spawnCount < 1 and last_spawn == null:
		combat.onSpawnerDone()

func queueEnemies(number: int):
	self.spawnCount = number
