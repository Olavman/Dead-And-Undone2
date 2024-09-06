if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, x, y, x+boxWidth, y+boxHeight)){
	selected = true;
}
if (mouse_check_button_released(mb_left)){
	selected = false;
}
if (selected){
	value = clamp((mouse_x-x)/boxWidth, 0, 1);
}