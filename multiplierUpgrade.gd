extends Control

@onready var MultiplierButton = $squareShopButton
@onready var audio_player = $AudioStreamPlayer
@export_multiline var text: String
@export var UpgradeIcon: String
@export var UpgradePrice: int
@export var telupSquareFlag: int
@export_multiline var hoverText: String
#@onready var label = $PanelContainer/MarginContainer/Label
#@onready var pancon = $PanelContainer

signal multiplier_pressed

var upgrade_bought := false
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	MultiplierButton.pressed.connect(_on_pressed)
	$squareShopButton.tooltip_text = hoverText
	#label.text = text

#func _on_mouse_entered():
	#pancon.visible = true

#func _on_mouse_exited():
	#pancon.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not %TelephoneUpgrade:
		return
	if not upgrade_bought and %TelephoneUpgrade.UpgradeQuantity >= telupSquareFlag:
		show()
	if upgrade_bought and visible:
		hide()

func _on_pressed():
	if Global.money >= UpgradePrice:
		upgrade_bought = true
		Global.money -= UpgradePrice
		multiplier_pressed.emit()
		self.queue_free()
	else:
		audio_player.play()
