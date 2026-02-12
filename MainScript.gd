extends Node

@onready var moneyText = $MoneyText
@onready var funnyText = $FlavourText
@onready var passiveText = $PassiveIncomeText
@onready var moneybutton = $PhoneButton
@onready var audio_player = $AudioStreamPlayer
@onready var critclicksfx = $"Critical Hit"
var timer: Timer = Timer.new()
var backtimer: Timer = Timer.new()
var _time: float
@export var TelephoneMultiplier: int = 1
signal konami_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	newflavortext()
	moneybutton.pressed.connect(_button_pressed)
	
	add_child(timer)
	timer.wait_time = 10
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	add_child(backtimer)
	backtimer.wait_time = 5
	backtimer.one_shot = true
	backtimer.autostart = true
	backtimer.timeout.connect(_background_timer_timeout)
	backtimer.start()

func _on_timer_timeout():
	newflavortext()
	timer.start()
	
func _background_timer_timeout():
	var random = RandomNumberGenerator.new()
	var randnum = random.randi_range(0, 15)
	if randnum == 15:
		audio_player.play()
		print('played telring')
	else:
		print('your call center is soooo dead')
	#print(randnum)
	backtimer.start()

func newflavortext():
	funnyText.text = "[center]%s[/center]" % flavourText()

func pricerounding(price: float) -> String:
	var suffixes = ["", "", " Million", " Billion", " Trillion", " Quadrillion", " Quintillion", " Sextillion", " Septillion", " Octillion", " Nonillion", " Decillion", " Undecillion", " Duodecillion", " Tredecillion", " Quattrodecillion", " Quindecillion", " Sexdecillion", " Septdecillion", " Octodecillion", " Nondecillion", " Vigintillion", " Unvigintillion", " Duovigintillion", " Trevigintillion", " Quattrovigintillion", " Quinvigintillion"]  # No "Thousand"
	var i = 0
	var value = float(price)
	
	while value >= 1000.0 and i < suffixes.size() - 1:
		value /= 1000.0
		i += 1

	# Round up to 1 decimal place using ceiling logic
	var scaled_value = ceil(value * 10.0) / 10.0

	# Special case: when i == 1 (was "Thousand"), format as "100.000"
	if i == 1:
		var int_price_str = str(int(price))
		var insert_pos = int_price_str.length() - 3
		if insert_pos > 0:
			return int_price_str.substr(0, insert_pos) + "." + int_price_str.substr(insert_pos)
		else:
			return int_price_str  # fallback if number is too small (e.g. < 1000)

	# Remove ".0" if it's a whole number
	if scaled_value == int(scaled_value):
		return "%d%s" % [int(scaled_value), suffixes[i]]
	else:
		return "%.1f%s" % [scaled_value, suffixes[i]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moneyText.text = "€: " + pricerounding(floor(Global.money))
	passiveText.text = "€ per second: " + str(Global.PassiveIncome)
	debugMenu()

# Debug Menu

var sequence = [
	KEY_UP, KEY_UP,
	KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT,
	KEY_LEFT, KEY_RIGHT,
	KEY_B, KEY_A
]

var position = 0
var unlocked_debug := true #put back to false when game is done

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == sequence[position]:
			position += 1
			if position == sequence.size():
				unlocked_debug = true
				emit_signal("konami_entered")
				print("Konami Code entered!")
				position = 0
		else:
			position = 0

func debugMenu():
	if unlocked_debug:
		if Input.is_action_just_pressed("debugMoney"):
			Global.money += 1000000000000

		if Input.is_action_just_pressed("upgradeCount"):
			Global.money *= 2

# button
func _button_pressed():
	var rng = RandomNumberGenerator.new()
	var rndnum = rng.randi_range(0, 19)
	if not rndnum == 19:
		Global.money += (Global.moneyincrease)
	else:
		Global.money += (Global.moneyincrease*4)
		critclicksfx.play()
	#print(Global.money)

func _on_phone_button_mouse_entered() -> void:
	$AnimationPlayer.play("Hover")

func _on_phone_button_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("Hover")

func _on_phone_button_pressed() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Click")

func flavourText():
	var rng = RandomNumberGenerator.new()
	var flavourtexts
	var text
	flavourtexts = ['You accidentally scam called your mom, how could you not have recognized her voice!?!? >;(', 
					'Hahahahahaha', 
					'News: a local politician got called by his "bank", lost thousands', 
					'News: Millions lose money due to massive rugpull scam', 
					'Hackers and Scammers are now teaming up: Beware!', 
					'Scammers have become better with their scams', 
					'Dutch police are working to take down scam call centers in India, they have not yet arrived.',
					'Someone got their identity stolen by a fake job recruitment by Lucas from Codespretes Company',
					'now with telephones!']
	# placeholder for random generator
	text = flavourtexts[rng.randf_range(0, round(len(flavourtexts)))]
	return text

#scams to be added
#product/service scam (trimming scam as flavour text (ex: Free Armour Trimming))
#crypto scam
#squid-coin for Crypto Scam Flavour Text
#cult scam

#idea list
#angrey people
#bonus function = 80/20 for bonus cash (or to lose cash) (DONE)
#particles after buying upgrade
#script for multiple bought (DONE)
#critical clicks (5% for 4x) (DONE)
#click upgrade
#currency display change?
#better box timer (it reappears too quickly) (DONE)

#list of things to fix
#display says 1000 Million/Billion/etc. at some roundings (DONE)
#hover text doesn't function atm (FIXED)
#overflow related errors
