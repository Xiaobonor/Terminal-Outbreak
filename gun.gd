class_name Gun extends Node2D

# Import bullet
const BulletScene = preload("res://Scenes/bullet.tscn")

@onready var muzzle = $Muzzle

func _ready() -> void:
	if not has_node("Muzzle"):
		var new_muzzle = Node2D.new()
		new_muzzle.name = "Muzzle"
		add_child(new_muzzle)
		muzzle = new_muzzle

# Shoot bullet
func fire(direction: Vector2) -> void:
	print("test")
	var bullet = BulletScene.instantiate()
	# Set bullet position
	bullet.position = muzzle.global_position
	# Shoot bullet
	bullet.shoot(direction)
	# Add bullet to scene tree
	get_tree().get_root().add_child(bullet)
