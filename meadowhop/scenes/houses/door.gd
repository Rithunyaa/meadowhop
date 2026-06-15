extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var  interactible_component: InteractibleComponent = $InteractibleComponent

func _ready() -> void:
	interactible_component.interactible_activated.connect(on_interactible_activated)
	interactible_component.interactible_deactivated.connect(on_interactible_deactivated)
	collision_layer = 1
	
func on_interactible_activated() -> void:
	animated_sprite_2d.play("open_door")
	print("activated")
	collision_layer = 2

func on_interactible_deactivated() -> void:
	animated_sprite_2d.play("close_door")
	print("deactivated")
	collision_layer = 1
