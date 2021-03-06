extends Node


# General
const MELEE_INCREASE = 25
const MELEE_INCREASE_SHARP = 50
const ATTACK_SPEED_INCREASE = 0.25
const ATTACK_SPEED_INCREASE_SHARP = 0.5
const HEALTH_INCREASE = 500
const DODGE_INCREASE_LOW = 0.1
const DODGE_INCREASE = 0.15
const DODGE_INCREASE_SHARP = 0.3

# Ability-specific
const DAMAGE_SCALE_TIME = 0.02
const DAMAGE_SCALE_TROLL = 0.04
const HEAL_RANGE = 10.0
const HEAL_AMOUNT = 100.0
const HEAL_COOLDOWN = 4.0


# Troll scaling
const TROLL_SCALE_FACTOR = 0.15
var troll_scale = 1.0
var non_troll_count = 0

func update_troll_scale():
	troll_scale = 1.0 + non_troll_count * TROLL_SCALE_FACTOR

func on_ability_added(ability):
	if !("Troll" in ability.name):
		non_troll_count += 1
		update_troll_scale()

func on_ability_removed(ability):
	if !("Troll" in ability.name):
		non_troll_count -= 1
		update_troll_scale()


onready var classes = {
	"ARM_DRAKE": ArmsDrake,
	"ARM_SCORPION": ArmsScorpion,
	"ARM_TROLL": ArmsTroll,
	"BODY_DRAKE": BodyDrake,
	"BODY_HORSE": BodyHorse,
	"BODY_SCORPION": BodyScorpion,
	"BODY_TROLL": BodyTroll,
	"HEAD_DRAKE": HeadDrake,
	"HEAD_HORSE": HeadHorse,
	"HEAD_SCORPION": HeadScorpion,
	"HEAD_TROLL": HeadTroll,
	"LEG_DRAKE": LegDrake,
	"LEG_HORSE": LegHorse,
	"LEG_SCORPION": LegScorpion,
	"LEG_TROLL": LegTroll
}

class ArmsDrake:
	var name = "Drake Arms"
	var description = "+ Grants FLIGHT allowing MELEE to be used RANGED. [Not implemented]"
	# TODO

class ArmsScorpion:
	var name = "Scorpion Arms"
	var description = "+ Sharply increased MELEE."
	func process_stats(ghoul):
		ghoul.melee += MELEE_INCREASE_SHARP

class ArmsTroll:
	var name = "Troll Arms"
	var description = "+ Increased MELEE, scales with total number of non-troll parts on the field."
	func process_stats(ghoul):
		ghoul.melee += MELEE_INCREASE * Abilities.troll_scale

class BodyDrake:
	var name = "Drake Body"
	var description = "+ Halving received RANGED damage."
	func process_stats(ghoul):
		ghoul.ranged_received_factor = 0.5

class BodyHorse:
	var name = "Horse Body"
	var description = "+ MELEE increased with DODGE chance.\n+ Increased HEALTH."
	func process_stats_second_pass(ghoul):
		ghoul.melee *= 1.0 + ghoul.dodge
		ghoul.max_health += HEALTH_INCREASE

class BodyScorpion:
	var name = "Scorpion Body"
	var description = "+ Inreased MELEE.\n+ Increased HEALTH."
	func process_stats(ghoul):
		ghoul.melee += MELEE_INCREASE
		ghoul.max_health += HEALTH_INCREASE

class BodyTroll:
	var name = "Troll Body"
	var description = "+ Increased ATTACK SPEED, scales with total number of non-troll parts on the field."
	func process_stats(ghoul):
		ghoul.attack_speed += ATTACK_SPEED_INCREASE * Abilities.troll_scale

class HeadDrake:
	var name = "Drake Head"
	var description = "+ Very strong RANGED fireballs. [Not implemented]"
	# TODO

class HeadHorse:
	var name = "Horse Head"
	var description = "+ HEALS nearby ghouls and self."
	var cooldown = 0.0
	func process_stats_third_pass(ghoul, delta):
		cooldown -= delta
		if cooldown < 0:
			cooldown = HEAL_COOLDOWN
			for ally in ghoul.get_tree().get_nodes_in_group("ghouls"):
				if ally.is_active():
					var d = ally.global_transform.origin - ghoul.global_transform.origin
					if d.length() <= HEAL_RANGE:
						ghoul.take_damage(-HEAL_AMOUNT)

class HeadScorpion:
	var name = "Scorpion Head"
	var description = "+ Sharply increased ATTACK SPEED."
	func process_stats(ghoul):
		ghoul.attack_speed += ATTACK_SPEED_INCREASE_SHARP

class HeadTroll:
	var name = "Troll Head"
	var description = "+ Scales up MELEE/RANGED strength with time on the field and total number of non-troll parts on the field."
	var time_passed = 0.0
	func process_stats_third_pass(ghoul, delta):
		time_passed += delta
		var scale = 1.0 + DAMAGE_SCALE_TIME * time_passed
		scale *= 1.0 + DAMAGE_SCALE_TROLL * Abilities.troll_scale
		ghoul.melee *= scale
		ghoul.ranged *= scale

class LegDrake:
	var name = "Drake Legs"
	var description = "+ DODGE chance.\n● Increased MELEE."
	func process_stats(ghoul):
		ghoul.dodge += DODGE_INCREASE
		ghoul.melee += MELEE_INCREASE

class LegHorse:
	var name = "Horse Legs"
	var description = "+ High DODGE chance."
	func process_stats(ghoul):
		ghoul.dodge += DODGE_INCREASE_SHARP

class LegScorpion:
	var name = "Scorpion Legs"
	var description = "+ Increased HEALTH."
	func process_stats(ghoul):
		ghoul.max_health += HEALTH_INCREASE

class LegTroll:
	var name = "Troll Legs"
	var description = "+ Low DODGE chance, scales with total number of non-troll parts on the field."
	func process_stats(ghoul):
		ghoul.dodge += DODGE_INCREASE_LOW * Abilities.troll_scale
