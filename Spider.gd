extends Node3D

var player: Node3D = null
@onready var hearts: GPUParticles3D = %Hearts

@onready var scary: MeshInstance3D = %Scary
@onready var cute: MeshInstance3D = %Cute

@onready var jump: AudioStreamPlayer3D = %Jump

@export
var rotationSpeed: float = 0.5

@export
var tamingRadius: float = 3.5

@export
var tamingTime: float = 5.0

var tamed = false

var tamingTimeLeft: float = tamingTime

# var y_velocity = 0.0
var velocity = Vector3.ZERO

var jumpingCooldown = 0.0
var initialJumpingCooldown = 0.5

signal justTamed()

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
		global_rotation.x = 0.0

		if player.global_position.distance_to(global_position) <= tamingRadius:
			tamingTimeLeft -= delta
			if global_position.y < 0.01 && !tamed && jumpingCooldown <= 0.0:
				# y_velocity = player.jumpStrength * 0.7
				velocity.y = player.jumpStrength * 0.7
				jump.play()
				jumpingCooldown = initialJumpingCooldown
	
	

	if tamingTimeLeft <= 0 && tamed == false:
		tamed = true
		hearts.emitting = true
		scary.visible = false
		setAlwaysVisible()
		jumpingCooldown = initialJumpingCooldown * 4.0
		rotationSpeed *= 8.0
		justTamed.emit()
	
	
	if tamed && jumpingCooldown <= 0.0 && global_position.y < 0.01:
		# velocity.y = player.jumpStrength
		jumpingCooldown = initialJumpingCooldown * 4.0
		velocity = (player.global_position - global_position).normalized() * player.jumpStrength * 0.8
		# velocity.x += (randf_range(-0.2, 0.2))
		# velocity.z += (randf_range(-0.2, 0.2)) 
		velocity += Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized() * 0.3
		velocity.y = player.jumpStrength * 0.8
		jump.play()

	
	velocity.y -= player.gravity * delta

	global_position += velocity * delta
	
	if global_position.y < 0.0:
		global_position.y = 0.0
		velocity.y = max(0.0, velocity.y)
	
	if jumpingCooldown > 0.0 && global_position.y < 0.01:
		velocity.x *= 0.2 * delta
		velocity.z *= 0.2 * delta
	
	jumpingCooldown -= delta

func setAlwaysVisible():
	for i in 9:
		# (cute.get_surface_override_material(i) as ShaderMaterial).set_shader_parameter("MinAlpha", 1)
		var duplicateMaterial: ShaderMaterial = cute.get_surface_override_material(i).duplicate()
		duplicateMaterial.set_shader_parameter("MinAlpha", 1)
		cute.set_surface_override_material(i, duplicateMaterial)