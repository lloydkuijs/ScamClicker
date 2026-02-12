extends Control

@onready var telparts = $Rectangles/TelephoneUpgrade/telparts
var incomeTimer: Timer = Timer.new()
var _time: float
var telupbought: bool = false
var thousandtel: bool = false
var thousandem: bool = false
var thousandlot: bool = false
var onetoggled = true
var tentoggled = false
var fiftytoggled = false
var maxtoggled = false
var pricecounter = 0
var buysteps = 0
var predicounter
var fakeprice
var faketotmoney
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var email_player : AudioStreamPlayer = $YGM
@onready var not_enough_audio: AudioStreamPlayer = $notEnoughAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(incomeTimer)
	incomeTimer.wait_time = 1
	incomeTimer.one_shot = true
	incomeTimer.autostart = true
	incomeTimer.timeout.connect(passiveIncomeTimer)

func passiveIncomeTimer():
	#print(Global.money)
	Global.money += Global.PassiveIncome
	incomeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %TelephoneUpgrade.UpgradeQuantity >= 200 and not thousandtel:
		Global.TelephoneMultiplier *= 10
		thousandtel = true
	if %EmailUpgrade.UpgradeQuantity >= 200 and not thousandem:
		Global.EmailMultiplier *= 10
		thousandem = true
	if %LotteryUpgrade.UpgradeQuantity >= 200 and not thousandlot:
		Global.LotteryMulti *= 10
		thousandlot = true
	pass

func _on_scall_upgrade_pressed():
	if maxtoggled == true or tentoggled == true or fiftytoggled == true:
		if tentoggled or fiftytoggled:
			predicounter = 0
			fakeprice = %TelephoneUpgrade.UpgradePrice
			faketotmoney = 0
			if tentoggled:
				while not predicounter == 10:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if fiftytoggled:
				while not predicounter == 50:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if faketotmoney >= Global.money:
				not_enough_audio.volume_db = 0
				not_enough_audio.stream = preload("res://Assets/Audio Assets/Error.mp3")
				not_enough_audio.play()
				print('not enough')
				return
		pricecounter = 0
		while true:
			%TelephoneUpgrade.UpgradeQuantity += 1
			Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
			Global.money -= %TelephoneUpgrade.UpgradePrice
			%TelephoneUpgrade.UpgradePrice *= 1.30
			%TelephoneUpgrade.UpgradeText()
			Global.telupbought = true
			pricecounter += 1
			if %TelephoneUpgrade.UpgradeQuantity % 10 == 0:
				audio_player.stream = preload("res://Assets/Audio Assets/telring background.mp3")
				audio_player.play()
			if maxtoggled:
				if Global.money <= %TelephoneUpgrade.UpgradePrice: break
			elif tentoggled:
				if pricecounter == 10:break
			elif fiftytoggled:
				if pricecounter == 50:break
		incomeTimer.start()
		return
	%TelephoneUpgrade.UpgradeQuantity += 1
	Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
	Global.money -= %TelephoneUpgrade.UpgradePrice
	%TelephoneUpgrade.UpgradePrice *= 1.30
	%TelephoneUpgrade.UpgradeText()
	Global.telupbought = true
	audio_player.volume_db = 24
	if %TelephoneUpgrade.UpgradeQuantity % 10 == 0:
		audio_player.stream = preload("res://Assets/Audio Assets/telring background.mp3")
		audio_player.play()
	telparts.restart()
	print('Halloi')
	incomeTimer.start()

func _on_email_upgrade_pressed():
	if maxtoggled == true or tentoggled == true or fiftytoggled == true:
		if tentoggled or fiftytoggled:
			predicounter = 0
			fakeprice = %EmailUpgrade.UpgradePrice
			faketotmoney = 0
			if tentoggled:
				while not predicounter == 10:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if fiftytoggled:
				while not predicounter == 50:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if faketotmoney >= Global.money:
				not_enough_audio.volume_db = 0
				not_enough_audio.stream = preload("res://Assets/Audio Assets/Error.mp3")
				not_enough_audio.play()
				print('not enough')
				return
		pricecounter = 0
		while true:
			%EmailUpgrade.UpgradeQuantity += 1
			Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
			Global.money -= %EmailUpgrade.UpgradePrice
			%EmailUpgrade.UpgradePrice *= 1.30
			%EmailUpgrade.UpgradeText()
			Global.telupbought = true
			pricecounter += 1
			if %EmailUpgrade.UpgradeQuantity % 10 == 0:
				email_player.stream = preload("res://Assets/Audio Assets/YGM.mp3")
				email_player.play()
			if maxtoggled:
				if Global.money <= %EmailUpgrade.UpgradePrice: break
			elif tentoggled:
				if pricecounter == 10:break
			elif fiftytoggled:
				if pricecounter == 50:break
		incomeTimer.start()
		return
	%EmailUpgrade.UpgradeQuantity += 1
	Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
	Global.money -= %EmailUpgrade.UpgradePrice
	%EmailUpgrade.UpgradePrice *= 1.30
	%EmailUpgrade.UpgradeText()
	Global.telupbought = true
	audio_player.volume_db = 24
	if %EmailUpgrade.UpgradeQuantity % 10 == 0:
		email_player.stream = preload("res://Assets/Audio Assets/YGM.mp3")
		email_player.play()
	print('Halloi')
	incomeTimer.start()

func _on_lotteryup_upgrade_pressed() -> void:
	if maxtoggled == true or tentoggled == true or fiftytoggled == true:
		if tentoggled or fiftytoggled:
			predicounter = 0
			fakeprice = %LotteryUpgrade.UpgradePrice
			faketotmoney = 0
			if tentoggled:
				while not predicounter == 10:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if fiftytoggled:
				while not predicounter == 50:
					faketotmoney += fakeprice
					fakeprice *= 1.30
					predicounter += 1
			if faketotmoney >= Global.money:
				not_enough_audio.volume_db = 0
				not_enough_audio.stream = preload("res://Assets/Audio Assets/Error.mp3")
				not_enough_audio.play()
				print('not enough')
				return
		pricecounter = 0
		while true:
			%LotteryUpgrade.UpgradeQuantity += 1
			Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
			Global.money -= %LotteryUpgrade.UpgradePrice
			%LotteryUpgrade.UpgradePrice *= 1.30
			%LotteryUpgrade.UpgradeText()
			Global.telupbought = true
			pricecounter += 1
			if %LotteryUpgrade.UpgradeQuantity % 10 == 0:
				audio_player.stream = preload("res://Assets/Audio Assets/telring background.mp3")
				audio_player.play()
			if maxtoggled:
				if Global.money <= %LotteryUpgrade.UpgradePrice: break
			elif tentoggled:
				if pricecounter == 10:break
			elif fiftytoggled:
				if pricecounter == 50:break
		incomeTimer.start()
		return
	%LotteryUpgrade.UpgradeQuantity += 1
	Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)
	Global.money -= %LotteryUpgrade.UpgradePrice
	%LotteryUpgrade.UpgradePrice *= 1.30
	%LotteryUpgrade.UpgradeText()
	Global.telupbought = true
	audio_player.volume_db = 24
	if %LotteryUpgrade.UpgradeQuantity % 10 == 0:
		audio_player.stream = preload("res://Assets/Audio Assets/telring background.mp3")
		audio_player.play()
	print('Halloi')
	incomeTimer.start()
	
func _on_sq_upgrade_multiplier_pressed(): #telephoneMultiplier 1
	Global.TelephoneMultiplier = Global.TelephoneMultiplier * 2
	Global.calcPassiveIncome(%TelephoneUpgrade.UpgradeQuantity, %EmailUpgrade.UpgradeQuantity, %LotteryUpgrade.UpgradeQuantity)

func _on_sq_upgrade_2_multiplier_pressed(): #telephoneMultiplier 2
	print('bozo')

func ontimes(times: int):
	onetoggled = false;tentoggled = false;fiftytoggled = false;maxtoggled = false
	if times == 0:onetoggled = true
	elif times == 1:tentoggled = true
	elif times == 2:fiftytoggled = true
	elif times == 3:maxtoggled = true

func _on_x_pressed() -> void:
	ontimes(0)

func _on_10x_pressed() -> void:
	ontimes(1)
	
func _on_50x_pressed() -> void:
	ontimes(2)
	
func _on_max_pressed() -> void:
	ontimes(3)
