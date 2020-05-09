extends Spatial

enum LIMBTYPE {
	arm,
	head,
	leg
}

export(LIMBTYPE) var type = LIMBTYPE.leg

var limb

func _ready():
	assert(type != null)

func get_limb_point_type():
	return type;

func has_limb():
	return limb != null

func add_limb(new_limb):
	assert(!has_limb())
	add_child(new_limb)
	limb = new_limb

func remove_limb():
	if has_limb():
		remove_child(limb)
	limb = null
