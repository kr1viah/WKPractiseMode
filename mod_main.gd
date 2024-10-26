extends Node

const AUTHORNAME_MODNAME_DIR := "kr1v-practisemode" # Name of the directory that this file is in
const AUTHORNAME_MODNAME_LOG_NAME := "kr1v-practisemode:Main" # Full ID of the mod (AuthorName-ModName)

signal apply_config(config:ModConfig)
signal disable()

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""
var config
var inUltraFightPractise
var inEnemyOrBossPractise
var bossesKilled = 0
var bossesSpawned = 0
var characterToUse
var actualCharacterToUse

var bosses = [{name = "spiker", path = "res://src/enemy/boss1/boss1.tscn"}, 
{name = "wyrm", path = "res://src/enemy/boss_snake/bossSnake.tscn"},
{name = "slimest", path = "res://src/enemy/boss_slime/bossSlime.tscn"},
{name = "smiley", path = "res://src/enemy/boss_virus/bossVirus.tscn"},
{name = "orb array", path = "res://src/enemy/boss_orb/bossOrb.tscn"},
{name = "miasma", path = "res://src/enemy/germSource/germ_source.tscn"}]
var everyBoss = []
func _init() -> void:
	for boss in bosses:
		everyBoss.append(boss.name)
	everyBoss.append("none")
	everyBoss.append("random")
	ModLoaderLog.info("Init", AUTHORNAME_MODNAME_LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(AUTHORNAME_MODNAME_DIR)
	install_script_extensions()

func install_script_extensions() -> void:
	# ! any script extensions should go in this directory, and should follow the same directory structure as vanilla
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension("res://mods-unpacked/kr1v-practisemode/extensions/newRun.gd")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("src/enemy/boss_virus_ultra/bossVirusUltra.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("src/main/main.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("src/enemy/boss_germ/bossGerm.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("src/autoload/stats.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("src/autoload/unlocks.gd"))

func _ready() -> void:
	#var res = FileAccess.open("res://mods-unpacked/kr1v-practisemode/manifest.json", FileAccess.READ_WRITE)
	#var file = JSON.parse_string(res.get_as_text())
	
	#file.extra.godot.config_schema.properties.bossFirst.enum = []
	#for boss in bosses:
		##var string = '"' + boss.name + '"' + ", "
		#file.extra.godot.config_schema.properties.bossFirst.enum.append(boss.name)
		#file.extra.godot.config_schema.properties.bossSecond.enum.append(boss.name)
		#file.extra.godot.config_schema.properties.bossThird.enum.append(boss.name)
		##file.insert(file.find("none", file.find("bossFirst")) - 1, string)
		##file.insert(file.find("none", file.find("bossSecond")) - 1, string)
		##file.insert(file.find("none", file.find("bossThird")) - 1, string)
	#file.extra.godot.config_schema.properties.bossFirst.enum.append("none")
	#file.extra.godot.config_schema.properties.bossFirst.enum.append("random")
	#file.extra.godot.config_schema.properties.bossSecond.enum.append("none")
	#file.extra.godot.config_schema.properties.bossSecond.enum.append("random")
	#file.extra.godot.config_schema.properties.bossThird.enum.append("none")
	#file.extra.godot.config_schema.properties.bossThird.enum.append("random")
	#print_debug(file)
	#var exepath = OS.get_executable_path()
#
	#res.store_string(JSON.stringify(file))
	process_mode = Node.PROCESS_MODE_ALWAYS
	config = ModLoaderConfig.get_current_config("kr1v-practisemode")
	ModLoaderLog.info("Ready", AUTHORNAME_MODNAME_LOG_NAME)
	ModLoader.current_config_changed.connect(_on_current_config_changed)

func _on_current_config_changed(config: ModConfig) -> void:
	if config.mod_id == "kr1v-autosplitter":
		print_debug("config changes")
		apply_config.emit(config)

func startEnemyWave():
	currentStats = Stats.stats.duplicate()
	currentMetaStats = Stats.metaStats.duplicate()
	currentRecords = Stats.records.duplicate()
	inEnemyOrBossPractise = true
	Global.title.startGame()
	Events.runStarted.connect(runStartedEnemy)
	Events.titleReturn.connect(discconectrunStartedEnemy, CONNECT_ONE_SHOT)
	Events.runEnded.connect(runEndedBossFight)

func enemySpawnedEnemy(node):
	print_debug(Global.main.waveTimer)
	Global.main.waveTimer = -10.0
	Utils.runLaterFrames(3, notRandomWavesEnemy)
	Utils.runLaterFrames(5, func(): Global.main.waveTimer = 9999)
func notRandomWavesEnemy():
	if config.data.waveType != "random":
		Global.main.enemySelection[0].waveWeight = 1.0 if config.data.waveType == "triangle" else 0.0
		Global.main.enemySelection[1].waveWeight = 1.0 if config.data.waveType == "square" else 0.0
		Global.main.enemySelection[2].waveWeight = 1.0 if config.data.waveType == "circle" else 0.0
		Global.main.enemySelection[3].waveWeight = 1.0 if config.data.waveType == "hexagon" else 0.0
		Global.main.enemySelection[4].waveWeight = 1.0 if config.data.waveType == "heptagon" else 0.0
		Global.main.enemySelection[5].waveWeight = 1.0 if config.data.waveType == "splitter" else 0.0
		Global.main.enemySelection[6].waveWeight = 1.0 if config.data.waveType == "sweeper" else 0.0
		Global.main.enemySelection[7].waveWeight = 1.0 if config.data.waveType == "tunneller" else 0.0
		Global.main.enemySelection[8].waveWeight = 1.0 if config.data.waveType == "arrow" else 0.0
func runStartedEnemy():
	Events.enemySpawned.connect(enemySpawnedEnemy, CONNECT_ONE_SHOT)
	Global.gameTime = 1200.0
	Global.difficultyScale = randf_range(1, 20)
	Global.main.waveTimer = 0
	Global.peer = 			config.data.levelPeer 				if !config.data.randomUpgrades else randi_range(0, 10)
	Global.drain = 			config.data.levelDrain  			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.speed = 			config.data.amountOfSpeed 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.fireRate = 		config.data.amountOfFireRate 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.multiShot = 		config.data.amountOfMultiShot 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.wealth = 		config.data.amountOfWealth 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.freezing = 		config.data.amountOfFreezing 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.splashDamage = 	config.data.amountOfSplashDamage	if !config.data.randomUpgrades else randi_range(0, 10)
	Global.piercing = 		config.data.amountOfPiercing 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.infection =	 	config.data.amountOfPoison 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.wallPunch =		config.data.amountOfWallPunch		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.maxHealth = 		config.data.amountOfMaxHealth 		if !config.data.randomUpgrades else randi_range(1, 5)*10
	Global.health = 		Global.maxHealth

	print_debug(Global.player.char)
func discconectrunStartedEnemy():
	inEnemyOrBossPractise = false
	Events.runStarted.disconnect(runStartedBossFight)
	Events.enemySpawned.disconnect(enemySpawnedEnemy)
	Events.runEnded.disconnect(runEndedBossFight)

func startBossFight():
	currentStats = Stats.stats.duplicate()
	currentMetaStats = Stats.metaStats.duplicate()
	currentRecords = Stats.records.duplicate()
	inEnemyOrBossPractise = true
	Global.title.startGame()
	Events.bossKilled.connect(bossKilled)
	Events.runStarted.connect(runStartedBossFight)
	Events.titleReturn.connect(discconectrunStartedBoss, CONNECT_ONE_SHOT)
	Events.runEnded.connect(runEndedBossFight)
func discconectrunStartedBoss():
	inEnemyOrBossPractise = false
	Events.bossKilled.disconnect(bossKilled)
	Events.runStarted.disconnect(runStartedBossFight)
	Events.runEnded.disconnect(runEndedBossFight)
func bossKilled(node:Node):
	print_debug("epsroigspofgserpoijgosg")
	bossesKilled += 1
	if bossesKilled >= bossesSpawned && config.data.autoRestart:
		Utils.runLaterFrames(10, func(): 
			Global.dead = true
			Utils.runLaterFrames(80, Global.main.closeGameOver)
			)

func runStartedBossFight():
	Global.difficultyScale = randf_range(1, 20)
	bossesSpawned = 0
	bossesKilled = 0
	#if config.data.bossFirst == "spiker":
		#Global.main.bossQueue = [load("res://src/enemy/boss1/boss1.tscn")]
	#elif config.data.bossFirst == "wyrm":
		#Global.main.bossQueue = [load("res://src/enemy/boss_snake/bossSnake.tscn")]
	#elif config.data.bossFirst == "slimest":
		#Global.main.bossQueue = [load("res://src/enemy/boss_slime/bossSlime.tscn")]
	#elif config.data.bossFirst == "smiley":
		#Global.main.bossQueue = [load("res://src/enemy/boss_virus/bossVirus.tscn")]
	#elif config.data.bossFirst == "orb array":
		#Global.main.bossQueue = [load("res://src/enemy/boss_orb/bossOrb.tscn")]
	#elif config.data.bossFirst == "miasma":
		#Global.main.bossQueue = [load("res://src/enemy/germSource/germ_source.tscn")]
	#elif config.data.bossFirst == "random":
		#var j = randi_range(1, 7)
		#if j == 1: Global.main.bossQueue = [load("res://src/enemy/boss1/boss1.tscn")]
		#elif j == 2: Global.main.bossQueue = [load("res://src/enemy/boss_snake/bossSnake.tscn")]
		#elif j == 3: Global.main.bossQueue = [load("res://src/enemy/boss_slime/bossSlime.tscn")]
		#elif j == 4: Global.main.bossQueue = [load("res://src/enemy/boss_virus/bossVirus.tscn")]
		#elif j == 5: Global.main.bossQueue = [load("res://src/enemy/boss_orb/bossOrb.tscn")]
		#elif j == 6: Global.main.bossQueue = [load("res://src/enemy/germSource/germ_source.tscn")]
		#elif j == 7: i = true
	#elif config.data.bossFirst == "none":
		#Global.main.bossQueue = []
		#i = true
#var bosses = [{name = "spiker", path = "res://src/enemy/boss1/boss1.tscn"}, 
#{name = "wyrm", path = "res://src/enemy/boss_snake/bossSnake.tscn"},
#{name = "slimest", path = "res://src/enemy/boss_slime/bossSlime.tscn"},
#{name = "smiley", path = "res://src/enemy/boss_virus/bossVirus.tscn"},
#{name = "orb array", path = "res://src/enemy/boss_orb/bossOrb.tscn"},
#{name = "miasma", path = "res://src/enemy/germSource/germ_source.tscn"}]
	var i = false
	if config.data.dynamicbossFirst == "random":
		Global.main.bossQueue= [load(bosses[randi_range(0, bosses.size()-1)].path)]
	elif config.data.dynamicbossFirst == "none":
		i = true
		Global.main.bossQueue = []
	else: for boss in bosses:
		if config.data.dynamicbossFirst == boss.name:
			Global.main.bossQueue = [load(boss.path)]
	if !i:
		Utils.runLaterFrames(5, func(): Global.main.spawnBoss())
		bossesSpawned += 1
	i = false
	if config.data.dynamicbossSecond == "random":
		Global.main.bossQueue.append(load(bosses[randi_range(0, bosses.size()-1)].path))
	elif config.data.dynamicbossSecond == "none":
		i = true
	else: for boss in bosses:
		if config.data.dynamicbossSecond == boss.name:
			Global.main.bossQueue.append(load(boss.path))
	if !i:
		Utils.runLaterFrames(5, func(): Global.main.spawnBoss())
		bossesSpawned += 1
	i = false
	if config.data.dynamicbossThird == "random":
		Global.main.bossQueue.append(load(bosses[randi_range(0, bosses.size()-1)].path))
	elif config.data.dynamicbossThird == "none":
		i = true
	else: for boss in bosses:
		if config.data.dynamicbossThird == boss.name:
			Global.main.bossQueue.append(load(boss.path))
	if !i:
		Utils.runLaterFrames(5, func(): Global.main.spawnBoss())
		bossesSpawned += 1
	i = false

	Global.main.debug_noSpawn = !config.data.bossSpawnEnemies

	Global.speed = 			config.data.amountOfSpeed 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.fireRate = 		config.data.amountOfFireRate 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.multiShot = 		config.data.amountOfMultiShot 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.wealth = 		config.data.amountOfWealth 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.maxHealth = 		config.data.amountOfMaxHealth 		if !config.data.randomUpgrades else randi_range(1, 5)*10
	Global.health = 		Global.maxHealth
	Global.freezing = 		config.data.amountOfFreezing 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.splashDamage = 	config.data.amountOfSplashDamage	if !config.data.randomUpgrades else randi_range(0, 10)
	Global.piercing = 		config.data.amountOfPiercing 		if !config.data.randomUpgrades else randi_range(0, 10)
	Global.infection =	 	config.data.amountOfPoison 			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.peer = 			config.data.levelPeer 				if !config.data.randomUpgrades else randi_range(0, 10)
	Global.drain = 			config.data.levelDrain  			if !config.data.randomUpgrades else randi_range(0, 10)
	Global.wallPunch =		config.data.amountOfWallPunch		if !config.data.randomUpgrades else randi_range(0, 10)

func runEndedBossFight():
	if config.data.autoRestart:
		Utils.runLaterFrames(60, func(): get_tree().change_scene_to_file("res://src/main/main.tscn"))

func startUltraVirusFight():
	inUltraFightPractise = true
	currentStats = Stats.stats.duplicate()
	currentMetaStats = Stats.metaStats.duplicate()
	currentRecords = Stats.records.duplicate()
	print_debug("AUHAOEIUHFOIUEahfuie")
	Players.details = [{
		char = Players.Char.MELEE,
		color = Color.WHITE,
		bgColor = Color.TRANSPARENT,
		colorState = 1,
		skin = ""
	}]
	Global.title.startGame()
	Events.runStarted.connect(runStartedUltraVirusFight)
	Events.titleReturn.connect(discconectrunStartedUltraVirus, CONNECT_ONE_SHOT)
	Events.runEnded.connect(runEndedUltraVirusFight)

func discconectrunStartedUltraVirus():
	inUltraFightPractise = false
	Events.runStarted.disconnect(runStartedUltraVirusFight)
	Events.runEnded.disconnect(runEndedUltraVirusFight)
func runEndedUltraVirusFight():
	if Global.main && config.data.autoRestart:
		Utils.runLaterFrames(20, Global.main.closeGameOver)
func runStartedUltraVirusFight():
	print_debug("eawdwd")
	if config.data.endureEnabled:
		Global.endure = 1
		Global.endureReal = 1
	else:
		Global.endure = 0
		Global.endureReal = 0
	Global.health = config.data.healthAmount
	Global.maxHealth = config.data.healthAmount
	if config.data.resetOnHit:
		Global.health = 0
		Global.maxHealth = 0
	Global.speed = config.data.speedAmount
	Global.ultraUpgrade = true
	Global.main.breakWindow(Vector2(0, 0))
	Global.player.position = Vector2(0, 0)
	Global.player.char = Players.Char.BASIC
	Global.player.ability = Players.Ability.endure

var currentStats = []
var currentMetaStats = []
var currentRecords = []

func _process(delta):
	if inUltraFightPractise or inEnemyOrBossPractise:
		Stats.records = currentRecords.duplicate()
		Stats.stats = currentStats.duplicate()
		Stats.metaStats = currentMetaStats.duplicate()
	everyBoss = []
	for boss in bosses:
		everyBoss.append(boss.name)
	everyBoss.append("none")
	everyBoss.append("random")
