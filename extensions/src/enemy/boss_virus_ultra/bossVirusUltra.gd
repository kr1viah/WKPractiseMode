extends "res://src/enemy/boss_virus_ultra/bossVirusUltra.gd"
var mod_main

func _ready():
	mod_main = ModLoader.get_node("kr1v-practisemode")
	super()

func _process(delta):
	if mod_main.inUltraFightPractise:
		if stage == 2:
			stageTimer = 7.0
			if stageTimer >= 10:
				stage = 3
		if stage == 1001:
			stageTimer = 7.0
			if stageTimer >= 10:
				stage = 2
		if stage == 1:
			stageTimer = 100.0
			stage = 1001
		if stage == 0:
			stageTimer = 100.0
			stage = 1
	super(delta)
