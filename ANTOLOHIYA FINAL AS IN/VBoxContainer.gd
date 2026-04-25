extends Control

var current_selected_word = ""
var is_waiting = false 
var correct_answers_count = 0 # Track how many they got right!

var answers = {
	"Blank1": "Panahon",
	"Blank2": "Babaeng",
	"Blank3": "Daragang Magayon"
}

func _ready():
	get_node("ColorRect2/HBoxContainer/Blank1").text = "---"
	get_node("ColorRect2/HBoxContainer/Blank2").text = "---"
	get_node("ColorRect2/HBoxContainer/Blank3").text = "---"

func _on_word_button_pressed(word_text):
	if is_waiting: return
	current_selected_word = word_text
	print("Selected word: ", word_text)

func _on_blank_button_pressed(blank_name):
	if is_waiting or current_selected_word == "":
		return
	
	var blank_node = get_node("ColorRect2/HBoxContainer/" + blank_name)
	
	# If the blank is already green, don't let them change it
	if blank_node.modulate == Color.green:
		return

	blank_node.text = current_selected_word
	
	if current_selected_word == answers[blank_name]:
		blank_node.modulate = Color.green
		current_selected_word = "" 
		correct_answers_count += 1 # Add to the score
		
		# Check if they finished the whole puzzle (3 blanks)
		if correct_answers_count == 3:
			_on_puzzle_finished()
	else:
		is_waiting = true
		blank_node.modulate = Color.red
		yield(get_tree().create_timer(1.5), "timeout")
		
		blank_node.text = "---"
		blank_node.modulate = Color.white 
		current_selected_word = ""
		is_waiting = false

func _on_puzzle_finished():
	print("Puzzle solved! Moving to post-test...")
	# Wait so they can see the last green button
	yield(get_tree().create_timer(1.5), "timeout")
	
	var error = get_tree().change_scene("res://posttest.tscn")
	
	if error != OK:
		print("Error: Could not find posttest.tscn. Check your file path!")
