class_name DialogueScript
extends RefCounted

static func run(dialogue_path: String) -> void:
	var dialogue: DialogueResource = load(dialogue_path)

	if dialogue == null:
		push_error("Failed to load dialogue: " + dialogue_path)
		return

	DialogueManager.show_dialogue_balloon(dialogue, "start")
