extends Area2D

@export var bullet_speed: float = 400.0 # Bullet speed
@export var damage: int = 25           # 子彈傷害值
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 連接碰撞信號
	body_entered.connect(_on_body_entered)

func shoot(direction: Vector2) -> void:
	velocity = direction.normalized() * bullet_speed

func _physics_process(delta: float) -> void:
	position += velocity * delta
	# If the bullet is out of the screen, destroy it
	if not get_viewport_rect().has_point(position):
		queue_free()

# 當子彈碰到其他物體時
func _on_body_entered(body: Node2D) -> void:
	if body is Zombie:  # 檢查是否擊中殭屍
		body.take_damage(damage)
		queue_free()  # 子彈消失
