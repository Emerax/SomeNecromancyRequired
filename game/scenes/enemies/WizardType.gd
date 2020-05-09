extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var attack_range = 50

onready var animator = $wizard/AnimationPlayer;




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func walk():
	if not animator.is_playing():
		animator.play("walk-loop")



func play_attack():
	animator.play("attack")

func is_animating() -> bool:
	return animator.is_playing()

func is_in_range(target: Spatial) -> bool:
	var dir = target.get_global_transform().origin - get_global_transform().origin
	return dir.length() < attack_range


func projectile_launch_transform() -> Transform:
	var position = find_node("projectile_origin", true, false) \
			.get_global_transform() \
			.origin
	return Transform(Basis.IDENTITY, position)

