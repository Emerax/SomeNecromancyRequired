extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lane = 0
var speed = 3
var since_last_attack = 0
var next_in_line = null

var grid

var projectile_template = preload("Fireball.tscn")

func init(transform, lane, grid, next_in_line):
	self.lane = lane
	self.grid = grid
	self.transform = transform
	self.next_in_line = next_in_line

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	since_last_attack += delta

	var can_move: bool = true
	# This is only ranged attacks
	# Check if there is something to attack and if the cooldown is over
	var target = self.grid.get_first_defender(self.lane)
	if target != null:
		if since_last_attack > 1:
			since_last_attack = 0;
			var projectile = projectile_template.instance()
			projectile.init(target, self.get_global_transform(), Vector3(0, 3, 0))
			get_tree().get_root().add_child(projectile)

		var d = target.get_global_transform().origin - get_global_transform().origin;
		if d.length() < 4:
			can_move = false

	# Check if we ran into a ghoul or someone ahead of us
	if self.next_in_line != null:
		var d = next_in_line.get_global_transform().origin - get_global_transform().origin;
		if d.length() < 4:
			can_move = false

	if can_move:
		self.transform = self.transform.translated(Vector3(0, 0, -self.speed) * delta)

