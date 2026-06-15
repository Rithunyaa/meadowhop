class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt(hit_damage: int)

func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player == null:
		return
	if not player is CharacterBody2D:
		return
	if not player.has_node("HitComponent"):
		return
	var hit_component = player.get_node("HitComponent")
	print("TREE TOOL =", tool)
	print("PLAYER TOOL =", hit_component.current_tool)
	if tool == hit_component.current_tool:
		hurt.emit(hit_component.hit_damage)
