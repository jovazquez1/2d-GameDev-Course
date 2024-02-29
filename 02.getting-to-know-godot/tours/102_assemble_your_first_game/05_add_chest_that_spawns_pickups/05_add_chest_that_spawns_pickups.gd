extends "../102_assemble_your_first_game.gd"


func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_button_output.button_pressed = false
	)

	ended.connect(OS.shell_open.bind("https://school.gdquest.com/courses/learn_2d_gamedev_godot_4/learn_gdscript/learn_gdscript_app"))

	part_010_adding_chest()
	part_020_first_line_of_code()
	part_xxxx_conclusion()


func part_010_adding_chest() -> void:

	add_step_open_start_scene_conditionally()

	context_set_2d()
	queue_command(func():
		interface.bottom_button_output.button_pressed = false
	)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Changing RoomA")
	bubble_add_text([
		"We added several scene instances to the [b]Start[/b] scene: the [b]Player[/b], the [b]UIHealthBar[/b], the [b]BackgroundBlueSky[/b], and the rooms.",
		"We can open and modify any of those scenes. Any changes we make to the scene source files in the [b]FileSystem[/b] dock will be reflected in their instances.",
		"The opposite is not true: Changes we make to a specific instance of a scene applies to that instance only.",
	])
	complete_step()

	var room_a_filename: String = ROOM_SCENES.front().get_file()
	highlight_filesystem_paths([ROOM_SCENES.front()])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Open the RoomA scene")
	bubble_add_text([
		"Let's give this a try. Open the [b]RoomA[/b] scene.",
		"Double-click the file [b]" + room_a_filename + "[/b] in the [b]FileSystem dock[/b] in the bottom-left to open the scene.",
	])
	bubble_add_task(
		("Open the scene [b]" + room_a_filename +"[/b]."),
		1,
		func task_open_start_scene(_task: Task) -> int:
			var scene_root: Node = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			return 1 if scene_root.name == "RoomA" else 0
	)
	complete_step()

	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("The RoomA scene")
	bubble_add_text([
		"We're now inside the room's scene.",
		"Anything we add here will be reflected in the [b]Start[/b] scene when we play the game.",
	])
	complete_step()

	var scene_chest_filename := SCENE_CHEST.get_file()
	highlight_controls([interface.canvas_item_editor])
	highlight_filesystem_paths([SCENE_CHEST])
	bubble_set_title("The chest")
	bubble_add_text([
		"In the project, we prepared a chest scene for you: [b]" + scene_chest_filename + "[/b]. You can see it in the [b]FileSystem Dock[/b] in the bottom-left.",
		"Drag and drop the [b]" + scene_chest_filename + "[/b] file onto the viewport to create an instance of it, and place it inside of the room.",
	])
	bubble_add_task(
		"Add the [b]Chest Scene[/b] to the [b]Scene[/b].",
		1,
		func(_task: Task) -> int:
			var chest_node: Node = get_scene_node_by_path("RoomA/Chest")
			return 1 if chest_node != null else 0,
	)
	bubble_add_task(
		"Place the [b]Chest Scene[/b] inside of the room.",
		1,
		func(_task: Task) -> int:
			var scene_root: Node = EditorInterface.get_edited_scene_root()
			var chest_node: Node2D = scene_root.find_child("Chest")
			if chest_node == null:
				return 0
			var tilemap: TileMap = scene_root.find_child("Floor")
			#TODO: check for floor cell in tilemap instead, it's more precise
			var tilemap_rect := get_tilemap_global_rect_pixels(tilemap)
			return 1 if tilemap_rect.has_point(chest_node.global_position) else 0,
	)
	complete_step()

	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Save the scene")
	bubble_add_text([
		"Press [b]Ctrl+S[/b] on your keyboard (Cmd+S on macOS) to save the [b]RoomA[/b] scene.",
		"This will save your change and update the [b]Start[/b] scene.",
	])
	complete_step()

	queue_command(EditorInterface.save_scene)
	highlight_controls([interface.main_screen_tabs])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Head back to the start scene")
	bubble_add_text([
		"Let's now head back to the [b]Start[/b] scene where you can see the chest.",
		"Click on the scene tab that says " + SCENE_START.get_file() + " above the viewport.",
	])
	bubble_add_task(
		"Click the [b]Start[/b] scene tab.",
		1,
		func(_task: Task) -> int:
			return 1 if EditorInterface.get_edited_scene_root().name == "Start" else 0,
	)
	complete_step()

	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Time to play!")
	bubble_add_text([
		"Click the [b]Play Current Scene[/b] button to run the scene and move the player near the chest.",
		"What do you observe?",
		"Press [b]F8[/b] on your keyboard or close the game window to return to the editor.",
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, "Play Current Scene")
	complete_step()


func part_020_first_line_of_code() -> void:
	queue_command(func():
		interface.bottom_button_output.button_pressed = false
	)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Your first line of code")
	bubble_add_text([
		"Currently, when we approach the chest, it opens, and nothing comes out of it. That's because we're missing the code that spawns pickups when the chest opens.",
		"Nodes and scenes can fill up the game world but without [b]code[/b], they don't make a complete game.",
		"To add life and interaction to your game, you need to write code.",
	])
	complete_step()

	highlight_filesystem_paths([SCENE_CHEST])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Open the chest scene")
	bubble_add_text([
		"Let's make something come out of the chest by adding a line of code to it.",
		"First, open the [b]Chest[/b] scene by double-clicking on it."
	])
	bubble_add_task(
		"Open the scene [b]chest.tscn[/b].",
		1,
		func task_open_chest_scene(_task: Task) -> int:
			var scene_root: Node = EditorInterface.get_edited_scene_root()
			print(scene_root)
			return 1 if scene_root != null and scene_root.name == "Chest" else 0
	)
	complete_step()

	highlight_scene_nodes_by_path(["Chest"])
	highlight_controls([interface.script_editor])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("Open the script")
	bubble_add_text([
		"To make nodes interactive, we need to tell the computer how they interact. We do that using code.",
		"In Godot, we write code in a text file that we attach to a node.",
		"You can see that the chest node has a code file attached to it thanks to the script icon " + bbcode_generate_icon_image_string(ICONS_MAP.script) +  ". We call a code file a [b]script[/b].",
		"Click the script icon " + bbcode_generate_icon_image_string(ICONS_MAP.script) +  " to open this file in the script view.",
	])
	bubble_add_task(
		"Open the script attached to the [b]Chest[/b] node.",
		1,
		func(_task: Task) -> int:
			if not interface.is_in_scripting_context():
				return 0
			var open_script: String = EditorInterface.get_script_editor().get_current_script().resource_path
			return 1 if open_script == SCRIPT_CHEST else 0,
	)
	complete_step()

	highlight_controls([interface.script_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("The chest script")
	bubble_add_text([
		"This file already contains a bunch of GDScript code.",
		"GDScript is a language made by gamedevs for gamedevs. It's designed to code games fast.",
		"Again, don't worry if you can't understand the code yet: that's what the next modules are for.",
		"For now, we'll just add one missing line to get familiar with the script editor.",
	])
	complete_step()

	highlight_code(11, 14)
	bubble_set_title("The loot function")
	bubble_add_text([
		"In the highlighted lines of code, we define a [b]function[/b] named [b]loot[/b].",
		"A function is a group of instructions you can run by [b]calling[/b] the function's name, like so: [b]loot()[/b].",
	])
	complete_step()

	highlight_code(23, 26)
	bubble_set_title("Connected signal")
	bubble_add_text([
		"The loot function is [b]called[/b] from the [b]_on_body_entered[/b] function.",
		"Notice the green icon " + bbcode_generate_icon_image_string(ICONS_MAP.script_signal_connected) +  " in the margin on the left. It tells us that [b]_on_body_entered[/b] is connected to a signal.",
		"This is why the chest opens when the player approaches it.",
	])
	complete_step()

	highlight_code(11, 14)
	bubble_set_title("The open animation")
	bubble_add_text([
		"Inside the loot function, we play the [b]open[/b] animation, which makes the chest open.",
		"And currently, that's all! This is why nothing comes out of the chest.",
	])
	complete_step()

	highlight_code(15, 22)
	bubble_set_title("The create_pickup function")
	bubble_add_text([
		"Below the [b]loot[/b] function, in the highlighted lines, there's a function defined to create pickups. We named it [b]create_pickup[/b].",
		"Don't worry about how it's coded yet. For now, just notice that while this function is defined, it's not called anywhere in the script file, which means it's not used by the [b]loot[/b] function.",
		"We need to call it in the [b]loot[/b] function so that the loot function can do two things:",
		"1. Play the chest open animation.",
		"2. Create pickups.",
	])
	complete_step()

	highlight_code(11, 14)
	bubble_set_title("Write the code")
	bubble_add_text([
		"On line 14, type [b]create_pickup()[/b] to call the function. Be careful to type exactly what you see here, including the parentheses.",
		"The name \"create_pickup\" tells the computer which function we want to refer to, and the parentheses () run the function's lines of code.",
		"Also, make sure that there's a [b]tab character[/b] at the start of the line, just like on line 13: " + bbcode_generate_icon_image_string(ICONS_MAP.script_indent) +  ". That's how Godot knows that the line belongs to the [b]loot[/b] function.",
		"Press the [b]Tab[/b] key on your keyboard to write a tab character."
	])
	bubble_add_task(
		"Call the function [b]create_pickup[/b] on line 14.",
		1,
		func(_task: Task) -> int:
			var text: String = interface.script_editor.get_current_editor().get_base_editor().text
			return 1 if text.find("\tcreate_pickup()") > -1 else 0,
	)
	complete_step()

	queue_command(EditorInterface.save_scene)
	highlight_controls([interface.main_screen_tabs])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Head back to the start scene")
	bubble_add_text([
		"Let's now head back to the [b]Start[/b] scene so we can test the result.",
		"Click on the scene tab that says [b]start[/b] above the viewport.",
	])
	bubble_add_task(
		"Click the [b]Start[/b] scene tab.",
		1,
		func(_task: Task) -> int:
			return 1 if EditorInterface.get_edited_scene_root().name == "Start" else 0,
	)
	complete_step()

	context_set_2d()
	highlight_controls([interface.run_bar_play_current_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Time to play!")
	bubble_add_text([
		"The game is now complete and ready to play!",
		"Click the [b]Play Current Scene[/b] button and move near a chest to test your code.",
		"Feel free to explore the rest of the game and appreciate all you just learned.",
		"Once you're done, press [b]F8[/b] on your keyboard or close the game window to return to the editor.",
	])
	bubble_add_task_press_button(interface.run_bar_play_current_button, "Play Current Scene")
	complete_step()


func part_xxxx_conclusion() -> void:
	bubble_move_and_anchor(interface.main_screen)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	queue_command(func set_avatar_happy() -> void:
		bubble.avatar.set_expression(Gobot.Expressions.HAPPY)
	)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("Congratulations on assembling your first game in Godot!")
	bubble_add_text([("[center]Head to the next module to keep learning how to code games![/center]")])
	bubble_set_footer((CREDITS_FOOTER_GDQUEST))
	complete_step()
