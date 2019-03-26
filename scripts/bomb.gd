extends RigidBody2D

onready var shape = get_node("Shape")
onready var sprite = get_node("Sprite")
onready var explode = get_node("ExplodeBomb")
onready var sExplode = get_node("Explode")

signal life

var explod = false

func _ready():
	set_process(true)
	randomize()

func _process(delta):
	if position.y > 800:
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
	if explod: return
	emit_signal("life")
	set_mode(RigidBody2D.MODE_KINEMATIC)
	explode.play("Explode")
	explod = true