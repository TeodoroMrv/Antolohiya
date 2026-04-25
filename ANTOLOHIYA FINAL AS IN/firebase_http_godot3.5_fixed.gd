extends Node

# Firebase credentials
var FIREBASE_API_KEY = "AIzaSyDccab4drf98gvR2Z3CPhhsYQzpg"
var FIREBASE_DATABASE_URL = "https://antolohiya-default-rtdb.asia-southeast1.firebasedatabase.app"
var FIREBASE_PROJECT_ID = "antolohiya"

# User data
var current_user_id = ""
var current_user_email = ""
var id_token = ""  # Used for authentication

# HTTP Request node
var http_request: HTTPRequest

# Signals
signal auth_success
signal progress_loaded(data)

func _ready():
	# Create HTTPRequest node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	print("✅ Firebase Manager initialized")

# ============================================
# AUTHENTICATION FUNCTIONS
# ============================================

# Sign up new user
func signup(email: String, password: String) -> void:
	var url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + FIREBASE_API_KEY
	var body = {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	
	var json_string = to_json(body)
	var headers = PoolStringArray(["Content-Type: application/json"])
	var _result = http_request.request(url, headers, HTTPClient.METHOD_POST, json_string)
	print("📝 Signup request sent for: " + email)

# Login user
func login(email: String, password: String) -> void:
	var url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + FIREBASE_API_KEY
	var body = {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	
	var json_string = to_json(body)
	var headers = PoolStringArray(["Content-Type: application/json"])
	var _result = http_request.request(url, headers, HTTPClient.METHOD_POST, json_string)
	print("🔑 Login request sent for: " + email)

# ============================================
# DATABASE FUNCTIONS
# ============================================

# Save student progress
func save_progress(student_id: String, score: float, level: int) -> void:
	var url = FIREBASE_DATABASE_URL + "/students/" + student_id + "/progress.json?auth=" + id_token
	var body = {
		"score": score,
		"level": level,
		"timestamp": int(OS.get_ticks_msec())
	}
	
	var json_string = to_json(body)
	var headers = PoolStringArray(["Content-Type: application/json"])
	var _result = http_request.request(url, headers, HTTPClient.METHOD_PUT, json_string)
	print("💾 Progress saved for student: " + student_id)

# Save quest completion
func save_quest_completion(student_id: String, quest_id: String, score: float) -> void:
	var url = FIREBASE_DATABASE_URL + "/students/" + student_id + "/quests/" + quest_id + ".json?auth=" + id_token
	var body = {
		"completed": true,
		"score": score,
		"timestamp": int(OS.get_ticks_msec())
	}
	
	var json_string = to_json(body)
	var headers = PoolStringArray(["Content-Type: application/json"])
	var _result = http_request.request(url, headers, HTTPClient.METHOD_PUT, json_string)
	print("✅ Quest completed: " + quest_id)

# Load student progress
func load_progress(student_id: String) -> void:
	var url = FIREBASE_DATABASE_URL + "/students/" + student_id + "/progress.json?auth=" + id_token
	var _result = http_request.request(url, PoolStringArray(), HTTPClient.METHOD_GET)
	print("📖 Loading progress for student: " + student_id)

# ============================================
# RESPONSE HANDLER
# ============================================

func _on_request_completed(result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("❌ HTTP Request failed: " + str(result))
		return
	
	var response_text = body.get_string_from_utf8()
	print("📨 Response: " + response_text)
	
	# Parse JSON response
	var json = JSON.parse(response_text)
	
	if json.error:
		print("❌ Failed to parse JSON")
		return
	
	var data = json.result
	
	# Handle authentication responses
	if data.has("idToken"):
		id_token = data["idToken"]
		current_user_id = data["localId"]
		current_user_email = data.get("email", "")
		print("✅ Authentication successful!")
		print("   User ID: " + current_user_id)
		print("   Email: " + current_user_email)
		emit_signal("auth_success")
	
	# Handle database responses
	elif data.has("score"):
		print("✅ Progress loaded: Score = " + str(data["score"]))
		emit_signal("progress_loaded", data)
