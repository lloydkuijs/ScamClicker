extends Control

@onready var UpgradeButton = $UpgradeButton
@export var UpgradeIcon: Texture2D
@export var UpgradeName: String
@export var Currency: String
@export var UpgradeQuantity: int
@export var UpgradePrice: int
@onready var audio_player = $AudioStreamPlayer
signal upgrade_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	UpgradeButton.pressed.connect(_upgrade_button_pressed)
	
	$UpgradeButton/Icon.texture = UpgradeIcon
	$UpgradeButton/Name.text = UpgradeName
	$UpgradeButton/Currency.text = "€"
	
	UpgradeText()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _upgrade_button_pressed():
	if Global.money >= UpgradePrice:	
		upgrade_pressed.emit()

	else:
		audio_player.play()
		print('not enough')

func pricerounding(price: float) -> String:
	var suffixes = ["", "", "M", "B", "T", "Q"]  # Add more if needed
	var i = 0
	var value = float(price)
	
	while value >= 1000.0 and i < suffixes.size() - 1:
		value /= 1000.0
		i += 1
		
	if i == 1:
		var int_price_str = str(int(price))
		var insert_pos = int_price_str.length() - 3
		if insert_pos > 0:
			return int_price_str.substr(0, insert_pos) + "." + int_price_str.substr(insert_pos)
		else:
			return int_price_str  # fallback if number is too small (e.g. < 1000)

	# Round up to 1 decimal place using ceiling logic
	var scaled_value = ceil(value * 10.0) / 10.0

	# Remove ".0" if it's a whole number
	if scaled_value == int(scaled_value):
		return "%d%s" % [int(scaled_value), suffixes[i]]
	else:
		return "%.1f%s" % [scaled_value, suffixes[i]]

func UpgradeText():
	$UpgradeButton/Quantity.text = str(UpgradeQuantity)
	$UpgradeButton/Price.text = pricerounding(UpgradePrice)
