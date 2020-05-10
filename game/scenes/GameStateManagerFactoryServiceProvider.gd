extends Spatial

export(NodePath) var combatPath

var state
var camera_path = @"../Camera"
var combatRound: int = 1

enum GameState {
	Assembly,
	Fight
}


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("combat_done", self, "on_fight_end")
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
	get_node(combatPath).startCombatRound(combatRound)
	print("test")


func on_fight_end():
	combatRound += 1
	state = GameState.Assembly
	get_node(camera_path).move_to_assembly()
