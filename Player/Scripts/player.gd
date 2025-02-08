class_name Player extends CharacterBody2D

# Gun position offsets for different directions
const GUN_OFFSET_SIDE := Vector2(10, 0)  # Adjusted to align with side view hand
const GUN_OFFSET_UP := Vector2(0, -10)  # Adjusted to align with back view hand 
const GUN_OFFSET_DOWN := Vector2(6, 4)  # Adjusted to align with front view hand

@export var max_hp: int = 100               # 最大血量
var current_hp: int = max_hp               # 當前血量

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var gun: Gun = $Gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	
	# Set initial gun position
	gun.position = GUN_OFFSET_DOWN
	gun.scale.x = 1
	gun.rotation = PI/2

# 受到傷害
func take_damage(damage: int) -> void:
	if current_hp <= 0:
		return  # 已死亡不再處理傷害
	current_hp -= damage
	print("玩家受到傷害：", damage, "，剩餘血量：", current_hp)
	if current_hp <= 0:
		die()

# 死亡處理
func die() -> void:
	print("玩家死亡！")
	# 這裡可以添加死亡動畫、遊戲結束邏輯等
	# TODO: 實現遊戲結束邏輯

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if Input.is_action_just_pressed("fire"):
		# mouse position
		var mouse_pos = get_global_mouse_position()
		var shoot_direction = (mouse_pos - gun.global_position).normalized()
		gun.fire(shoot_direction)


func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if  direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	# Update gun position, rotation and z-index based on direction
	match cardinal_direction:
		Vector2.LEFT:
			gun.position = GUN_OFFSET_SIDE
			gun.scale.x = -1
			gun.rotation = 0
			gun.z_index = 0  # Same z-index as player
		Vector2.RIGHT:
			gun.position = GUN_OFFSET_SIDE
			gun.scale.x = 1
			gun.rotation = 0
			gun.z_index = 0  # Same z-index as player  
		Vector2.UP:
			gun.position = GUN_OFFSET_UP
			gun.scale.x = 1
			gun.rotation = -PI/2
			gun.z_index = 0  # Same z-index as player
		Vector2.DOWN:
			gun.position = GUN_OFFSET_DOWN
			gun.scale.x = 1
			gun.rotation = PI/2 
			gun.z_index = 0  # Same z-index as player
	
	return true

func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass 

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
