extends Area2D


func _ready() -> void:
	randomize()


func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	)

	if event_is_mouse_click:
		spawn_candy()
		input_pickable = false


func spawn_candy() -> void:
	# You have to loop 3 times over the next lines of code!
	for current_index in range(0):
		# Complete the variables to calculate a random position in a circle using polar coordinates.
		var radius := 0.0
		var angle := 0.0

		var random_direction := Vector2()
		var random_position := Vector2()

		# Instantiate and add the candy as a child of the piñata.
		const CANDY_PACKED_SCENE := preload("candy/candy.tscn")
		var candy: Node2D = null
