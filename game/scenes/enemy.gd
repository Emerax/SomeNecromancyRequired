extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lane = 0;


func init(transform):
	self.transform = transform

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.transform = self.transform.translated(Vector3(0, 0, -1) * delta)
	pass
