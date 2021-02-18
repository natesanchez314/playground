extends RigidBody

const EchoEffect = preload("res://Effects/EchoEffect.tscn")
var echoing = false

func _process(_delta):
	if mode != 0:
		mode = 0
		
func _on_Box_body_entered(body):
	if !echoing:
		var echoEffect = EchoEffect.instance()
		add_child(echoEffect)
		echoing = true
		yield(get_tree().create_timer(1), "timeout")
		echoing = false
