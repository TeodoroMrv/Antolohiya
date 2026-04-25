extends Node

onready var blue_button = find_node("Blank1") 
onready var true_button = find_node("True")
onready var false_button = find_node("False")

var can_answer = false

func _ready():
	true_button.disabled = true
	false_button.disabled = true
	
	blue_button.connect("pressed", self, "_on_blue_clicked")
	true_button.connect("pressed", self, "_on_answer_clicked", [true])
	false_button.connect("pressed", self, "_on_answer_clicked", [false])

func _on_blue_clicked():
	can_answer = true
	true_button.disabled = false
	false_button.disabled = false
	blue_button.text = "Pumili na..." 

func _on_answer_clicked(is_false_pressed):
	if can_answer:
		# Lock buttons so they can't click again while waiting
		true_button.disabled = true
		false_button.disabled = true
		
		if is_false_pressed == false:
			blue_button.text = "TAMA!"
			blue_button.modulate = Color.green # Turns the blue button Green
		else:
			blue_button.text = "MALI!"
			blue_button.modulate = Color.red   # Turns the blue button Red
			
		# Wait for 3 seconds, then change scene
		yield(get_tree().create_timer(3.0), "timeout")
		_change_scene()

func _change_scene():
	# Change "lvlselect.tscn" to whatever your next scene file is named!
	get_tree().change_scene("res://posttest3.tscn")
