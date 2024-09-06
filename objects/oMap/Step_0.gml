for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		if (point_in_rectangle(mouse_x, mouse_y, xx*gridSize, yy*gridSize, xx*gridSize+gridSize, yy*gridSize+gridSize)){
			if (mouse_check_button_pressed(mb_left)){
				start[0] = xx;
				start[1] = yy;
			}
			if (mouse_check_button_pressed(mb_right)){
				goal[0] = xx;
				goal[1] = yy;
			}
			if (mouse_check_button_pressed(mb_middle)){
				check_surroundings(xx, yy);
			}
		}
	}
}

if (keyboard_check_pressed(vk_control)){
	found = false;
	//var _adr = find_lowest();
	//check_surroundings(_adr[0], _adr[1]);
}

if(found == false) {
	var i = 0;
	repeat(500){
		var _adr = find_lowest();
		check_surroundings(_adr[0], _adr[1]);
		if (found == true) break;
		i++;
	}
	if (found == true){
		path = backtrack(goal);
		show_debug_message("Path found");
		show_debug_message(i)
		exit;
	}
	path = backtrack(find_closest());
	found = true;
	show_debug_message("Unable to reach destination")
	exit;
}

if (keyboard_check_pressed(vk_space)){
	clear_path();
}