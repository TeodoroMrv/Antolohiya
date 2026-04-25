extends Node

func _ready( ):
	var config = {
		"api_key": "AIzaSyDccab4drf98gvR2Z3CPhhsYQzpg",
		"auth_domain": "antolohiya.firebaseapp.com",
		"database_url": "https://antolohiya-default-rtdb.asia-southeast1.firebasedatabase.app",
		"project_id": "antolohiya",
		"storage_bucket": "antolohiya.appspot.com",
		"messaging_sender_id": "106085694948",
		"app_id": "1:106085694948:web:74d1b771dda8bedef3c3"
	}
	
	Firebase.set_config(config S
	print("✅ Firebase configured!")
