// Parent body

spd = random(1);
dir = 0;
targetX = 0;
targetY = 0;
size = 7;
limbOffset = size/2;
prevX = x;
prevY = y;

// Limb variables
limbMoveCurve = animcurve_get_channel(acCurves, "limbMoveCurve");
limbSwitchSpd = 1/room_speed/(1/spd/4.5);
limbMovePercent = random(1);
currentLimbToggle = 1;

// Initialize limbs with unique starting positions
limbsPos = array_create(irandom(3)); // Number of limbs

// Neccessary variables pr limb
for (var i = 0; i < array_length(limbsPos); i++) {
    limbsPos[i] = array_create(6);
    for (var j = 0; j < 6; j++) {
        limbsPos[i][j] = x;
    }
}
	
// Changes direction of main body
change_direction = function(_targetX, _targetY)
{
	targetX = _targetX;
	targetY = _targetY;
	dir = point_direction(x, y, targetX, targetY);
}
	
// Move toward target
move_body = function()
{
	x += lengthdir_x(spd, dir);
	y += lengthdir_y(spd, dir);

	// Snap to target if withtin spd range
	if (distance_in_range(x, y, targetX, targetY, spd)){
		x = targetX;
		y = targetY;
	}
}

// If time to switch limb
switch_limb = function()
{
	var _len = array_length(limbsPos);
	// Switch active limbs
	//currentLimbToggle = wrap_value(currentLimbToggle+1, -1, _len);
	currentLimbToggle = !currentLimbToggle;
	show_debug_message(currentLimbToggle)
	
	// The main body is only able to change direction when switching limbs
	change_direction(oPlayer.x, oPlayer.y);


	// Update limbs target and start positions
	for (var i = 0; i < _len; i++){
	
		if (i mod(2) == currentLimbToggle){
		
			// Start position
			limbsPos[i][POSITION.START_X] = limbsPos[i][POSITION.CURR_X];
			limbsPos[i][POSITION.START_Y] = limbsPos[i][POSITION.CURR_Y];
	
		}
	}

	// Reset limb move percent
	limbMovePercent = 0;
}

// Update limb position
move_limb = function()
{
	limbMovePercent = min(1, limbMovePercent+limbSwitchSpd);
	var _len = array_length(limbsPos);
	for (var i = 0; i < _len; i++){
		
		// Limb moving towards target pos
		if (i mod(2) = currentLimbToggle){
			var _l = limbsPos[i];
			// Target position
			// Distance moved since last switch
			var _dist = point_distance(x, y, prevX, prevY)*10;
			prevX = x;
			prevY = y;
			var _togg = (currentLimbToggle*2-1);
			limbsPos[i][POSITION.TARGET_X] = x+lengthdir_x(_dist, dir)+lengthdir_x(limbOffset, dir + _togg*90);
			limbsPos[i][POSITION.TARGET_Y] = y+lengthdir_y(_dist, dir)+lengthdir_y(limbOffset, dir + _togg*90);
		
			// Move limb
			_l[POSITION.CURR_X] = map_value(animcurve_channel_evaluate(limbMoveCurve, limbMovePercent), 0, 1, _l[POSITION.START_X], _l[POSITION.TARGET_X]);
			_l[POSITION.CURR_Y] = map_value(animcurve_channel_evaluate(limbMoveCurve, limbMovePercent), 0, 1, _l[POSITION.START_Y], _l[POSITION.TARGET_Y]);
		}
		// Limb standing still
		else {
			move_body();
			/*if (point_distance(x, y, limbsPos[i][POSITION.CURR_X], limbsPos[i][POSITION.CURR_Y]) > size*2){
				switch_limb();
				exit;
			}*/
		}
	}
	
}

// Draw body and limbs
draw_full_body = function()
{

	var _len = array_length(limbsPos);
	for (var i = 0; i < _len; i++){
		var _x = limbsPos[i][POSITION.CURR_X];
		var _y = limbsPos[i][POSITION.CURR_Y];
		//draw_circle(_x, _y, 2, false);
		draw_sprite(sFoot, 0, _x, _y);
		
		var _togg = i mod(2)*2-1
		//draw_line_width(x+lengthdir_x(limbOffset, dir+_togg*90), y+lengthdir_y(limbOffset, dir+_togg*90), _x, _y, 2);
		var _sprite = sLeg;
		var _scale = point_distance(x, y, _x, _y)/sprite_get_width(_sprite);
		draw_sprite_ext(_sprite, 0, _x, _y, _scale, 1, point_direction(_x, _y, x+lengthdir_x(limbOffset, dir+_togg*90), y+lengthdir_y(limbOffset, dir+_togg*90)), c_white, 1);
		
		//draw_circle(x, y, size, false);
		draw_sprite_ext(sBody, 0, x, y, 1, 1, dir, c_white, 1);
	}
}