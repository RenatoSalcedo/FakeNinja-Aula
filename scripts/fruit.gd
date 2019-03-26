extends RigidBody2D

onready var shape = get_node("Shape")
onready var sprite0 = get_node("Sprite0")
onready var body0 = get_node("Body0")
onready var body1 = get_node("Body1")

onready var srite1 = body0.get_node("Sprite1")
onready var srite2 = body1.get_node("Sprite2")

var slice = false

signal score
signal life

func _ready():
	randomize()
	set_process(true)

func _process(delta):
	if position.y > 800 and slice:
		emit_signal("life")
		queue_free()
	if body0.position.y > 800 && body1.position.y > 800:
		queue_free()

func born(ini_pos):
	position = ini_pos
	var ini_vel = Vector2(0, rand_range(-1000, -800))
	
	if ini_pos.x < 640:
		ini_vel = ini_vel.rotated(deg2rad(rand_range(0, -30)))
	else:
		ini_vel = ini_vel.rotated(deg2rad(rand_range(0, 30)))
	
	set_linear_velocity(ini_vel)
	set_angular_velocity(rand_range(-10, 10))

func cut():
	if slice: return
	
	slice = true
	emit_signal("score")
	
	set_mode(RigidBody2D.MODE_KINEMATIC)
	sprite0.queue_free()
	shape.queue_free()
	
	body0.set_mode(RigidBody2D.MODE_RIGID)
	body1.set_mode(RigidBody2D.MODE_RIGID)
	
	body0.apply_impulse(Vector2(0, 0), Vector2(-200, 0).rotated(rotation))
	body1.apply_impulse(Vector2(0, 0), Vector2(200, 0).rotated(rotation))
	
	body0.set_angular_velocity(get_angular_velocity())
	body1.set_angular_velocity(get_angular_velocity())
