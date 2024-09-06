event_inherited();
if (debug) draw_text(x, y-32, stateText);
draw_self();
//draw_circle(x, y, 5, false);
if (currentState = STATES.ATTACKING) draw_attack();

	/*for (var i = 0; i < array_length(bodyparts); i++){
		bodyparts[i].update();
		draw_text(10, i*10 + 40, bodyparts[i].currPosX);
		draw_text(30, i*10 + 40, bodyparts[i].currPosY);
	}*/