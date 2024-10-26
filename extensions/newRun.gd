extends "res://src/title/panel/newRun.gd"

func _ready():
	super._ready()
	button.click.connect(func():
		Global.title.switch(self)
		var win = Utils.find(Global.title.windows.values(), func(v):
			return v.window == self)
		var oldChild = win.childrenIds
		print_debug(oldChild)
		Global.title.split(self, [preload("res://mods-unpacked/kr1v-practisemode/practisemode.tscn")])
		print_debug(win.childrenIds)
		win.childrenIds += oldChild
		print_debug(win.childrenIds)
	)
