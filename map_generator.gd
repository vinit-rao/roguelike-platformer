extends Node

@export var map_height: int = 5
@export var min_nodes_per_layer: int = 2
@export var max_nodes_per_layer: int = 4

# The physical spacing between dots on the screen
@export var horizontal_spacing: float = 100.0
@export var vertical_spacing: float = 80.0

# This will hold the raw data of our generated map
var map_layers: Array = []
