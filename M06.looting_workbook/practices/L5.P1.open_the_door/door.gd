extends Area2D
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.is_pressed() 
	)
	if event_is_mouse_click:
		animation_player.play("open")  
		input_pickable = false  
