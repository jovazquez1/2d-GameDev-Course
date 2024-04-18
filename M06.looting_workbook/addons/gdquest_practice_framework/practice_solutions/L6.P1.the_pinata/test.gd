extends "res://addons/gdquest_practice_framework/tester/test.gd"

var candy_scene_practice: String = _load("candy.tscn", true).instantiate().scene_file_path
var candy_scene_solution: String = _load("candy.tscn", false).instantiate().scene_file_path

var practice_balloon: Area2D = null
var solution_balloon: Area2D = null

var simulated_candy_positions: Array[Vector2] = []

func _setup_state() -> void:
	var practice_balloons := _practice.find_children("", "Area2D")
	var solution_balloons := _solution.find_children("", "Area2D")
	practice_balloon = practice_balloons.front()
	solution_balloon = solution_balloons.front()

	await get_tree().create_timer(1.0).timeout
	var left_click_event := InputEventMouseButton.new()
	left_click_event.button_index = MOUSE_BUTTON_LEFT
	left_click_event.pressed = true
	for balloon in practice_balloons + solution_balloons:
		seed(0)
		balloon._input_event(get_viewport(), left_click_event, 0)
	seed(0)
	simulated_candy_positions = _simulate_candy_spawn_variation()


# This early in the course we don't want to introduce RandomNumberGenerator yet, which we need to reliably test random numbers.
# The problem is, when generating multiple numbers, the random generation is sensitive to the order in which we generate them.
# In this practice, there are two random numbers generated: the radius and the angle.
# So, we use this function to test generating the angle first, then the radius. This way, we can ensure the test is relatively reliable for students.
func _simulate_candy_spawn_variation() -> Array[Vector2]:
	var candy_positions: Array[Vector2] = []
	for current_index in range(3):
		var angle := randf_range(0.0, 2.0 * PI)
		var radius := randf_range(0.0, 100.0)

		var random_direction := Vector2(1.0, 0.0).rotated(angle)
		var random_position := (radius * random_direction)
		
		# This is required because instantiating and adding the candy as a child
		# changes the random number sequence. So, to match the student practice,
		# we need to instantiate the candies too.
		const CANDY_PACKED_SCENE := preload("candy/candy.tscn")
		var candy: Node2D = CANDY_PACKED_SCENE.instantiate()
		add_child(candy)
		candy.hide()
		
		candy_positions.append(random_position)
	return candy_positions


func _build_checks() -> void:
	_add_simple_check(
		tr("When clicked, the balloon spawns 3 candies."),
		func() -> String:
			var hint := tr("Did you loop three times and add the candies as children of the balloon?")
			var candies: Array = practice_balloon.get_children().filter(is_candy_predicate.bind(candy_scene_practice))
			return "" if candies.size() == 3 else hint
	)

	_add_simple_check(
		tr("The candies are spawned at random positions around the balloon, within a 100 pixels radius."),
		func() -> String:
			var practice_candies := practice_balloon.get_children().filter(is_candy_predicate.bind(candy_scene_practice))
			var solution_candies := solution_balloon.get_children().filter(is_candy_predicate.bind(candy_scene_solution))

			var is_position_same_a: Array[bool] = []
			for idx in range(practice_candies.size()):
				is_position_same_a.push_back(practice_candies[idx].position.is_equal_approx(solution_candies[idx].position))
			
			var is_position_same_b: Array[bool] = []
			for idx in range(practice_candies.size()):
				is_position_same_b.push_back(practice_candies[idx].position.is_equal_approx(simulated_candy_positions[idx]))

			var identity_predicate := func(x: bool) -> bool: return x
			var hint := tr("Did you forget to randomize the radius or angle of the generated position? The candies should be spawned at random positions around the balloon, is a circular area with a 100 pixels radius.")
			return "" if is_position_same_a.all(identity_predicate) or is_position_same_b.all(identity_predicate) else hint
	)
	checks.back().dependencies.append(checks.front())


func is_candy_predicate(node: Node, gdscript_path: String) -> bool:
	return node.scene_file_path == gdscript_path
