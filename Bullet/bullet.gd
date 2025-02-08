extends Area2D

@export var bullet_speed: float = 400.0 # Bullet speed
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func shoot(direction: Vector2) -> void:
	velocity = direction.normalized() * bullet_speed


func _physics_process(delta: float) -> void:
	position += velocity * delta
	# If the bullet is out of the screen, destroy it
	if not get_viewport_rect().has_point(position):
		queue_free()
