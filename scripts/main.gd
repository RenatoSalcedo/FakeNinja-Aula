extends Node2D

onready var fruits = get_node("Fruits")

var lemon = preload("res://scene/Lemon.tscn")
var orange = preload("res://scene/Orange.tscn")
var pera = preload("res://scene/Pera.tscn")
var tomate = preload("res://scene/Tomate.tscn")
var watermelon = preload("res://scene/Watermelon.tscn")
var bomb = preload("res://scene/Bomb.tscn")

onready var lblScore = get_node("Control/Score")
onready var inputProc = get_node("InputProc")

onready var lBomb1 = get_node("Control/Bomb1")
onready var lBomb2 = get_node("Control/Bomb2")
onready var lBomb3 = get_node("Control/Bomb3")

var score = 0
var lifes = 3

func _ready():
	randomize() 

func _on_Generator_timeout():
	if lifes <= 0: return
	
	for i in range(0, rand_range(1, 4)):
		var type = int(rand_range(0, 6))
		var obj
		
		if type == 0:
			obj = lemon.instance()
		elif type == 1:
			obj = orange.instance()
		elif type == 2:
			obj = pera.instance()
		elif type == 3:
			obj = tomate.instance()
		elif type == 4:
			obj = watermelon.instance()
		else:
			obj = bomb.instance()
			
		obj.born(Vector2(rand_range(200, 1080), rand_range(750, 800)))
		obj.connect("life", self, "dec_life")
		
		if type <= 4:
			obj.connect("score", self, "inc_score")
		
		fruits.add_child(obj)

func dec_life():
	lifes -= 1
	if lifes == 0:
		lBomb1.modulate = Color(255, 255, 255, 0)
		perder()
	if lifes == 2:
		lBomb3.modulate = Color(255, 255, 255, 0)
	if lifes == 1: 
		lBomb2.modulate = Color(255, 255, 255, 0)

func inc_score():
	if lifes == 0: return
	
	score += 1
	lblScore.set_text(str(score))

func perder():
	inputProc.gameover = true
	get_node("GameOver").score.set_text(str(score))
	get_node("GameOver").start()