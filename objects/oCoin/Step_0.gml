if (mouse_check_button_pressed(mb_left)){
	if (collision_point(mouse_x, mouse_y, self, false, false)){
		instance_destroy(id)
	}
}