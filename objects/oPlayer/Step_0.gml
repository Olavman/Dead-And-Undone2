event_inherited(); // Parent body

// initialize key inputs
key_left = keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_up = keyboard_check(ord("W"));
key_down = keyboard_check(ord("S"));
key_action = keyboard_check_pressed(ord("Z"));
key_attack = keyboard_check_pressed(ord("X"));

horizontal = key_right - key_left;
vertical = key_down - key_up;

update();