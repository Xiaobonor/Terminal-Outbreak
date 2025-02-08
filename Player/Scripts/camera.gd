class_name PlayerCamera extends Camera2D

@export var tilemap_layer: TileMapLayer

func _ready():
	LevelManager.TileMapBoundsChanged.connect( UpdateLimits )
	UpdateLimits( LevelManager.current_tilemap_bounds )
	pass

func UpdateLimits( bounds : Array[  Vector2 ]) -> void:
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass
