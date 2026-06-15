class_name HitComponent
extends Area2D

var current_tool: DataTypes.Tools
@export var hit_damage : int = 1

func _ready():
	print("HIT COMPONENT READY:", get_path(), " tool =", current_tool)
