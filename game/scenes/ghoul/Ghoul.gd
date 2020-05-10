extends Spatial

class_name Ghoul

signal select_ghoul(ghoul)

onready var selectionSprite = $SelectionSprite
onready var healthbar = $Healthbar

var active = false
var combat: Combat = null

var lane = 0
var column = 0
var enemy_spawner = null
var parts: Array = []

var damage_taken = 0
var attack_cooldown_left = 0.0
const MELEE_RANGE = 6.0
const RANGED_RANGE = 20.0
onready var initial_health_transform = healthbar.transform

# Variabel stats from abilities
const STANDARD_MELEE = 100
const STANDARD_RANGED = 0
const STANDARD_ATTACK_SPEED = 1.0
const STANDARD_MAX_HEALTH = 1000
const STANDARD_DODGE = 0.0
const STANDARD_RANGED_RECEIVED_FACTOR = 1.0
var melee                  = STANDARD_MELEE
var ranged                 = STANDARD_RANGED
var attack_speed           = STANDARD_ATTACK_SPEED
var max_health             = STANDARD_MAX_HEALTH
var dodge                  = STANDARD_DODGE
var ranged_received_factor = STANDARD_RANGED_RECEIVED_FACTOR

var abilities = []
var first_pass_abilities = []
var second_pass_abilities = []
var third_pass_abilities = []

func _ready():
	add_to_group("ghouls")
# warning-ignore:return_value_discarded
	$ClickDetector.set_process(false)
	selectionSprite.visible = false

func print_stats():
	print("===========================")
	print("Ghoul Stats:")
	print("---------------------------")
	print("active ", active)
	print("damage_taken ", damage_taken)
	print("---------------------------")
	print("melee ", melee)
	print("ranged ", ranged)
	print("attack_speed ", attack_speed)
	print("max_health ", max_health)
	print("dodge ", dodge)
	print("ranged_received_factor ", ranged_received_factor)
	print("===========================")

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(combat: Combat):
	$ClickDetector.set_process(true)
# warning-ignore:return_value_discarded
	self.connect("select_ghoul", combat, "_on_ghoul_select")
	self.combat = combat

func activate():
	active = true
	
func is_active():
	return active

func take_damage(amount: int, ranged = false):
	if ranged:
		amount *= ranged_received_factor
	damage_taken += amount
	if damage_taken < 0: # Due to heal
		damage_taken = 0
	var health_factor = (max_health - damage_taken) / float(max_health)
	healthbar.transform = initial_health_transform.scaled(Vector3(health_factor, 1, 1))

var target = null
var is_attacking = false

func try_attack():
	if attack_cooldown_left <= 0.0 && !is_attacking:
		target = weakref(enemy_spawner.first_in_line).get_ref()
		if target != null:
			var target_pos = target.global_transform.origin 
			var d = target_pos - global_transform.origin
			if d.length() < MELEE_RANGE:
				$AnimationPlayer.play("attack")
				attack_cooldown_left = 1.0 / STANDARD_ATTACK_SPEED
				var animation_length = $AnimationPlayer.current_animation_length
				if attack_cooldown_left < animation_length:
					var animation_speed = animation_length/attack_cooldown_left
					$AnimationPlayer.play("attack", -1, animation_speed)
				is_attacking = true

func deal_damage():
	target = weakref(enemy_spawner.first_in_line).get_ref()
	if target != null:
		target.take_damage(melee)
	is_attacking = false

func add_ability(ability):
	abilities.append(ability)
	if ability.has_method("process_stats"):
		first_pass_abilities.append(ability)
	if ability.has_method("process_stats_second_pass"):
		second_pass_abilities.append(ability)
	if ability.has_method("process_stats_third_pass"):
		third_pass_abilities.append(ability)

func _process(delta):
	if !active:
		return
	
	if damage_taken >= max_health: # max_health can vary
		combat.remove_ghoul(lane, column)
	
	# Reset
	melee                  = STANDARD_MELEE
	ranged                 = STANDARD_RANGED
	attack_speed           = STANDARD_ATTACK_SPEED
	max_health             = STANDARD_MAX_HEALTH
	dodge                  = STANDARD_DODGE
	ranged_received_factor = STANDARD_RANGED_RECEIVED_FACTOR
	
	# Recalculate
	for ability in first_pass_abilities:
		ability.process_stats(self)
	for ability in second_pass_abilities:
		ability.process_stats_second_pass(self)
	for ability in third_pass_abilities:
		ability.process_stats_third_pass(self, delta)
	
	attack_cooldown_left -= delta
	try_attack()

func onSelect():
	selectionSprite.visible = true

func onDeselect():
	selectionSprite.visible = false

func onMove(newLane: int, newColumn: int):
	self.lane = newLane
	self.column = newColumn
	for spawner in get_tree().get_nodes_in_group("enemy_spawners"):
		if spawner.lane == self.lane:
			self.enemy_spawner = spawner
	assert(self.enemy_spawner != null)

func _on_ClickDetector_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("select_ghoul", self)
