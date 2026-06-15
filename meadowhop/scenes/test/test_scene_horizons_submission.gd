extends Node2D

@onready var grass: TileMapLayer = $GameTileMap/Grass
@onready var water: TileMapLayer = $GameTileMap/Water
@onready var undergrowth: TileMapLayer = $GameTileMap/Undergrowth
@onready var overgrowth: TileMapLayer = $GameTileMap/Overgrowth
@onready var objects: TileMapLayer = $GameTileMap/Objects

@onready var player: Player = $Player

@onready var instructions_popup: Sprite2D = $CanvasLayer/UI/instructions_popup
@onready var instructions_text: RichTextLabel = $CanvasLayer/UI/instructions_text
@onready var timer_label: Label = $CanvasLayer/UI/TimerLabel

@onready var game_over_panel: Control = $CanvasLayer/UI/game_over_panel


var remaining_trees := 0
var remaining_rocks := 0
var time_elapsed := 0.0
var game_ended := false
var game_started := false


func _ready():
	game_over_panel.visible = false
	call_deferred("init_counts")


func count_tiles(layer: TileMapLayer) -> int:
	var count = 0
	for cell in layer.get_used_cells():
		if layer.get_cell_tile_data(cell) != null:
			count += 1
	return count


func on_tree_destroyed():
	if game_ended:
		return
	remaining_trees -= 1
	check_win()


func on_rock_destroyed():
	if game_ended:
		return
	remaining_rocks -= 1
	check_win()


func check_win():
	if remaining_trees <= 0 and remaining_rocks <= 0:
		game_complete()


func game_complete():
	if game_ended:
		return

	game_ended = true
	game_started = false

	print("GAME COMPLETE - TIME:", time_elapsed)

	player.set_physics_process(false)

	game_over_panel.visible = true

	for c in game_over_panel.get_children():
		c.queue_free()

	var panel_size = Vector2(500, 300)

	# slight left shift
	var x_offset = -90

	var final_score = Label.new()
	final_score.text = "Time: " + format_time(time_elapsed)

	final_score.size = Vector2(300, 30)
	final_score.position = Vector2(panel_size.x / 2 + x_offset, 60)
	final_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	final_score.position.x -= final_score.size.x / 2

	game_over_panel.add_child(final_score)

	# BUTTON LAYOUT
	var button_w = 130
	var button_h = 50
	var spacing = 20

	var total_width = button_w * 2 + spacing
	var start_x = panel_size.x / 2 - total_width / 2 + x_offset
	var button_y = 180

	# PLAY AGAIN
	var play_again = Button.new()
	play_again.text = "Play Again"
	play_again.size = Vector2(button_w, button_h)
	play_again.position = Vector2(start_x, button_y)
	play_again.pressed.connect(func():
		get_tree().reload_current_scene()
	)
	game_over_panel.add_child(play_again)

	# HOME
	var home = Button.new()
	home.text = "Home"
	home.size = Vector2(button_w, button_h)
	home.position = Vector2(start_x + button_w + spacing, button_y)
	home.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/test/test_home_screen.tscn")
	)
	game_over_panel.add_child(home)


func _process(delta):
	if game_started:
		time_elapsed += delta
		timer_label.text = format_time(time_elapsed)


func init_counts():
	await get_tree().process_frame
	remaining_trees = overgrowth.get_used_cells().size()
	remaining_rocks = objects.get_used_cells().size()


func start_game():
	game_started = true


func _input(event):
	if game_started:
		return

	if event is InputEventMouseButton and event.pressed:
		game_started = true
		instructions_popup.visible = false
		instructions_text.visible = false


func format_time(t: float) -> String:
	var total_seconds = int(t)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var milliseconds = int((t - total_seconds) * 100)

	return str(minutes) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
