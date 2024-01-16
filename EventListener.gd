extends Node

@onready var spiders: Node3D = %Spiders
@onready var player: Node3D = %Player
@onready var basePlane: MeshInstance3D = %BasePlane

# Called when the node enters the scene tree for the first time.
func _ready():
	for spider in spiders.get_children():
		spider.player = player
	
	player.newPositionOnGrid.connect(func(pos: Vector2i):
		basePlane.global_position = Vector3(pos.x * player.GRID_SIZE, 0, pos.y * player.GRID_SIZE)
		(basePlane.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("UVOffset", Vector2(pos.x / 10.0, pos.y / 10.0))
	)
