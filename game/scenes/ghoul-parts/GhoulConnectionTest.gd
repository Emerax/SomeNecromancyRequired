extends Spatial

export(Resource) var body_troll
export(Resource) var body_horse
export(Resource) var body_drake
export(Resource) var body_scorpion

export(Resource) var arm_troll
export(Resource) var arm_drake
export(Resource) var arm_scorpion

export(Resource) var head_troll
export(Resource) var head_horse
export(Resource) var head_drake
export(Resource) var head_scorpion

export(Resource) var leg_troll
export(Resource) var leg_horse
export(Resource) var leg_drake
export(Resource) var leg_scorpion

var troll
var horse
var drake
var scorpion

func run_test0():
	print("Test 2: Add limbs everywhere")
	troll.try_add_arms(arm_drake.instance())
	troll.try_add_head(head_horse.instance())
	troll.try_add_legs(leg_scorpion.instance())
	
	horse.try_add_arms(arm_scorpion.instance())
	horse.try_add_head(head_drake.instance())
	horse.try_add_legs(leg_troll.instance())
	
	drake.try_add_arms(arm_scorpion.instance())
	drake.try_add_head(head_scorpion.instance())
	drake.try_add_legs(leg_horse.instance())
	
	scorpion.try_add_arms(arm_troll.instance())
	scorpion.try_add_head(head_troll.instance())
	scorpion.try_add_legs(leg_drake.instance())

func run_test1():
	print("Test 1: Try add limbs everywhere again")
	troll.try_add_arms(arm_troll.instance())
	troll.try_add_head(head_troll.instance())
	troll.try_add_legs(leg_drake.instance())
	
	horse.try_add_arms(arm_drake.instance())
	horse.try_add_head(head_horse.instance())
	horse.try_add_legs(leg_scorpion.instance())
	
	drake.try_add_arms(arm_drake.instance())
	drake.try_add_head(head_drake.instance())
	drake.try_add_legs(leg_troll.instance())
	
	scorpion.try_add_arms(arm_scorpion.instance())
	scorpion.try_add_head(head_scorpion.instance())
	scorpion.try_add_legs(leg_horse.instance())

func run_test2():
	print("Test 2: Remove all limbs")
	troll.remove_arms()
	troll.remove_head()
	troll.remove_legs()
	
	horse.remove_arms()
	horse.remove_head()
	horse.remove_legs()
	
	drake.remove_arms()
	drake.remove_head()
	drake.remove_legs()
	
	scorpion.remove_arms()
	scorpion.remove_head()
	scorpion.remove_legs()

func run_test3():
	print("Test 3: Add limbs everywhere again")
	troll.try_add_arms(arm_scorpion.instance())
	troll.try_add_head(head_scorpion.instance())
	troll.try_add_legs(leg_horse.instance())
	
	horse.try_add_arms(arm_troll.instance())
	horse.try_add_head(head_troll.instance())
	horse.try_add_legs(leg_drake.instance())
	
	drake.try_add_arms(arm_troll.instance())
	drake.try_add_head(head_horse.instance())
	drake.try_add_legs(leg_scorpion.instance())
	
	scorpion.try_add_arms(arm_drake.instance())
	scorpion.try_add_head(head_drake.instance())
	scorpion.try_add_legs(leg_troll.instance())

func _ready():
	print("Setup: Instantiate bodies")
	troll = body_troll.instance()
	add_child(troll)
	
	horse = body_horse.instance()
	add_child(horse)
	horse.transform.origin.x = 4
	
	drake = body_drake.instance()
	add_child(drake)
	drake.transform.origin.x = 8
	
	scorpion = body_scorpion.instance()
	add_child(scorpion)
	scorpion.transform.origin.x = 12
	
	run_test0()

var runtime = 0.0
var test1 = true
var test2 = true
var test3 = true

func _process(delta):
	runtime += delta
	
	if runtime > 1.0 and test1:
		test1 = false
		run_test1()
	
	if runtime > 2.0 and test2:
		test2 = false
		run_test2()
	
	if runtime > 3.0 and test3:
		test3 = false
		run_test3()
