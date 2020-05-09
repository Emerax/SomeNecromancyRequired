extends Spatial

var arm_points = []
var head_points = []
var leg_points = []

func _ready():
	for maybe_point in get_children():
		if maybe_point.has_method("get_limb_point_type"):
			var point = maybe_point
			var point_type = point.get_limb_point_type()

			if point_type == point.LIMBTYPE.arm:
				arm_points.append(point)
			elif point_type == point.LIMBTYPE.head:
				head_points.append(point)
			elif point_type == point.LIMBTYPE.leg:
				leg_points.append(point)


func has_free_points(point_array):
	for point in point_array:
		if point.has_method("has_limb"):
			if point.has_limb():
				return false
	return true

func has_free_arm_points():
	return has_free_points(arm_points)

func has_free_head_points():
	return has_free_points(head_points)

func has_free_leg_points():
	return has_free_points(leg_points)


func try_add_limbs(limb, point_array):
	if has_free_points(point_array):
		for point in point_array:
			if point.has_method("add_limb"):
				point.add_limb(limb.duplicate())
		return true
	return false

func try_add_arms(arm):
	return try_add_limbs(arm, arm_points)

func try_add_head(head):
	return try_add_limbs(head, head_points)

func try_add_legs(leg):
	return try_add_limbs(leg, leg_points)


func remove_limbs(point_array):
	for point in point_array:
		if point.has_method("remove_limb"):
			point.remove_limb()

func remove_arms():
	remove_limbs(arm_points)

func remove_head():
	remove_limbs(head_points)

func remove_legs():
	remove_limbs(leg_points)
