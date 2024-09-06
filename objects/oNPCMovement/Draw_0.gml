// Inherit the parent event
event_inherited();

draw_text(x, y-20, decision);
if (targetID != noone){
	draw_line(x, y, targetID.x, targetID.y);
}