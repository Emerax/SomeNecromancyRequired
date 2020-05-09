extends Spatial

var target
var target_position = Vector3(0, 0, 0)
var initial_velocity: Vector3
var speed = 15
var initial_velocity_contribution = 1
var damage = 1
var hit_target = false
var particles: Particles = null
var remove_timer = Timer.new()


# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(target, position, initial_velocity, dmg):
	self.target = target
	self.target_position = target.get_global_transform().origin
	self.transform.origin = position
	self.initial_velocity = initial_velocity
	self.damage = dmg

	self.particles = get_node(@"Particles")
	self.remove_timer.wait_time = self.particles.lifetime
	self.remove_timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout():
	queue_free()


func _process(delta):
	var pos_diff = target_position - self.get_global_transform().origin

	# Delete self when at target
	if pos_diff.length_squared() < 0.1:
		particles.emitting = false

		if not hit_target:
			hit_target = true
			if target.health > 0:
				target.take_damage(damage)
			remove_timer.start()

		return

	# Accelerate towards the target
	self.initial_velocity_contribution = max(0, self.initial_velocity_contribution - 0.2 * delta)
	var velocity = pos_diff.normalized() * speed + \
		(self.initial_velocity * self.initial_velocity_contribution)
	self.transform = self.transform.translated(velocity * delta)
