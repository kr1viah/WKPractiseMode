extends TitleWindow

@onready var startButton = %Button
@onready var bg2 = $bg2
@onready var bg3 = $bg3
@onready var bg4 = $bg4
@onready var bg5 = $bg5
@onready var bg6 = $bg6
# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.text = "boss"
	startButton.click.connect(ModLoader.get_node("kr1v-practisemode").startEnemyWave, CONNECT_ONE_SHOT)

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func _process(delta):
	point = Utils.lexp(point, get_mouse_position(), 12.0*delta)
	bg.material.set_shader_parameter("point", point)
	bg.material.set_shader_parameter("pos", position+Vector2i(-39, -7))
	bg2.material.set_shader_parameter("point", point)
	bg2.material.set_shader_parameter("pos", position+Vector2i(3, -10))
	bg3.material.set_shader_parameter("point", point)
	bg3.material.set_shader_parameter("pos", position+Vector2i(-23, 37))
	bg4.material.set_shader_parameter("point", point)
	bg4.material.set_shader_parameter("pos", position+Vector2i(16, 62))
	bg5.material.set_shader_parameter("point", point)
	bg5.material.set_shader_parameter("pos", position+Vector2i(55, -13))
	bg6.material.set_shader_parameter("point", point)
	bg6.material.set_shader_parameter("pos", position+Vector2i(65, 30))
	
