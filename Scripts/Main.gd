extends Node2D

# IN THIS EXAMPLE I WILL TRY TO HANDLE ALL INPUT FROM MAIN, NOT IN EVERY UNIT...
# (UNITS WON'T HAVE _INPUT FUNCTIONS)

# UnitsGroup is the group for units

#==============================================================================================

var dragging:bool = false

var selected_units:Array =[]
#Start of selection rectangle
var drag_start:Vector2

#var can_drag:bool = false

#RectangleShape2D is a built in type of rectangle that can detect collisions
var selection_rectangle:RectangleShape2D = RectangleShape2D.new()



#==============================================================================================

# This function returns if there's a unit in mouse click position. Units are in collision layer 2
# This function mimics a little bit GML instance_position(x,y)
func check_if_something_at_position(target:Vector2):
	var space_state = get_world_2d().direct_space_state
	var result:Array = space_state.intersect_point(target,32,[self],2,false,true)
	#Result is an array of dictionaries, right?
	if result:
		return result
	

func rectangular_selection(from:Vector2, to:Vector2):
	var intercepted_units
	selection_rectangle.extents = (to - from)/2
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	#Because my Units are Area2d
	query.collide_with_areas = true
	#Assing the RectangleShape2D
	query.set_shape(selection_rectangle)
	#Position
	query.transform = Transform2D(0, (to + from)/2)
	#Selected units will be those intersected by the RectangleShape2D
	intercepted_units = space.intersect_shape(query)
	return intercepted_units





#==============================================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		#Select / Deselect units with left mouse button
		if event.button_index == BUTTON_LEFT:
			if event.pressed == true:
				var result= check_if_something_at_position(event.position)
				#When there are no units, you can drag-select... ######################################
				if result == null:
					print ("Nothing here !!!")
					#First Deselect current selected units
					for unit in selected_units:
						unit.collider.toggle_selection(false)
					selected_units = []
					# Drag starts here
					dragging = true
					drag_start = event.position
				else:
					#There's something here,let's select it or deselect it !!  ===============================
					#Result is an array of dictionaries, #I used index 0 because it's a single unit selection
					#I used index 0 because it's a single unit selection
					var selected:bool = result[0].collider.selected
					result[0].collider.toggle_selection(not selected)
		# Left mouse button is released, stop dragging !!!
			elif dragging == true:
				dragging = false
				update()
				var drag_end = event.position
				# I'll refactor this because this function is huge, to hard to read ! Make query in helper function
				selected_units = rectangular_selection(drag_start,drag_end)
				for unit in selected_units:
					unit.collider.toggle_selection(true)
				
				
				
				
			
	if event is InputEventMouseMotion and dragging == true:
		#Call update to draw selection rectangle properly
		update()





func _draw():
	#Draws selection rectangle only if dragging
	if dragging == true:
		draw_rect(Rect2(drag_start,get_global_mouse_position() - drag_start),Color.blue,false,1.5,false)







# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
