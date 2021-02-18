extends Spatial

export var GROW_RATE = 5
export var size = Vector3(1, 1, 1)
export var INTENSITY = 2
export var EDGE_DECAY = .04
onready var meshInst = $MeshInstance
onready var mat = meshInst.get_surface_material(0)

func set_rates(gr, s):
	GROW_RATE = gr
	size = s

func _process(delta):
	if INTENSITY < 0.01:
		queue_free()
	size = size + Vector3(GROW_RATE, GROW_RATE, GROW_RATE) * delta
	meshInst.scale = size
	INTENSITY -= EDGE_DECAY
	mat.set_shader_param("edge_intensity", INTENSITY)

func _on_Timer_timeout():
	pass
	#queue_free()
