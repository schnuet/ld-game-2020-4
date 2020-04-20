extends "res://objects/stations/Station.gd";

var small_fat_store_height = 0;
var large_fat_store_height = 0;

var animated_energy_percent = 0;
var tween_duration = 0.2;

func _ready():
	small_fat_store_height = $FatLevelDisplay/Level1/RectA.rect_size.y;
	large_fat_store_height = $FatLevelDisplay/Level3/Rect.rect_size.y;



func update():
	.update();
	
	# show correct upgrade level
	if (upgrade_level == 1):
		$FatLevelDisplay/Level2.visible = true;
	elif (upgrade_level >= 2):
		$FatLevelDisplay/Level1.visible = false;
		$FatLevelDisplay/Level2.visible = false;
		$FatLevelDisplay/Level3.visible = true;

	change_animation_to_level(upgrade_level);



# energy 

func has_energy():
	return $ResourceStore.has_energy()
	
func take_energy():
	return $ResourceStore.take_energy()



# update the fill level of the different fat stores

func _on_ResourceStore_energy_amount_changed(amount):
	update_energy_level_display();

func update_energy_level_display():
	var energy_percent = float($ResourceStore.energy) / float($ResourceStore.max_energy);
	$FatLevelDisplay/Tween.interpolate_property(self, "animated_energy_percent",
        animated_energy_percent, energy_percent, tween_duration,
        Tween.TRANS_LINEAR, Tween.EASE_OUT);
	$FatLevelDisplay/Tween.start();
 
# update cylinder fill levels
func _process(delta):
	if (upgrade_level < 2):
		$FatLevelDisplay/Level1/RectA.rect_size.y = animated_energy_percent * small_fat_store_height;
		$FatLevelDisplay/Level1/RectB.rect_size.y = animated_energy_percent * small_fat_store_height;
	if (upgrade_level <= 2):
		$FatLevelDisplay/Level2/RectC.rect_size.y = animated_energy_percent * small_fat_store_height;
		$FatLevelDisplay/Level2/RectD.rect_size.y = animated_energy_percent * small_fat_store_height;
	if (upgrade_level >= 3):
		$FatLevelDisplay/Level3/Rect.rect_size.y = animated_energy_percent * large_fat_store_height;
