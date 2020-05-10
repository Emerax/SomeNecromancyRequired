extends Spatial

class_name Combat

signal combat_done

export(NodePath) var assemblyPath

onready var dummy_ghoul_template = load("res://scenes/ghoul/GhoulDmmy.tscn")

onready var grid: Array = [
	[self.get_node("Grid/Area/00"), self.get_node("Grid/Area/01"), self.get_node("Grid/Area/02"), self.get_node("Grid/Area/03")],
	[self.get_node("Grid/Area/10"), self.get_node("Grid/Area/11"), self.get_node("Grid/Area/12"), self.get_node("Grid/Area/13")],
	[self.get_node("Grid/Area/20"), self.get_node("Grid/Area/21"), self.get_node("Grid/Area/22"), self.get_node("Grid/Area/23")],
]

var selected_ghoul = null

var ghouls: Array = [
	[null, null, null, null],
	[null, null, null, null],
	[null, null, null, null],
]

onready var spawners = [$Spawners/EnemySpawner0, $Spawners/EnemySpawner1, $Spawners/EnemySpawner2]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.call_deferred("try_add_ghoul", 2, 3, dummy_ghoul_template.instance())
	self.call_deferred("try_add_ghoul", 0, 0, dummy_ghoul_template.instance())
	self.call_deferred("try_add_ghoul", 0, 3, dummy_ghoul_template.instance())

func set_ghoul_pos(lane: int, column: int, ghoul: Object):
		grid[lane][column].add_child(ghoul)
		ghouls[lane][column] = ghoul
		ghoul.onMove(lane, column)

func try_add_ghoul(lane: int, column: int, new_ghoul: Object):
	if ghouls[lane][column] == null:
		new_ghoul.init(self)
		set_ghoul_pos(lane, column, new_ghoul)
		new_ghoul.activate()
		return true
	return false

func remove_ghoul(lane: int, column: int):
	if ghouls[lane][column] != null:
		grid[lane][column].remove_child(ghouls[lane][column])
	ghouls[lane][column] = null

func try_move_ghoul(ghoul, lane: int, column: int) -> bool:
	if ghouls[lane][column] == null:
		remove_ghoul(ghoul.lane, ghoul.column)
		set_ghoul_pos(lane, column, ghoul)
		return true
	return false

func get_first_defender(lane: int) -> Object:
	var i = -1
	while i >= -4:
		if ghouls[lane][i] != null:
			return ghouls[lane][i]
		i -= 1
	return null

func onSpawnerDone():
	for spawner in spawners:
		if spawner.spawnCount < 1 and spawner.last_spawn == null:
			return
	emit_signal("combat_done")

func startCombatRound(difficulty):
	for spawner in spawners:
		spawner.queueEnemies(difficulty)

func grid_index_to_coord(index):
	return [index / 4, index % 4]

func _on_Grid_input_event(_camera, event, _click_position, _click_normal, shape_idx):
	if selected_ghoul != null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				var clickedPos = grid_index_to_coord(shape_idx)
				if selected_ghoul.active:
					if try_move_ghoul(selected_ghoul, clickedPos[0], clickedPos[1]):
						selected_ghoul.onDeselect()
						selected_ghoul = null
				else:
					if ghouls[clickedPos[0]][clickedPos[1]] == null:
						selected_ghoul.get_parent().remove_child(selected_ghoul)
						self.get_node(assemblyPath).on_ghoul_deployed()
						try_add_ghoul(clickedPos[0], clickedPos[1], selected_ghoul)
						selected_ghoul.onDeselect()
						selected_ghoul = null

func _on_ghoul_select(ghoul):
	if selected_ghoul != null:
		selected_ghoul.onDeselect()
		if selected_ghoul == ghoul:
			selected_ghoul = null
		else:
			selected_ghoul = ghoul
			selected_ghoul.onSelect()
	else:
		selected_ghoul = ghoul
		selected_ghoul.onSelect()
