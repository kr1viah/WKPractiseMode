extends "res://src/enemy/boss_germ/bossGerm.gd"

func kill(soft := false, noStat := false):
	Events.bossKilled.emit(self)
	super(soft, noStat)
