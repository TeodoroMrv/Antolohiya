extends Control

# This function runs when the 'Play Game' button is pressed
func _on_play_pressed():
	# Make sure the file name matches exactly (case sensitive!)
	get_tree().change_scene("res://lvlselect.tscn")
	
func _ready():
	# Test login
	FirebaseManager.login("test@example.com", "password123")
	yield(FirebaseManager, "auth_success")
	print("✅ Logged in!")
	
	# Test save progress
	FirebaseManager.save_progress(FirebaseManager.current_user_id, 85.5, 3)


	
	
	
