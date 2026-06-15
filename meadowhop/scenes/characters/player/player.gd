class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

@onready var hit_component = $HitComponent

func _ready():
	hit_component.current_tool = current_tool
