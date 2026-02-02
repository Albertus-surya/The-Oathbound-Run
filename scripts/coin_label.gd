extends Label

func _process(_delta):
	# Teks akan selalu update mengikuti jumlah uang di GameManager
	text = "Coins: " + str(GameManager.level_coins)
