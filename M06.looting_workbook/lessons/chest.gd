extends Area2D

@onready var canvas_group: CanvasGroup = $CanvasGroup

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	canvas_group.material.set_shader_parameter("line_thickness", 3.0)

func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)

func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 6.0, 3.0, 0.08)

func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)
