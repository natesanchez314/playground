extends KinematicBody

export var speed = 10
export var acceleration = 5
export var attack_damage = 1
export var gravity = 0.98

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer

enum {
	IDLE,
	WANDER,
	INVESTIGATE,
	ATTACK
}

var state = INVESTIGATE
var velocity = Vector3.ZERO

const EnemyEcho = preload("res://Effects/EnemyEcho.tscn")

func _physics_process(delta):
	animationTree.set("parameters/Idle/blend_position", Vector3(-1, -1, -1))
	match state:
		IDLE:
			idle()
		WANDER:
			wander(delta)
		INVESTIGATE:
			investigate(delta)
		ATTACK:
			attack()
	
func idle():
	pass

func wander(delta):
	pass
	
func investigate(delta):
	var player = get_parent().get_node("Player")
	var targetPos = player.global_transform.origin
	targetPos.y = 1
	look_at(targetPos, Vector3(0, 1, 0))
	#var dir = Vector3.ZERO
	#var localBasis = get_global_transform().basis
	#dir -= localBasis.z
	#dir = dir.normalized()
	#velocity = velocity.linear_interpolate(dir * speed, acceleration * delta)
	#print(velocity)
	#velocity.y -= gravity
	#velocity = move_and_slide(velocity)
	
func attack():
	pass

func create_small_sound_wave():
	pass
	
func create_medium_sound_wave():
	var enemyEcho = EnemyEcho.instance()
	get_parent().add_child(enemyEcho)
	enemyEcho.set_rates(5, Vector3(.1, .1, .1))
	enemyEcho.global_transform = global_transform
	
func create_large_sound_wave():
	pass 
	
