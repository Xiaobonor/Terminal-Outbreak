extends Node2D

# 預載入殭屍場景，請確認路徑正確
const ZombieScene = preload("res://Scenes/zombie1.tscn")

func _ready() -> void:
	# 遊戲載入完成後生成 3 隻殭屍
	for i in range(30):
		var zombie_instance = ZombieScene.instantiate()
		# 設定殭屍初始生成位置，這裡以固定間隔為例，
		# 根據需求你也可以使用隨機座標或其他生成邏輯
		zombie_instance.position = Vector2(100 + i * 150, 200)
		add_child(zombie_instance)
		print("生成殭屍 ", i + 1)
