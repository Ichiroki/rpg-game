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

# Stamina Bar
@onready var stamina_timer = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/mana_bar_timer
@onready var damage_stamina_bar = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/damage_bar
@onready var stamina_bar = $MarginContainer/MarginContainer/VBoxContainer/stamina_bar/bar

var health = 0 : set = _set_health
var mana = 0 : set = _set_mana
var stamina = 0 : set = _set_stamina

func _set_health(new_health):
	var prev_health = health
	health = min(health_bar.max_value, new_health)
	
	health_bar.value = health
	
	health_indicator.text = str(health, " / ", global.player_health)
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		health_timer.start()
	else:
		damage_health_bar.value = health

func init_health(_health):
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	damage_health_bar.max_value = health
	damage_health_bar.value = health
	
func _set_mana(new_mana):
	var prev_mana = mana
	mana = min(mana_bar.max_value, new_mana)
	
	if mana <= 0:
		queue_free()
		
	if mana < prev_mana:
		mana_timer.start()
	else:
		damage_mana_bar.value = mana

func init_mana(_mana):
	mana = _mana
	mana_bar.max_value = mana
	mana_bar.value = mana
	damage_mana_bar.max_value = mana
	damage_mana_bar.value = mana
	
func _set_stamina(new_stamina):
	var prev_stamina = stamina
	stamina = min(stamina_bar.max_value, new_stamina)
	
	if stamina <= 0:
		queue_free()
		
	if stamina < prev_stamina:
		stamina_timer.start()
	else:
		damage_stamina_bar.value = stamina

func init_stamina(_stamina):
	stamina = _stamina
	stamina_bar.max_value = stamina
	stamina_bar.value = stamina
	damage_stamina_bar.max_value = stamina
	damage_stamina_bar.value = stamina

func _on_health_bar_timer_timeout() -> void:
	damage_health_bar.value = health

func _on_mana_bar_timer_timeout() -> void:
	damage_mana_bar.value = mana

func _on_stamina_bar_timer_timeout() -> void:
	damage_stamina_bar.value = stamina
