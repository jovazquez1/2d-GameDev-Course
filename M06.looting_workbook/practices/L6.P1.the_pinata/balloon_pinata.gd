extends Area2D

func _ready() -> void:
	randomize()
func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed())
	if event_is_mouse_click:
		spawn_candy()
		input_pickable = false

func spawn_candy() -> void:
	for current_index in range(3):  
		var radius := randf_range(0.0, 100.0) 
		var angle := randf_range(0.0, 2.0 * PI)
		var random_direction := Vector2(1.0, 0.0).rotated(angle) 
		var random_position := (radius * random_direction)  
		const CANDY_PACKED_SCENE := preload("candy/candy.tscn")
		var candy: Node2D = CANDY_PACKED_SCENE.instantiate()  
		add_child(candy)  
		candy.position = random_position
