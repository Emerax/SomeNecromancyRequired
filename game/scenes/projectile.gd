extends Spatial


var target;
var initial_velocity: Vector3;
var speed = 15;
var initial_velocity_contribution = 1;
var damage = 1;


func init(target, position, initial_velocity, dmg):
	self.target = target
	self.transform.origin = position
	self.initial_velocity = initial_velocity
	self.damage = dmg

	target.connect("ghoul_died", self, "on_ghoul_died")


func _on_ghoul_died():
	print('hej')
	queue_free()


func _process(delta):
	var pos_diff = target.get_global_transform().origin - self.get_global_transform().origin

	# Delete self when at target
	if pos_diff.length_squared() < 0.1:
		queue_free()
		target.take_damage(damage)
		return

	# Accelerate towards the target
	self.initial_velocity_contribution = max(0, self.initial_velocity_contribution - 0.2 * delta)
	var velocity = pos_diff.normalized() * speed + \
		(self.initial_velocity * self.initial_velocity_contribution)

	self.transform = self.transform.translated(velocity * delta)
