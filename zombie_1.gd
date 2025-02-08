# 我將依照google的最佳實踐和規範來生成代碼
extends CharacterBody2D
class_name Zombie1

#===========================
# 參數設定
#===========================
@export var speed: float = 65.0            # 移動速度
@export var max_hp: int = 100               # 最大血量
var current_hp: int = max_hp               # 當前血量

@export var attack_range: float = 50.0      # 攻擊範圍 (以像素計)
@export var attack_damage: int = 20         # 攻擊傷害值
@export var attack_cooldown: float = 1.5    # 攻擊間隔秒數
var attack_timer: float = 0.0              # 攻擊計時器

var player: Node2D = null                  # 玩家參考 (請確保玩家已加入 "Player" 群組)
var is_hurting: bool = false               # 是否正在播放受傷動畫
var base_scale: float = 0.33743            # 保存原始縮放值

# 取得 AnimatedSprite2D 節點
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#===========================
# 生命週期函式
#===========================
func _ready() -> void:
	print("殭屍初始化")
	# 保存原始縮放值
	base_scale = animated_sprite.scale.x
	# 嘗試取得玩家節點（請確保玩家已加入 "Player" 群組）
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		print("找不到玩家節點！")
	
	# 確保 AnimatedSprite2D 存在
	if animated_sprite:
		print("找到 AnimatedSprite2D 節點")
		# 連結動畫結束信號
		if not animated_sprite.animation_finished.is_connected(_on_AnimatedSprite2D_animation_finished):
			animated_sprite.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
			print("成功連接動畫結束信號")
	else:
		print("錯誤：找不到 AnimatedSprite2D 節點！")

func _physics_process(delta: float) -> void:
	if current_hp <= 0:
		return  # 已死亡，停止任何行為

	# 更新攻擊計時器
	attack_timer -= delta

	if player and not is_hurting:  # 只有在不是受傷狀態時才更新動畫
		# 計算玩家與殭屍之間的向量與距離
		var to_player: Vector2 = player.global_position - global_position
		var distance_to_player: float = to_player.length()
		
		# 根據移動方向設置朝向，保持原始縮放值
		if to_player.x != 0:
			animated_sprite.scale.x = base_scale * (-1 if to_player.x < 0 else 1)
		
		if distance_to_player > attack_range:
			# 玩家不在攻擊範圍內：播放 walk 動畫並向玩家移動
			animated_sprite.play("walk")
			velocity = to_player.normalized() * speed
			move_and_slide()
		else:
			# 玩家進入攻擊範圍：停止移動、播放 attack 動畫並執行攻擊
			velocity = Vector2.ZERO
			animated_sprite.play("attack")
			if attack_timer <= 0.0:
				attack_player()
				attack_timer = attack_cooldown

#===========================
# 攻擊玩家
#===========================
func attack_player() -> void:
	# 假設玩家有實作 take_damage 方法
	if player and player.has_method("take_damage"):
		player.take_damage(attack_damage)
		print("殭屍攻擊玩家，造成 ", attack_damage, " 點傷害")
	else:
		print("玩家未實作 take_damage 方法！")

#===========================
# 受到傷害
#===========================
func take_damage(damage: int) -> void:
	if current_hp <= 0:
		return  # 已死亡不再處理傷害
	current_hp -= damage
	if current_hp > 0:
		print("殭屍受傷，剩餘血量：", current_hp)
		# 設置為不循環播放
		is_hurting = true  # 設置受傷狀態
		animated_sprite.sprite_frames.set_animation_loop("hurt", false)
		animated_sprite.play("hurt")
	else:
		die()

#===========================
# 死亡處理
#===========================
func die() -> void:
	print("殭屍死亡開始")
	# 停止所有移動
	velocity = Vector2.ZERO
	# 停用碰撞，避免與其他物件互動
	set_collision_layer(0)
	set_collision_mask(0)
	# 播放死亡動畫（只播放一次）
	if animated_sprite:
		print("播放死亡動畫")
		# 設置為不循環播放
		animated_sprite.sprite_frames.set_animation_loop("dead", false)
		animated_sprite.play("dead")
	else:
		print("錯誤：無法播放死亡動畫，直接刪除")
		queue_free()

# 當動畫播放完成時調用
func _on_AnimatedSprite2D_animation_finished() -> void:
	print("動畫播放完成：", animated_sprite.animation)
	if animated_sprite.animation == "dead":
		print("殭屍死亡動畫播放完成，移除實例")
		queue_free()  # 移除殭屍節點
	elif animated_sprite.animation == "hurt":
		is_hurting = false  # 重置受傷狀態
		# 受傷動畫播放完後，根據與玩家的距離決定回到什麼狀態
		if player:
			var distance = global_position.distance_to(player.global_position)
			if distance > attack_range:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("attack")
