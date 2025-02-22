extends Control

func _on_close_pressed() -> void:
	get_parent().remove_child(self)

func _on_quit_pressed() -> void:
	get_tree().quit()
