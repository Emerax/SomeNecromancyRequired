extends Spatial

class_name Ghoul

signal select_ghoul(ghoul)

onready var selectionSprite = $SelectionSprite

var combat: Combat = null
var lane = 0
var column = 0
var parts: Array = []
var health = 10

func _ready():
	self.connect("select_ghoul", combat, "_on_ghoul_select")
	selectionSprite.visible = false

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(combat: Combat, lane: int, column: int):
	self.combat = combat
	self.lane = lane
	self.column = column

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		combat.remove_ghoul(lane, column)

func onSelect():
	selectionSprite.visible = true

func onDeselect():
	selectionSprite.visible = false

func onMove(newLane: int, newColumn: int):
	self.lane = newLane
	self.column = newColumn

func _on_ClickDetector_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("select_ghoul", self)
