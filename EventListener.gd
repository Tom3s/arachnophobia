extends Node

var spiderScene := preload("res://Models/Spider.tscn")

@onready var spiders: Node3D = %Spiders
@onready var player: Node3D = %Player
@onready var basePlane: MeshInstance3D = %BasePlane
@onready var worldEnvironment: WorldEnvironment = %WorldEnvironment

var totalSpiderCount: int = 3
var tamedSpiderCount: int = 0

# Called when the node enters the scene tree for the first time.
const SPIDER_SPAWN_RANGE = 75
const MIN_SPIDER_DISTANCE = 10
func _ready():
	tamedSpiderCount = -1
	handleSpiderTaming()
	# for spider in spiders.get_children():
	# 	spider.player = player
	var spawnedSpiders := 0
	var occupiedPositions: PackedVector3Array = PackedVector3Array()
	while spawnedSpiders < totalSpiderCount:
		var spider := spiderScene.instantiate()
		spider.player = player
		spiders.add_child(spider)
		spider.justTamed.connect(handleSpiderTaming)

		while true:
			var newPosition = Vector3((randf() * 2 - 1) * SPIDER_SPAWN_RANGE, 0, (randf() * 2 - 1) * SPIDER_SPAWN_RANGE)
			var tooClose := false
			for position in occupiedPositions:
				if newPosition.distance_to(position) < MIN_SPIDER_DISTANCE:
					tooClose = true
					break
			if !tooClose:
				spider.global_position = newPosition
				occupiedPositions.append(spider.global_position)
				spawnedSpiders += 1
				break

	
	player.newPositionOnGrid.connect(func(pos: Vector2i):
		basePlane.global_position = Vector3(pos.x * player.GRID_SIZE, 0, pos.y * player.GRID_SIZE)
		(basePlane.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("UVOffset", Vector2(pos.x / 20.0, pos.y / 20.0))
	)

var tamedSkyColor = Color.from_string("#8c95a3", Color(0, 0, 0, 0))

func handleSpiderTaming():
	tamedSpiderCount += 1
	var tamedRatio = tamedSpiderCount / float(totalSpiderCount)

	(basePlane.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("MixWeight", tamedRatio)
	(worldEnvironment.environment.sky.sky_material as ShaderMaterial).set_shader_parameter("MixWeight", tamedRatio)

	worldEnvironment.environment.fog_density = lerp(0.07, 0.0, tamedRatio)
	worldEnvironment.environment.fog_sky_affect = lerp(1.0, 0.0, tamedRatio)
	worldEnvironment.environment.fog_light_energy = lerp(1.0, 0.0, tamedRatio)
	worldEnvironment.environment.fog_light_color = lerp(Color(0.05, 0.05, 0.05, 0), tamedSkyColor, tamedRatio)