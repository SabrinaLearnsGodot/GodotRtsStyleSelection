extends Area2D

class_name Unit

var selected:bool = false

onready var selected_icon:Sprite = $SelectedIcon



#=======================================================================================

func toggle_selection(value):
	selected = value
	selected_icon.visible = value
	print("Im " + str(self) + " and my selection is " + str(selected))
	print("---------------------------------------------")






#=======================================================================================


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
