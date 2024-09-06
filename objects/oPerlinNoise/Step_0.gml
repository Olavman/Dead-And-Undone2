if (keyboard_check_pressed(vk_control)){
repeat(5){ average_map(map)};
}
if (keyboard_check_pressed(vk_left)){
selection--;
}
if (keyboard_check_pressed(vk_right)){
selection++;
}
if (keyboard_check(vk_up)){
colors[selection] += 0.001;
}
if (keyboard_check(vk_down)){
colors[selection] -= 0.001;
}

if (selection > 4) selection = 0;
if (selection < 0) selection = 4;