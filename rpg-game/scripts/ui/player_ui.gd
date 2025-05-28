extends Control

# Health Bar
@onready var health_timer = $MarginContainer/MarginContainer/VBoxContainer/health_bar/health_bar_timer
@onready var damage_health_bar = $MarginContainer/MarginContainer/VBoxContainer/health_bar/damage_bar
@onready var health_bar = $MarginContainer/MarginContainer/VBoxContainer/health_bar/bar
@onready var health_indicator = $MarginContainer/MarginContainer/VBoxContainer/health_bar/bar/indicator

# Mana Bar
@onready var mana_timer = $MarginContainer/MarginContainer/VBoxContainer/mana_bar/mana_bar_timer
@onready var damage_mana_bar = $MarginContainer/MarginContainer/VBoxContainer/mana_bar/damage_bar
@onready var mana_bar = $MarginContainer/MarginContainer/VBoxContainer/mana_bar/bar
@onready var mana_indicator = $MarginContainer/MarginContainer/VBoxContainer/mana_bar/bar/indicator

# Stamina Bar
@onready var stamina_timer = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/mana_bar_timer
@onready var damage_stamina_bar = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/damage_bar
@onready var stamina_bar = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/bar
@onready var stamina_indicator = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/bar/indicator

var health = 0
var max_health = 0

var mana = 0
var max_mana = 0

var stamina = 0
var max_stamina = 0

func _on_health_changed(curr: float, max: float):
	health = curr
	max_health = max
	
	health_bar.max_value = max
	health_bar.value = curr
	
	update_health_bar_label(curr, max)
	
	if damage_health_bar.value > curr:
		health_timer.start()
	else:
		damage_health_bar.value = curr
		damage_health_bar.max_value = max
	
func update_health_bar_label(_health, _max_health):
	health_indicator.text = str(_health, " / ", _max_health)
	
func _on_health_bar_timer_timeout() -> void:
	damage_health_bar.value = lerp(damage_health_bar.value, health, 0.1)
	if abs(damage_health_bar.value - health) <= 1.0:
		damage_health_bar.value = health
		health_timer.stop()
		
func _on_mana_changed(curr: float, max: float):
	mana = curr
	max_mana = max
	
	mana_bar.max_value = max
	mana_bar.value = curr
	
	update_mana_bar_label(curr, max)
	
	if damage_mana_bar.value > curr:
		mana_timer.start()
	else:
		damage_mana_bar.value = curr
		damage_mana_bar.max_value = max
	
func update_mana_bar_label(_mana, _max_mana):
	mana_indicator.text = str(_mana, " / ", _max_mana)
	
func _on_mana_bar_timer_timeout() -> void:
	damage_mana_bar.value = lerp(damage_mana_bar.value, mana, 0.1)
	if abs(damage_mana_bar.value - mana) <= 1.0:
		damage_mana_bar.value = mana
		mana_timer.stop()	

func _on_stamina_changed(curr: float, max: float):
	stamina = curr
	max_stamina = max
	
	stamina_bar.max_value = max
	stamina_bar.value = curr
	
	update_stamina_bar_label(curr, max)
	
	if damage_stamina_bar.value > curr:
		stamina_timer.start()
	else:
		damage_stamina_bar.value = curr
		damage_stamina_bar.max_value = max
	
func update_stamina_bar_label(_stamina, _max_stamina):
	stamina_indicator.text = str(_stamina, " / ", _max_stamina)
	
func _on_stamina_bar_timer_timeout() -> void:
	damage_stamina_bar.value = lerp(damage_stamina_bar.value, stamina, 0.1)
	if abs(damage_stamina_bar.value - stamina) <= 1.0:
		damage_stamina_bar.value = stamina
		stamina_timer.stop()
