extends Node

@onready var spiders: Node3D = %Spiders
@onready var player: Node3D = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for spider in spiders.get_children():
		spider.player = player