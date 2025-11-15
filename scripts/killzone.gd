extends Area2D

# Skrip ini tidak butuh _process atau _physics_process.
# Kita hanya butuh sinyal.

func _ready():
	# 1. Kita hubungkan sinyal "body_entered" ke fungsi kita sendiri.
	# Sinyal ini akan menyala ketika sebuah PhysicsBody (seperti Player)
	# masuk ke dalam Area2D ini.
	body_entered.connect(_on_body_entered)


# 2. Fungsi ini akan dipanggil secara otomatis oleh sinyal di atas.
# "body" adalah node yang masuk (misalnya, Player).
func _on_body_entered(body):
	
	# 3. Kita periksa apakah 'body' yang masuk itu punya fungsi "die".
	# Ini adalah cara aman untuk memeriksa apakah itu Player
	# (atau Musuh yang juga bisa mati)
	if body.has_method("die"):
		
		# 4. Jika punya, panggil fungsi "die" milik 'body' tersebut.
		body.die()
