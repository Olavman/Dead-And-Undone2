// for testing purpouses
if (keyboard_check_pressed(vk_left)){
	room_goto(rmLevel1);
}
if (keyboard_check_pressed(vk_right)){
	room_goto(rmLevel2);
}

// save game
if (keyboard_check_pressed(ord("S"))){
	save_game(0);
}

// load game
if (keyboard_check_pressed(ord("L"))){
	load_game(0);
}