extends "res://src/main/main.gd"

func _ready():
	var config = ModLoaderConfig.get_current_config("kr1v-practisemode")
	var mod_main = ModLoader.get_node("kr1v-practisemode")
	if mod_main.inEnemyOrBossPractise:
		var characterToUse = config.data.characterToUse
		print_debug(characterToUse)
		if characterToUse == "random":
			var j = randi_range(1, 7)
			#var j = randi_range(1, 6)
			if j == 1: characterToUse = "epsilon"
			elif j == 2: characterToUse = "zephyr"
			elif j == 3: characterToUse = "blip"
			elif j == 4: characterToUse = ":)"
			elif j == 5: characterToUse = "bastion"
			elif j == 6: characterToUse = "nyx"
			elif j == 7: characterToUse = "mebo"
		print_debug(characterToUse)
		if characterToUse == "epsilon":
			Players.state = {}
			Players.details = [{
				char = Players.Char.BASIC,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.bellow = config.data.levelSpecialUpgrade			if !config.data.randomUpgrades else randi_range(0, 10)
			Global.bellowReal = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else Global.bellow
		if characterToUse == "zephyr":
			Players.state = {}
			Players.details = [{
				char = Players.Char.MELEE,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.endure = config.data.levelSpecialUpgrade			if !config.data.randomUpgrades else randi_range(0, 10)
			Global.endureReal = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else Global.endure
		if characterToUse == "blip":
			Players.state = {}
			Players.details = [{
				char = Players.Char.CHEAT,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			
		if characterToUse == ":)":
			Players.state = {}
			Players.details = [{
				char = Players.Char.POINTER,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.detach = config.data.levelSpecialUpgrade			if !config.data.randomUpgrades else randi_range(0, 10)
			Global.detachReal = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else Global.detach
		if characterToUse == "bastion":
			Players.state = {}
			Players.details = [{
				char = Players.Char.LASER,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.torrent = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else randi_range(0, 10)
			Global.torrentReal = config.data.levelSpecialUpgrade	if !config.data.randomUpgrades else Global.torrent
		if characterToUse == "nyx":
			Players.state = {}
			Players.details = [{
				char = Players.Char.MAGE,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.halt = config.data.levelSpecialUpgrade			if !config.data.randomUpgrades else randi_range(0, 10)
			Global.haltReal = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else Global.halt
		if characterToUse == "mebo":
			Players.state = {}
			Players.details = [{
				char = Players.Char.SWARM,
				color = Color.WHITE,
				bgColor = Color.TRANSPARENT,
				colorState = 1,
				skin = ""
			}]
			Global.propagate = config.data.levelSpecialUpgrade		if !config.data.randomUpgrades else randi_range(0, 10)
			Global.propagateReal = config.data.levelSpecialUpgrade	if !config.data.randomUpgrades else Global.propagate
	super()
