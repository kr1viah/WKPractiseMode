extends TitleWindow

@onready var startButton = %Button
# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.text = "boss"
	startButton.click.connect(ModLoader.get_node("kr1v-practisemode").startUltraVirusFight, CONNECT_ONE_SHOT)

## Called every frame. 'delta' is the elapsed time since the previous frame.
