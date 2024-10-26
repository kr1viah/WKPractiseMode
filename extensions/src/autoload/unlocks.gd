extends "res://src/autoload/unlocks.gd"

func _process(delta):
	if ModLoader.get_node("kr1v-practisemode").inUltraFightPractise or ModLoader.get_node("kr1v-practisemode").inEnemyOrBossPractise:
		return
	super(delta)
func update():
	if ModLoader.get_node("kr1v-practisemode").inUltraFightPractise or ModLoader.get_node("kr1v-practisemode").inEnemyOrBossPractise:
		return
	super()
func _init():
	if ModLoader.get_node("kr1v-practisemode").inUltraFightPractise or ModLoader.get_node("kr1v-practisemode").inEnemyOrBossPractise:
		return
	super()
