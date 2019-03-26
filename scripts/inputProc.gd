extends Node2D

onready var dragSound = get_node("cut")
onready var soundTime = get_node("SoundTime")

onready var limit = get_node("Limit")
onready var inter = get_node("Inter")

var pressed = false
var drag = false
var cur_pos = Vector2(0, 0)
var pre_pos = Vector2(0, 0)

func _ready():
	set_process_input(true)
	set_physics_process(true)

func _physics_process(delta):
	update()
	if drag and cur_pos != pre_pos and pre_pos != Vector2(0, 0):
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(pre_pos, cur_pos)
		
		if not result.empty():
			dragSound.play()
			soundTime.start()
			result.collider.cut()

func _input(event):
	event = make_input_local(event)
	if (event is InputEventScreenDrag or event is InputEventMouseMotion):
		drag(event.position)
	elif (event is InputEventScreenTouch or event is InputEventMouseButton) and event.is_pressed():
		pressed(event.position)
	else:
		released()

func drag(pos):
	cur_pos = pos
	drag = true

func pressed(pos):
	pressed = true
	pre_pos = pos
	limit.start()
	inter.start()

func released():
	pressed = false
	drag = false
	limit.stop()
	inter.stop()
	
	pre_pos = Vector2(0, 0)
	cur_pos = Vector2(0, 0)

func _on_Inter_timeout():
	pre_pos = cur_pos


func _on_Limit_timeout():
	released()

func _on_SoundTime_timeout():
	dragSound.stop()

func _draw():
	if drag and cur_pos != pre_pos and pre_pos != Vector2(0, 0):
		draw_line(cur_pos, pre_pos, Color(255, 0, 0), 10)