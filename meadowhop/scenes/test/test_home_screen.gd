extends Node2D

@onready var play_button = $play_button
@onready var fade_out = $fade_out
var play_original_scale

func _ready():
	fade_out.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_out.visible = true
	fade_out.modulate.a = 0
	play_original_scale = play_button.scale
	play_button.mouse_entered.connect(_on_play_hover)
	play_button.mouse_exited.connect(_on_play_exit)
	play_button.button_down.connect(_on_play_hover)
	play_button.button_up.connect(_on_play_exit)
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	fade_out.visible = true
	fade_out.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(fade_out, "modulate:a", 1.0, 1.5)
	await tween.finished
	print("pressed")
	get_tree().change_scene_to_file("res://scenes/test/test_scene_horizons_submission.tscn")


func _on_play_hover():
	var tween = create_tween()
	tween.tween_property(play_button, "scale", play_original_scale * 1.03, 0.08)

func _on_play_exit():
	var tween = create_tween()
	tween.tween_property(play_button, "scale", play_original_scale, 0.08)
