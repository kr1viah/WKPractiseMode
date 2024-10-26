extends TitleWindow

@onready var button = %Button

func _ready():
	button.text = "practise"
	button.click.connect(func():
		Players.state = {}
		Players.timedMode = false
		Players.challengeMode = false
		
		Global.title.switch(self)
		Global.title._charId = 0
		Global.title.split(self, [preload("res://mods-unpacked/kr1v-practisemode/windows/ultravirus/ultraviruswindow.tscn"), preload("res://mods-unpacked/kr1v-practisemode/windows/boss/bosswindow.tscn"), preload("res://mods-unpacked/kr1v-practisemode/windows/enemy/enemywindow.tscn")])
	)
