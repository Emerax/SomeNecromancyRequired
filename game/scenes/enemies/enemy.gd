extends Spatial


var kind_preload = preload("WizardType.tscn")
var kind;


enum State {
	# Currently walking
	Walking
	# Pre-attack animation
	AttackStart,
	# Post attack animation
	AttackEnd
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lane = 0
var speed = 5
var since_last_attack = 0
var next_in_line = null

var grid: Grid = null

var projectile_template = preload("../Fireball.tscn")

var state = State.Walking

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(transform, lane, grid, next_in_line):
	self.lane = lane
	self.grid = grid
	self.transform = transform
	self.next_in_line = next_in_line

# Called when the node enters the scene tree for the first time.
func _ready():
	kind = kind_preload.instance()
	add_child(kind)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	since_last_attack += delta

	var can_move: bool = true
	# This is only ranged attacks
	# Check if there is something to attack and if the cooldown is over
	var target = self.grid.get_first_defender(self.lane)
	if target != null and kind.is_in_range(target):
		if state == State.AttackStart:
			if not kind.is_animating():
				since_last_attack = 0;
				var projectile = projectile_template.instance()
				var position = kind.projectile_launch_transform().origin
				projectile.init(
					target,
					position,
					Vector3(0, 3, 0),
					1
				)
				get_tree().get_root().add_child(projectile)
				state = State.Walking
		if state == State.Walking and since_last_attack > 1:
			state = State.AttackStart
			self.kind.play_attack()

		var d = target.get_global_transform().origin - get_global_transform().origin;
		if d.length() < 4:
			can_move = false
	else:
		state = State.Walking

	# Check if we ran into a ghoul or someone ahead of us
	if self.next_in_line != null:
		var d = next_in_line.get_global_transform().origin - get_global_transform().origin;
		if d.length() < 4:
			can_move = false

	if can_move and state == State.Walking:
		self.transform = self.transform.translated(Vector3(0, 0, -self.speed) * delta)
		kind.play_walk()

