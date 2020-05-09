extends AnimationPlayer

func _ready():
	randomize()
	play(get_animation_list()[0])
	var offset : float = rand_range(0, current_animation_length)
	advance(offset)
