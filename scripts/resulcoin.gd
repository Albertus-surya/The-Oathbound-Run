extends Label

func _ready():
	# Ambil data terakhir dari level_coins sebelum di-reset
	text = "Coins Earned: " + str(GameManager.level_coins)
