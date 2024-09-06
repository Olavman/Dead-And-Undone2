if(keyboard_check_pressed(vk_space)){
	inv_craft_item(inventory, global.recipes[?"weapon"]);
}
if(keyboard_check_pressed(vk_enter)){
	open = !open;
	selectedSlot = -1;
}

if (mouse_check_button_pressed(mb_left)){
	inv_swap_item(inventory, pickedItem, selectedSlot, 0);
}

if (mouse_check_button_pressed(mb_right) && inventory[|selectedSlot] != undefined){
	var _amount = ceil(inventory[|selectedSlot].quantity /2);
	inv_split_stack(inventory, pickedItem, selectedSlot, 0, _amount);
}

distance_squared(mouse_x, mouse_y, 0, 0)