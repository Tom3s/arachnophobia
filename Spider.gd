extends Node3D

var player: Node3D = null

@export
var rotationSpeed: float = 0.5

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
