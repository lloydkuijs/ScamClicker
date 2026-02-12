extends Node2D

var boxtimer: Timer = Timer.new()
var visibleTimer: Timer = Timer.new()
var boxCooldown := false
@onready var lootchest = $TextureButton
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if boxCooldown:
		return
		
	lootchest.visible = false
	
	add_child(boxtimer)
	boxtimer.wait_time = 4
	boxtimer.one_shot = true
	boxtimer.autostart = true
	boxtimer.timeout.connect(boxVisible)
	boxtimer.start()

func boxVisible():
	if boxCooldown:
		boxtimer.start()
		return
		
	findpositionisgood()
	var rndnumvisible = RandomNumberGenerator.new().randi_range(0, 9)
	if rndnumvisible == 0:
		lootchest.visible = true
		startCooldown()
		visibleTimerOn()
	else:
		lootchest.visible = false

	boxtimer.start()
	print(rndnumvisible)

func findpositionisgood(): 
	lootchest.visible = false
	while true:
		var x = RandomNumberGenerator.new().randi_range(0, 450)
		var y = RandomNumberGenerator.new().randi_range(0, 330)
		lootchest.position = Vector2(x, y)
		lootchest.visible = true
		break 
		# it needs to touch not

func startCooldown():
	boxCooldown = true
	
	await get_tree().create_timer(60.0).timeout # cooldown timer after chest appearing
	boxCooldown = false

func visibleTimerOn():
	await get_tree().create_timer(5.0).timeout # timer for lootchest to disappear
	lootchest.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.is_in_group("no_spawn_area"))

# button function
func _on_texture_button_pressed() -> void:
	var rndbox = RandomNumberGenerator.new().randi_range(0, 3)
	if rndbox == 3:
		Global.money = Global.money * 0.75
		lootchest.visible = false
	else:
		Global.money = Global.money * 1.5 + 1
		lootchest.visible = false
