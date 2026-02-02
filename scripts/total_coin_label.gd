extends Label

func _ready():
	update_display()

func _process(_delta):
	pass

func update_display():
	text = "Coins: " + str(GameManager.coins)
