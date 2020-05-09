extends Spatial


var target;
var initial_velocity: Vector3;
var speed = 15;
var initial_velocity_contribution = 1;


func init(target, transform, initial_velocity):
	self.target = target
	self.transform = transform
	self.initial_velocity = initial_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.initial_velocity_contribution = max(0, self.initial_velocity_contribution - 0.2 * delta)
	# Accelerate towards the target
	var velocity = -(
			self.get_global_transform().origin - target.get_global_transform().origin
		).normalized() * speed \
		+ (self.initial_velocity * self.initial_velocity_contribution)
	self.transform = self.transform.translated(velocity * delta)
