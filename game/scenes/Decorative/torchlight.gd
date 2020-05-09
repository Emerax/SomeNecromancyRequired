extends OmniLight


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var initial_energy
var extra_intensity = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_energy = self.light_energy
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	extra_intensity += randf() * 0.1 - 0.05
	extra_intensity = min(max(-0.3, extra_intensity), 0.3)
	self.light_energy = initial_energy + extra_intensity
	pass
