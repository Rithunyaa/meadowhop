extends Node2D
@onready var popup: Sprite2D = $instructions_popup
@onready var text: RichTextLabel = $instructions_text

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if popup.visible:
			popup.visible = false
			text.visible = false
			
func _ready():
	popup.visible = true
	text.visible = true
