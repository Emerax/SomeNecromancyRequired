extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var attack_range = 3

onready var animator = $axe_dude/AnimationPlayer;




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func play_attack():
	animator.play("attack")

func play_walk():
	if !is_animating():
		animator.play("walk")

func is_animating() -> bool:
	return animator.is_playing()

func is_in_range(target: Spatial) -> bool:
	var dir = target.get_global_transform().origin - get_global_transform().origin
	return dir.length() < attack_range


# TODO: Remove since this is not a melee dude
func projectile_launch_transform() -> Transform:
	return Transform(Basis.IDENTITY, get_global_transform().origin)

