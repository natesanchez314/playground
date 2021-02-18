extends KinematicBody

export var sneak_speed = 5
export var walk_speed = 10
export var run_speed = 15
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3
export var min_pitch = -90
export var max_pitch = 90

onready var head = $Head
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast
onready var whistleSound = $WhistleSound

enum {
	SNEAK,
	WALK,
	RUN
}

var velocity = Vector3.ZERO
var camera_x_rotation = 0
var speed = walk_speed
var state = WALK
var holding = false
var held_object

const StepEffect = preload("res://Effects/EchoEffect.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, min_pitch, max_pitch)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	handle_movement(delta)
	interact()
	if Input.is_action_just_pressed("whistle"):
		whistle()
	
func handle_movement(delta):
	var head_basis = head.get_global_transform().basis
	var dir = Vector3.ZERO 
	if Input.is_action_pressed("move_forward"):
		dir -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		dir += head_basis.z
	if Input.is_action_pressed("move_left"):
		dir -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		dir += head_basis.x
	dir = dir.normalized()
	velocity = velocity.linear_interpolate(dir * speed, acceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	velocity = move_and_slide(velocity, Vector3.UP)
	
func whistle():
	whistleSound.play()
	var stepEffect = StepEffect.instance()
	stepEffect.set_rates(5, Vector3(2, 2, 2))
	get_parent().add_child(stepEffect)
	stepEffect.global_transform = global_transform
	
func interact():
	if Input.is_action_just_pressed("interact"):
		if !holding:
			if raycast.is_colliding():
				var interactable_object = raycast.get_collider()
				var collision_point = raycast.get_collision_point()
				if interactable_object.get_collision_layer() == 4:
					# the object is grabbable
					held_object = interactable_object
					get_parent().remove_child(held_object)
					camera.add_child(held_object)
					#add_child(interactable_object)
					held_object.transform.origin = Vector3(0, 0, -5)
					held_object.set_sleeping(false)
					holding = true
				elif interactable_object.get_collision_layer() == 5:
					# the object is interactable but not grabbable
					pass
		else:
			var new_transform = held_object.global_transform
			held_object.get_parent().remove_child(held_object)
			get_parent().add_child(held_object)
			held_object.transform.origin = Vector3.ZERO
			held_object.global_transform = new_transform
			held_object.set_sleeping(false)
			holding = false
