
function Limb (_x, _y, _length) constructor
{
	currX = _x;
	currY = _y;
	startX = currX;
	startY = currY;
	targetX = 0;
	targetY = 0;
	limbLength = _length;
	limbSpd = limbLength * (1/room_speed/0.3);
	limbPlaced = false;
	placedDuration = 0;
}

#region // Variables
maxHp = 10;
hp = irandom(9)+1;
team = 0;

limbMoveCurve = animcurve_get_channel(acCurves, "limbMoveCurve");
numLimbsPlaced = 0;
bodySpd = 0;
dir = 0;
size = 7;

// Create limbs
var _limbLength = 6;
limbs = array_create(2);
var _len = array_length(limbs);
for (var i = 0; i < _len; i++){
	limbs[i] = new Limb(x, y, _limbLength);
}
#endregion

#region // Limb functions
place_limb = function(_limb)
{
	numLimbsPlaced++; // Add 1 to numLimbsPlaced
	bodySpd += _limb.limbSpd; // Add limbSpd to bodySpd
	_limb.limbPlaced = true; // Set limbPlaced to true
	//show_debug_message("limb placed")
}

lift_limb = function(_limb)
{
	numLimbsPlaced--; // Subtract 1 from numLimbsPlaced
	bodySpd -= _limb.limbSpd; // Subtract limbSpd from bodySpd
	// Set limb start positions
	_limb.startX = _limb.currX;
	_limb.startY = _limb.currY;
	_limb.limbPlaced = false; // Set limbPlaced to false
	//show_debug_message("limb lifted")
}

move_limbs = function() // Limb will move from start pos to target pos
{
	var _len = array_length(limbs);
	for (var i = 0; i < _len; i++){
		var _limb = limbs[i];
		if (!_limb.limbPlaced){
			// If placedDuration <= -limbLength, place_limb
			if (_limb.placedDuration <= -_limb.limbLength) {
				place_limb(_limb);
			}
			else {
				_limb.placedDuration -= _limb.limbSpd; // Subtract limbSpd from placedDuration
				// Set limb target positions
				var _dir = (i+1) / _len * 360; // Calculate offset to spread the limbs evenly
				_limb.targetX = x + lengthdir_x(_limb.limbLength, dir) + lengthdir_x(size/2, _dir+dir+90);
				_limb.targetY = y + lengthdir_y(_limb.limbLength, dir) + lengthdir_y(size/2, _dir+dir+90);
				// Move limb toward target
				var _percent = 1-normalize_value(_limb.placedDuration, -_limb.limbLength, _limb.limbLength);
				_limb.currX = map_value(animcurve_channel_evaluate(limbMoveCurve, _percent), 0, 1, _limb.startX, _limb.targetX);
				_limb.currY = map_value(animcurve_channel_evaluate(limbMoveCurve, _percent), 0, 1, _limb.startY, _limb.targetY);
			}
		}
	}
}

push_body_forward = function() // Limb will push body until full limb length is extended
{
	// Move body
	x += lengthdir_x(bodySpd, dir);
	y += lengthdir_y(bodySpd, dir);
	
	// Update limbs placedDuration
	var _len = array_length(limbs);
	for (var i = 0; i < _len; i++){
		var _limb = limbs[i];
		if (_limb.limbPlaced){
			// If placedDuration >= limbLength, lift_limb
			if (_limb.placedDuration >= _limb.limbLength){
				lift_limb(_limb);
			}
			else {
				_limb.placedDuration += bodySpd; // Add bodySpd to placedDuration
			}
		}
	}
}

move_towards_target_position = function(_targetX, _targetY)
{
	dir = point_direction(x, y, _targetX, _targetY);
	move_limbs();
	push_body_forward ();
}

draw_full_body = function() 
{
	// Draw main body
	draw_circle(x, y, size, false);
	
	// Draw limbs
	var _len = array_length(limbs);
	for (var i = 0; i < _len; i++){
		var _limb = limbs[i];
		if (_limb.limbPlaced) draw_set_color(c_red)
		else draw_set_color(c_green)
		draw_circle(_limb.currX, _limb.currY, 2, false); // Draw limb at its current position
		draw_set_color(c_white)
	}
}
#endregion
/*
for (var i = 0; i < _len; i++){
	var _limb = limbs[i];
	var _percent = (i+1) / _len;
	_limb.placedDuration = _percent*_limb.limbLength;
}*/
place_limb(limbs[0]);