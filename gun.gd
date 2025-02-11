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
		
	# 調整 muzzle 位置到槍口前方
	muzzle.position = Vector2(20, 0)

# Shoot bullet
func fire(direction: Vector2) -> void:
	var bullet = BulletScene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.shoot(direction)
	# 將子彈加入到最上層場景
	get_tree().current_scene.add_child(bullet)
