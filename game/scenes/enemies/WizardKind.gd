extends Spatial


var accessories = [
		preload("accessories/lantern.tscn"),
		preload("../Decorative/torch.tscn"),
	]

var attack_range = 50

onready var animator = $wizard/AnimationPlayer;




# Called when the node enters the scene tree for the first time.
func _ready():
	var accessory = accessories[rand_range(0, accessories.size())]
	self.find_node("off_hand").add_child(accessory.instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func play_attack():
	animator.play("attack")

func play_walk():
	if !is_animating():
		animator.play("walk-loop")

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

