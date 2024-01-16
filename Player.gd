extends Node3D


@onready var camera: Camera3D = %Camera
@onready var footstep: AudioStreamPlayer = %Footstep

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

@export
var sprintMultiplier: float = 2.0

signal newPositionOnGrid(position: Vector2i)

const GRID_SIZE: int = 10

var lastStepPosition: Vector3 = Vector3.ZERO
var stepCooldown: float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var moveDir = Vector3.ZERO

	if Input.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		# get_tree().quit()

	if Input.is_action_pressed("move_forward"):
		moveDir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		moveDir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		moveDir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		moveDir += transform.basis.x
	
	moveDir = moveDir.normalized()

	if Input.is_action_pressed("sprint"):
		moveDir *= sprintMultiplier

	if Input.is_action_just_pressed("jump") && global_position.y < 0.01:
		velocity.y = jumpStrength



	velocity.x = lerp(velocity.x, moveDir.x * moveSpeed, acceleration * delta)
	velocity.z = lerp(velocity.z, moveDir.z * moveSpeed, acceleration * delta)

	velocity.y -= gravity * delta

	global_position += velocity * delta
	
	if global_position.y < 0.0:
		global_position.y = 0.0
		velocity.y = max(0.0, velocity.y)
	
	if global_position.y <= 0.01:
		if lastStepPosition.distance_to(global_position) > 2.0:
			footstep.play()
			lastStepPosition = global_position

	var gridPos = Vector2i(floor(global_position.x / GRID_SIZE), floor(global_position.z / GRID_SIZE))
	newPositionOnGrid.emit(gridPos)

@export
var mouseSensitivity: float = 0.1

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouseEvent = event as InputEventMouseMotion
		rotate_y(deg_to_rad(-mouseEvent.relative.x * mouseSensitivity))
		camera.rotate_x(deg_to_rad(-mouseEvent.relative.y * mouseSensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	
	if event is InputEventMouseButton && Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		var mouseEvent = event as InputEventMouseButton
		if mouseEvent.button_mask == MOUSE_BUTTON_MASK_LEFT:
			var windowSize = get_viewport().get_visible_rect().size
			var mousePos = mouseEvent.position
			if mousePos.x > 0 && mousePos.x < windowSize.x && mousePos.y > 0 && mousePos.y < windowSize.y:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		