extends Node3D


@onready var camera: Camera3D = %Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var velocity = Vector3.ZERO

@export 
var moveSpeed: float = 10.0

@export
var acceleration: float = 0.8

@export
var jumpStrength: float = 10.0

@export
var gravity: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var moveDir = Vector3.ZERO

	if Input.is_action_pressed("exit"):
		# Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

	if Input.is_action_pressed("move_forward"):
		moveDir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		moveDir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		moveDir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		moveDir += transform.basis.x
	
	moveDir = moveDir.normalized()

	if Input.is_action_just_pressed("jump") && position.y < 0.01:
		velocity.y = jumpStrength



	velocity.x = lerp(velocity.x, moveDir.x * moveSpeed, acceleration * delta)
	velocity.z = lerp(velocity.z, moveDir.z * moveSpeed, acceleration * delta)

	velocity.y -= gravity * delta

	position += velocity * delta
	
	if position.y < 0.0:
		position.y = 0.0
		velocity.y = max(0.0, velocity.y)

@export
var mouseSensitivity: float = 0.1

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouseEvent = event as InputEventMouseMotion
		rotate_y(deg_to_rad(-mouseEvent.relative.x * mouseSensitivity))
		camera.rotate_x(deg_to_rad(-mouseEvent.relative.y * mouseSensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	
		