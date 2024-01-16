extends Node

var spiderScene := preload("res://Models/Spider.tscn")

@onready var spiders: Node3D = %Spiders
@onready var player: Node3D = %Player
@onready var basePlane: MeshInstance3D = %BasePlane

var totalSpiderCount: int = 20
var tamedSpiderCount: int = 0

# Called when the node enters the scene tree for the first time.
const SPIDER_SPAWN_RANGE = 75
const MIN_SPIDER_DISTANCE = 10
func _ready():
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

func handleSpiderTaming():
	tamedSpiderCount += 1
	var tamedRatio = tamedSpiderCount / float(totalSpiderCount)

	(basePlane.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("MixWeight", tamedRatio)