extends Spatial

signal attack_ready
signal attack_done

export var damage : float = 10.0
export var one_off : bool = false
export var attack_range : float = 2.0
export var attack_rate : float = 1.0
export var attack_angle : float = 5.0

var attack_ready = true
var att_rate_timer = null

func _ready():
	att_rate_timer = Timer.new()
	add_child(att_rate_timer)
	att_rate_timer.connect("timeout", self, "_on_attack_ready")
	emit_signal("attack_ready")

func attack():
	if attack_ready:
		attack_ready = false
		var target = attack_target()
		if target != null and target.has_method("hurt"):
			target.hurt(damage)
		if not one_off:
			att_rate_timer.start(attack_rate)

func reset():
	if att_rate_timer.is_stopped():
		print("Resetting attack")
		attack_ready = true

func is_one_off():
	return one_off

func can_attack():
	return attack_ready

func attack_target():
	return null

func _on_attack_ready():
	attack_ready = true
	emit_signal("attack_ready")
