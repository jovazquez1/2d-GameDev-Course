extends Area2D
@onready var flame: Sprite2D = $Flame

func _ready() -> void:
	pass

func _on_input_event(Viewport, event: InputEvent, shape_idx: int):
	var is_mouse_pressed: bool = (
		event is InputEventMouseButton and
		event.pressed and
		event.button_index == MOUSE_BUTTON_LEFT)
	if is_mouse_pressed:
		flame.visible = not flame.visible
