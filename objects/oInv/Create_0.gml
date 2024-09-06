invWidth = 12;
invHeight = 4;
invSize = invHeight * invWidth;
inventory = ds_list_create();
inv_initialize(inventory, invSize);
selectedSlot = -1;

slotSize = 16;
xOffset = oCamera.viewWidth/2 - invWidth*slotSize/2;
yOffset = oCamera.viewHeight/2 - invHeight*slotSize/2;

pickedItem = ds_list_create();
inv_initialize(pickedItem, 1);

open = false;

inv_add_item(inventory, new Wood(), 20, true);
inv_add_item(inventory, new Iron(), 13, true);
//inv_add_item(inventory, new Weapon(irandom(100)), 1, true);
//inv_add_item(inventory, new Weapon(irandom(100)), 20, true);

//Draw inventory
draw_inventory = function(){
	selectedSlot = -1; // resets selected slot
	
	var _selected = false;
	var _x1, _x2, _y1, _y2;
	var _spacing = 0;
	var _index = 0;
	var _padding = 8;
	var _w = _spacing*(invWidth-1) + slotSize*(invWidth-1) + slotSize+_padding*2;
	var _h = _spacing*(invHeight-1) + slotSize*(invHeight-1) + slotSize+_padding*2
	
	// Draw inventory background
	draw_sprite_stretched(sInvBackground, 0, x-_padding, y-_padding, _w, _h);
	
	// Draw inventory
	for (var i = 0; i < invWidth; i++){
		for (var j = 0; j < invHeight; j++){
			var _x1 = x + _spacing*i + slotSize*i;
			var _x2 = x + _spacing*i + slotSize*i + slotSize;
			var _y1 = y + _spacing*j + slotSize*j;
			var _y2 = y + _spacing*j + slotSize*j + slotSize;
			_selected = (mouse_x >= _x1 && mouse_x <_x2 && mouse_y >= _y1 && mouse_y < _y2);
			if (_selected){
				selectedSlot = _index;
			}
			
			// Draw inventory slots
			//draw_rectangle(_x1, _y1, _x2, _y2, !_selected);
			draw_sprite_stretched(sprite_index, 0, _x1, _y1, slotSize, slotSize)
			
			// Draw inventory items
			if (inventory[|_index] != undefined){
				var _item = inventory[|_index];
				draw_sprite_stretched(_item.sprite, 0, _x1, _y1, slotSize, slotSize);
				draw_text(_x1, _y1, _item.quantity);
			}
			_index++;
		}
	}
	if (inventory[|selectedSlot] != undefined){
		var _item = inventory[|selectedSlot];
		inv_display_tooltip(_item.get_tooltip());
	}
}