extends AnimatedSprite

export var pixels_per_second = 70;
export var layer_name = "Layer01";

var next_animation_index = 2;
var animations = [
	"city", "sea", "wood"
];
var is_night = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "create_layer_after_this");
	$ExitNotifier.connect("screen_exited", self, "remove_self");
	get_parent().get_node("NightDayTimer").connect("timeout", self, "switch_daytime");
	get_parent().connect("change_environment_request", self, "switch_animation_now");
	pass # Replace with function body.


func _process(delta):
	position.x -= delta * pixels_per_second;

func create_layer_after_this():
	var daytime_suffix = "_day";
	if (is_night):
		 daytime_suffix = "_night";

	var newLayer = load("res://background/" + layer_name + ".tscn").instance();
	newLayer.position = position;
	newLayer.position.x = 1920;
	newLayer.animation = animations[next_animation_index] + daytime_suffix;

	# pass on the current settings to the next layer
	newLayer.pixels_per_second = pixels_per_second;
	newLayer.next_animation_index = next_animation_index;
	newLayer.is_night = is_night;
	get_parent().add_child_below_node(self, newLayer, false);

func remove_self():
	queue_free();

func switch_to_next_animation():
	next_animation_index += 1;
	if (next_animation_index >= animations.size()):
		next_animation_index = 0;

func switch_animation_now():
	switch_to_next_animation();
	var daytime_suffix = "_day";
	if (is_night):
		 daytime_suffix = "_night";

	animation = animations[next_animation_index] + daytime_suffix;


func switch_daytime():
	is_night = !is_night;
