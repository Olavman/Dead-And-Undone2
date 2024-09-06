event_inherited(); // Parent body

if (instance_number(oPlayer) > 1) instance_destroy();
debug = true;	// debug mode will show information on screen
stateText = "";	// information about current state

// variables
moveSpd = 1;	// move speed in pixels pr frame
interractRange = 32;	// radius for interraction range

//bodyparts = [new MainBody(x, y, id), undefined];
//bodyparts[1] = new RightLeg(bodyparts[0]);

// Define possible STATES
enum STATES {
    IDLE,
    MOVING,
    INTERACTING,
    ATTACKING
}

// Initialize current state to idle
currentState = STATES.IDLE;

// Update function called every frame
update = function() {
    switch(currentState) {
        case STATES.IDLE:
            // Handle idle state logic
			if (debug) stateText = "Idle";	// state text
            if (horizontal != 0 || vertical != 0) {	// player inputs movment command
                currentState = STATES.MOVING;
            }
            if (key_action) {	// player interacts with object
                currentState = STATES.INTERACTING;
            }
            if (key_attack) {	// player attacks
                currentState = STATES.ATTACKING;
            }
            break;
        case STATES.MOVING:
            // Handle moving state logic
			if (debug) stateText = "Moving";	// state text
			if (abs(sign(horizontal)) + abs(sign(vertical)) > 1) {
				var _diagonal = 0.7;	// move slower if moving diagonally
			}
			else var _diagonal = 1;	// normal speed if not moving diagonally
			if (!collision_check_horizontal()) x += horizontal * _diagonal * moveSpd;	// moves horizontally if not colliding
			if (!collision_check_vertical()) y += vertical * _diagonal * moveSpd;	// moves vertically if not colliding
            if (horizontal == 0 && vertical == 0) {	// player has stopped
                currentState = STATES.IDLE;
            }
            if (key_action) {	// player interacts with object
                currentState = STATES.INTERACTING;
            }
            if (key_attack) {	// player attacks
                currentState = STATES.ATTACKING;
            }
            break;
        case STATES.INTERACTING:
            // Handle interacting state logic
			if (debug) stateText = "Interracting";	// state text
			interraction_check();
            if (key_action) {	// interaction complete
                currentState = STATES.IDLE;
            }
            break;
        case STATES.ATTACKING:
            // Handle attacking state logic
			if (debug) stateText = "Attacking";	// state text
            if (key_attack) {	// attack animation complete
                currentState = STATES.IDLE;
            }
            break;
    }
	
}

// Collision checks for horizontal movement
collision_check_horizontal = function()
{
	var _widthOffset = sprite_width/2 * sign(horizontal);
	
	// Check for collision with room edges
	if x + horizontal + _widthOffset < 0 {	// collision with left side edge
	    x = 0 - _widthOffset;	// move to end of left side
		return true;
	} 
	else if x + horizontal +_widthOffset > room_width {	// collision with right side edge
	    x = room_width - _widthOffset;	// move to end of right side
		return true;
	}
	// Check for collision with children of a 'parent obstacle object'
	else if place_meeting(x + horizontal*moveSpd, y, pObstacle) {
	    // If collision detected, move character back to previous position
	    for (var i = 0; i < moveSpd; i++){
			x += sign(horizontal);	// moves towards obstacle
			if (place_meeting(x, y, pObstacle)){
				x -= sign(horizontal);	// moves 1 pixel out of obstacle
				break;
			}
		}
		return true;
	}
	else {
		return false;
	}
}

// Collision checks for vertical movement
collision_check_vertical = function()
{
	var _heightOffset = sprite_height/2 * sign(vertical);
	
	// Check for collision with room edges
	if y + vertical + _heightOffset < 0 {	// collision with left side edge
	    y = 0 - _heightOffset;	// move to end of left side
		return true;
	} 
	else if y + vertical +_heightOffset > room_height {	// collision with right side edge
	    y = room_height - _heightOffset;	// move to end of right side
		return true;
	}
	// Check for collision with children of a 'parent obstacle object'
	else if place_meeting(x, y + vertical*moveSpd, pObstacle) {
	    // If collision detected, move character back to previous position
	    for (var i = 0; i < moveSpd; i++){
			y += sign(vertical);	// moves towards obstacle
			if (place_meeting(x, y, pObstacle)){
				y -= sign(vertical);	// moves 1 pixel out of obstacle
				break;
			}
		}
		return true;
	}
	
	else {
		return false;
	}
}

// Interract with surrounding objects
interraction_check = function()
{
	var _list = ds_list_create();	// creates a list for objects to interract with
	var _num = collision_circle_list(x, y, interractRange, all, false, true, _list, true); // finds objects in range to interract with
	if (_num > 0){
		show_debug_message(_list[|0])	// insert interract action here
	}
	ds_list_destroy(_list);	// destroys the list to save memory
}

// Attack function
draw_attack = function()
{
	draw_circle(x, y, 32, true);
}