extends Spatial

class_name Ghoul
signal ghoul_died

var grid: Grid = null
var lane = 0
var column = 0
var parts: Array = []
var health = 10


func _ready():
	pass


func init(grid: Grid, lane: int, column: int):
	self.grid = grid
	self.lane = lane
	self.column = column


func take_damage(amount: int):
	health -= amount
	if health < 0:
		grid.remove_ghoul(lane, column)
		emit_signal("ghoul_died")
