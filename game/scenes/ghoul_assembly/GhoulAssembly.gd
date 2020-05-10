extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parts: Array = [
	"ARM_DRAKE",
	"ARM_SCORPION",
	"ARM_TROLL",
	"BODY_DRAKE",
	"BODY_HORSE",
	"BODY_SCORPION",
	"BODY_TROLL",
	"HEAD_DRAKE",
	"HEAD_HORSE",
	"HEAD_SCORPION",
	"HEAD_TROLL",
	"LEG_DRAKE",
	"LEG_HORSE",
	"LEG_SCORPION",
	"LEG_TROLL"
]

export(NodePath) var combatPath
onready var combat = self.get_node(combatPath)

onready var packedPartScenes = {
	"ARM_DRAKE": preload("res://scenes/ghoul-parts/ArmDrake.tscn"),
	"ARM_SCORPION":preload("res://scenes/ghoul-parts/ArmScorpion.tscn"),
	"ARM_TROLL": preload("res://scenes/ghoul-parts/ArmTroll.tscn"),
	"BODY_DRAKE": preload("res://scenes/ghoul-parts/BodyDrake.tscn"),
	"BODY_HORSE": preload("res://scenes/ghoul-parts/BodyHorse.tscn"),
	"BODY_SCORPION": preload("res://scenes/ghoul-parts/BodyScorpion.tscn"),
	"BODY_TROLL": preload("res://scenes/ghoul-parts/BodyTroll.tscn"),
	"HEAD_DRAKE": preload("res://scenes/ghoul-parts/HeadDrake.tscn"),
	"HEAD_HORSE": preload("res://scenes/ghoul-parts/HeadHorse.tscn"),
	"HEAD_SCORPION": preload("res://scenes/ghoul-parts/HeadScorpion.tscn"),
	"HEAD_TROLL": preload("res://scenes/ghoul-parts/HeadTroll.tscn"),
	"LEG_DRAKE": preload("res://scenes/ghoul-parts/LegDrake.tscn"),
	"LEG_HORSE": preload("res://scenes/ghoul-parts/LegHorse.tscn"),
	"LEG_SCORPION": preload("res://scenes/ghoul-parts/LegScorpion.tscn"),
	"LEG_TROLL": preload("res://scenes/ghoul-parts/LegTroll.tscn")
}

var packedGhoul = preload("res://scenes/ghoul/Ghoul.tscn")

onready var leg_lenghts = {
	"LEG_DRAKE": 1.552,
	"LEG_HORSE": 1.975,
	"LEG_SCORPION": 1.147,
	"LEG_TROLL": 1.596
}

var ghoul_in_progress
var ghoul_body

var selected_part

func try_add_part(part_name):
	assert(packedPartScenes.has(part_name))
	var part = packedPartScenes[part_name].instance()
	assert(Abilities.classes.has(part_name))
	var ability = Abilities.classes[part_name].new()
	
	if "BODY" in part_name:
		if ghoul_in_progress == null:
			# Ghoul
			ghoul_in_progress = packedGhoul.instance()
			ghoul_in_progress.add_ability(ability)
			add_child(ghoul_in_progress)
			
			# Body
			ghoul_body = part
			ghoul_in_progress.add_child(ghoul_body)
			ghoul_body.transform.origin.x = -0.7
			return true
	elif ghoul_in_progress != null:
		if "ARM" in part_name:
			if ghoul_body.try_add_arms(part):
				ghoul_in_progress.add_ability(ability)
				return true
		elif "HEAD" in part_name:
			if ghoul_body.try_add_head(part):
				ghoul_in_progress.add_ability(ability)
				return true
		elif "LEG" in part_name:
			assert(leg_lenghts.has(part_name))
			if ghoul_body.try_add_legs(part, leg_lenghts[part_name]):
				ghoul_in_progress.add_ability(ability)
				return true
	return false

func on_ghoul_deployed():
	ghoul_body = null	
	ghoul_in_progress = null

func _on_part_select_event(part):
	if selected_part != null:
		selected_part.onDeselect()
		if selected_part == part:
			selected_part = null
		else:
			selected_part = part
			selected_part.onSelect()
	else:
		selected_part = part
		selected_part.onSelect()

func _on_AssemblyArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if selected_part != null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				if try_add_part(selected_part.partType):
					selected_part.onAdd()
					selected_part = null #Clear selection when adding
					if ghoul_body.is_complete():
						ghoul_in_progress.init(combat)
