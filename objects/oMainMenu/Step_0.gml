// input
keyUp = keyboard_check_pressed(vk_up);
keyDown = keyboard_check_pressed(vk_down);
keySelect = keyboard_check_pressed(vk_control);
keyIncrease = keyboard_check_pressed(vk_right);
keyDecrease = keyboard_check_pressed(vk_left);

// cycle trough menu
if (!locked){
	selection += keyDown - keyUp;
	if (selection < 0) selection = opLength-1;
	if (selection >= opLength) selection = 0;
}

if (keyIncrease || keyDecrease){
	audio_play_sound(sndSpeak, 999, false, global.mainVolume*global.musicVolume*global.effectsVolume);
}

// number of options in current menu
opLength = array_length(option[menuLvl]);

// using the options
if (keySelect){
	switch menuLvl{
		case MENULVL.MAINMENU:
		switch selection{
			case MAINMENU.START_GAME: room_goto_next(); break;
			case MAINMENU.LOAD_GAME: break;
			case MAINMENU.SETTINGS: menuLvl = MENULVL.SETTINGS; selection = 0; break;
			case MAINMENU.ABOUT: break;
			case MAINMENU.EXIT_GAME: menuLvl = MENULVL.EXIT_GAME; selection = 0; break;
		}
		break;
		
		case MENULVL.SETTINGS:
		switch selection{
			case SETTINGS.FULLSCREEN: window_set_fullscreen(!window_get_fullscreen()); break;
			case SETTINGS.WINDOW_SIZE: menuLvl = MENULVL.WINDOW_SIZE; selection = 0; break;
			case SETTINGS.BRIGHTNESS: break;
			case SETTINGS.SOUND: menuLvl = MENULVL.SOUND; selection = 0; break;
			case SETTINGS.CONTROLS: break;
			case SETTINGS.BACK: menuLvl = MENULVL.MAINMENU; selection = 0; break;
		}
		break;
		
		case MENULVL.SOUND:
		switch selection{
			case SOUND.MAIN_VOLUME: locked = !locked;
				if (locked) {
					slider = (instance_create_depth(x + width + opBorder, y, 0, oVolumeSlider))
					slider.knob = "mainVolume";					
				} 
				else instance_destroy(slider);
				break;
			case SOUND.MUSIC_VOLUME: locked = !locked;
				if (locked) {
					slider = (instance_create_depth(x + width + opBorder, y, 0, oVolumeSlider))
					slider.knob = "musicVolume";					
				} 
				else instance_destroy(slider);
				break;
			case SOUND.EFFECTS_VOLUME: locked = !locked;
			if (locked) {
					slider = (instance_create_depth(x + width + opBorder, y, 0, oVolumeSlider))
					slider.knob = "effectsVolume";					
				} 
				else instance_destroy(slider);
				break;
			case SOUND.BACK: menuLvl = MENULVL.SETTINGS; selection = 0; break;
		}
		break;
		
		case MENULVL.WINDOW_SIZE:
		switch selection{
			case WINDOW_SIZE.LARGE: window_set_size(1280, 720); window_set_fullscreen(false); break;
			case WINDOW_SIZE.MEDIUM: window_set_size(640, 360); window_set_fullscreen(false); break;
			case WINDOW_SIZE.SMALL: window_set_size(320, 180); window_set_fullscreen(false); break;
			case WINDOW_SIZE.BACK: menuLvl = MENULVL.SETTINGS; selection = 0; break;
		}
		break;
		
		case MENULVL.EXIT_GAME:
		switch selection{
			case EXIT_GAME.YES: game_end(); break;
			case EXIT_GAME.NO: menuLvl = MENULVL.MAINMENU; selection = 0; break;
		}
		break;
	}
	// number of options in current menu
	opLength = array_length(option[menuLvl]);
}

