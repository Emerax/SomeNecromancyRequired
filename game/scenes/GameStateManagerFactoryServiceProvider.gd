extends Spatial


var state
var camera_path = @"../Camera"

enum GameState {
	Assembly,
	Fight
}


# Called when the node enters the scene tree for the first time.
func _ready():
	state = GameState.Assembly


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		if state == GameState.Assembly:
			on_fight_start()
		else:
			on_fight_end()


func on_fight_start():
	state = GameState.Fight
	get_node(camera_path).move_to_fight()
	print("test")


func on_fight_end():
	state = GameState.Assembly
	get_node(camera_path).move_to_assembly()
