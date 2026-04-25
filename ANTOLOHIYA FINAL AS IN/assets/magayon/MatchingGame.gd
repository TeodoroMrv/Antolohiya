extends Control

var current_selected_word = ""
var is_waiting = false # Prevents clicking while showing red/green

# The Answer Key (Matches your Blue Button names to the Brown Button text)
var answers = {
	"Blank1": "Panahon",
	"Blank2": "Babaeng",
	"Blank3": "Daragang Magayon"
}

func _ready():
	# These paths are based exactly on your tree layout
	get_node("VBoxContainer/ColorRect2/HBoxContainer/Blank1").text = "---"
	get_node("VBoxContainer/ColorRect2/HBoxContainer/Blank2").text = "---"
	get_node("VBoxContainer/ColorRect2/HBoxContainer/Blank3").text = "---"

# Connect all Brown Buttons to this (Use Advanced -> Extra String Arg)
func _on_word_button_pressed(word_text):
	if is_waiting: return
	current_selected_word = word_text
	print("Selected word: ", word_text)

# Connect all Blue Buttons to this (Use Advanced -> Extra String Arg)
func _on_blank_button_pressed(blank_name):
	if is_waiting or current_selected_word == "":
		return
	
	var blank_node = get_node("VBoxContainer/ColorRect2/HBoxContainer/" + blank_name)
	blank_node.text = current_selected_word
	
	if current_selected_word == answers[blank_name]:
		# TAMA (Correct)
		blank_node.modulate = Color.green
		current_selected_word = "" # Clear selection so they can pick next word
	else:
		# MALI (Wrong)
		is_waiting = true
		blank_node.modulate = Color.red
		
		# Wait 1.5 seconds before letting them try again
		yield(get_tree().create_timer(1.5), "timeout")
		
		blank_node.text = "---"
		blank_node.modulate = Color.white # Reset color
		current_selected_word = ""
		is_waiting = false
