extends Control

# This function runs when the 'Play Game' button is pressed
func _on_play_pressed():
	# Make sure the file name matches exactly (case sensitive!)
	get_tree().change_scene("res://lvlselect.tscn")

# This function runs when the 'Play Game' button is pressed
func _on_mayon_pressed():
	# Make sure the file name matches exactly (case sensitive!)
	get_tree().change_scene("res://ch1s1.tscn")
