extends Node3D

var player: Node3D = null
@onready var hearts: GPUParticles3D = %Hearts

@export
var rotationSpeed: float = 0.5

@export
var tamingRadius: float = 5.0

@export
var tamingTime: float = 5.0

var tamed = false

var tamingTimeLeft: float = tamingTime

var y_velocity = 0.0

var jumpingCooldown = 0.0
var initialJumpingCooldown = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		var oldRotation = global_rotation
		look_at(player.global_position, Vector3.UP)
		# global_rotation = lerp(oldRotation, global_rotation, rotationSpeed * delta)
		global_rotation.y = lerp_angle(oldRotation.y, global_rotation.y, rotationSpeed * delta)

		if player.global_position.distance_to(global_position) <= tamingRadius:
			tamingTimeLeft -= delta
			if global_position.y < 0.01 && !tamed && jumpingCooldown <= 0.0:
				y_velocity = player.jumpStrength * 0.7
				jumpingCooldown = initialJumpingCooldown
	
	

	if tamingTimeLeft <= 0:
		tamed = true
	
	if tamed:
		hearts.emitting = true
	
	y_velocity -= player.gravity * delta

	global_position.y += y_velocity * delta
	
	if global_position.y < 0.0:
		global_position.y = 0.0
		y_velocity = max(0.0, y_velocity)
	
	jumpingCooldown -= delta