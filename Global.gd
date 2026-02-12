extends Node

var money: float
var PassiveIncome: float
var UpgradePrice: int
var MultiplierUpgrades: int = 1
var TelephoneMultiplier: int = 1
var EmailMultiplier: int = 1
var LotteryMulti: int = 1
var telupbought: bool
var telupmultbought: bool
var moneyincrease = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	telupbought = false
	pass # Replace with function body.

func calcPassiveIncome(telup, emup, lotup):
	var telephoneUpgrade = telup * (0.5 * MultiplierUpgrades * TelephoneMultiplier)
	var emailUpgrade = emup * (10 * MultiplierUpgrades * EmailMultiplier)
	var LotteryUpgrade = lotup * (25 * MultiplierUpgrades * LotteryMulti)
	PassiveIncome =  telephoneUpgrade + emailUpgrade + LotteryUpgrade
	return PassiveIncome

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
