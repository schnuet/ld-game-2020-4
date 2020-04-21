extends "res://objects/stations/Station.gd"

var projectile = preload("res://objects/enemy/Projektile.tscn")

var enemy_manager:EnemyManager

export var initial_damage:int = 1
export var dmg_increase_multiplier_per_level:float = 1.5
export var shoot_cooldwon_reduction_per_level:float = 0.5
export var secs_between_shoots:float = 5
export var projectile_speed:float = 20


var current_damage:int



func _ready():
	current_damage = initial_damage
	$ActionTimer.wait_time = secs_between_shoots
	action_timer_time = secs_between_shoots

func init(enemy_manager:EnemyManager):
	self.enemy_manager = enemy_manager
	$ResourceStore.add_energy(10)

func update():
	.update()	
	initial_damage = ceil(initial_damage * dmg_increase_multiplier_per_level)
	secs_between_shoots = max(secs_between_shoots - shoot_cooldwon_reduction_per_level, 1)
	action_timer_time = secs_between_shoots
	
func perform_action():
	_try_to_fire()

func can_do_action():
	if ($ResourceStore.energy < energy_needed_for_action):
		return false;
	else:
		return !_get_enemies().empty()		

func _try_to_fire():
	var enemies = _get_enemies()
	if !enemies.empty():
		var closest_enemy = enemies.pop_back()
		var closest_dist = get_position_for_minions().distance_to(closest_enemy.global_position)
		for enemy in enemies:
			var distance = get_position_for_minions().distance_to(enemy.global_position)
			if distance < closest_dist:
				closest_dist = distance
				closest_enemy = enemy
		_fire(closest_enemy)

func _get_enemies():
	return enemy_manager.get_tree().get_nodes_in_group("Enemy")

func _fire(enemy):
	var bullet = projectile.instance()
	bullet.init(enemy, projectile_speed, current_damage)
	bullet.global_position = get_position_for_minions()
	print("Bullet pos: ", bullet.global_position)
	add_child(bullet)
	bullet.global_position = get_position_for_minions()
