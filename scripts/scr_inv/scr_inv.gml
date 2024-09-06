enum DAMAGE_TYPE
{
	PHYSICAL,
	FIRE,
	COLD,
	LIGHTNING,
	POISON
}

// item structs needs following variables:
// itemName
// quantity
// maxStackSize
// quality

#region // Item structs
function Item (_quality = 100) constructor
{
	sprite = sGenericItem;
	itemName = "Item";
	description = "Generic item";
	quantity = 0;
	maxStackSize = 3;
	quality = _quality;
	
	clone_item = function()
	{
		return new Item (quality);
	}
	
	get_tooltip = function()
	{
		var _tooltip = [itemName, description];
		return _tooltip;
	}
}

#region // Ingredients
function Wood (_quality = 100) : Item (_quality) constructor
{
	sprite = sWood;
	itemName = "Wood";
	maxStackSize = 10;
	
	clone_item = function()
	{
		return new Wood (quality);
	}
}

function Iron (_quality = 100) : Item (_quality) constructor
{
	sprite = sIron;
	itemName = "Iron";
	maxStackSize = 10;
	
	clone_item = function()
	{
		return new Iron (quality);
	}
}

#endregion

#region // Equipment
function Weapon (_quality = 100) : Item (_quality) constructor
{
	sprite = sWeapon;
	itemName = "Weapon";
	description = "Generic weapon"
	maxStackSize = 1;
	damage = array_create(5, array_create(2));
	damage [DAMAGE_TYPE.PHYSICAL] = [0, 3];
	damage [DAMAGE_TYPE.COLD] = [5, 8];
	damage [DAMAGE_TYPE.FIRE] = [6, 9];
	damage [DAMAGE_TYPE.LIGHTNING] = [1, 15];
	damage [DAMAGE_TYPE.POISON] = [3, 5];
	reqLvl = 0;
	reqStr = 10;
	reqDex = 0;
	reqInt = 0;
	
	clone_item = function()
	{
		return new Weapon (quality);
	}
	
	get_tooltip = function()
	{
		var _tooltip = [
			itemName, 
			description, 
			"Quality: " + string(quality)
			];
			// Add a string that shows dmg, if the weapon has that type of dmg
			var _dmgString = "";
			for (var i = 0; i < array_length(damage); i++){
				if (damage[i][1] > 0){
					switch i{
						case DAMAGE_TYPE.PHYSICAL:
						_dmgString = "Physical damage: " + string(damage[i][0]) + " to " + string(damage[i][1]);
						break;
						
						case DAMAGE_TYPE.FIRE:
						_dmgString = "Fire damage: " + string(damage[i][0]) + " to " + string(damage[i][1]);;
						break;
						
						case DAMAGE_TYPE.COLD:
						_dmgString = "Cold damage: " + string(damage[i][0]) + " to " + string(damage[i][1]);;
						break;
						
						case DAMAGE_TYPE.LIGHTNING:
						_dmgString = "Lightning damage: " + string(damage[i][0]) + " to " + string(damage[i][1]);;
						break;
						
						case DAMAGE_TYPE.POISON:
						_dmgString = "Poison damage: " + string(damage[i][0]) + " to " + string(damage[i][1]);;
						break;
					}
					if (_dmgString != ""){
						array_push(_tooltip, _dmgString); 
					}
				}
			}
			
			// Add a string for each required attribute, if the weapon requires that attribute
			if (reqLvl > 0) array_push(_tooltip, "Required lvl: " + string(reqLvl));
			if (reqStr > 0) array_push(_tooltip, "Required str: " + string(reqStr));
			if (reqDex > 0) array_push(_tooltip, "Required dex: " + string(reqDex));
			if (reqInt > 0) array_push(_tooltip, "Required int: " + string(reqInt));
		return _tooltip;
	}
}

#endregion

#endregion

#region // Item recipes
function recipes_initialize()
{
	global.recipes = ds_map_create();
	recipe_weapon = {
	    ingredients: [{item: new Wood(), quantity: 2}, {item: new Iron(), quantity: 1}],
	    result: {item: new Weapon(), quantity: 1}
	};
	ds_map_add(global.recipes, "weapon", recipe_weapon);
	
	/*recipe_sword = {
	    ingredients: [{item: new Wood(), quantity: 1}, {item: "iron ingot", quantity: 1}, {item: "rope", quantity: 1}],
	    result: {item: "sword", quantity: 1}
	};*/
	//ds_map_add(global.recipes, "sword", recipe_sword);
}

function recipes_destroy()
{
	ds_map_destroy(global.recipes);
}


#endregion

// Display item tooltip
function inv_display_tooltip(_tooltip){
	
	var _len = array_length(_tooltip);
	var _fontHeight = string_height("A");
	var _width = 0;
	for (var i = 0; i < _len; i++){
		_width = max(_width, string_width(_tooltip[i])); // Get width of the longest string in the array
	}
	var x1 = mouse_x;
	var y1 = mouse_y;
	var x2 = x1+_width;
	var y2 = y1+_fontHeight*_len;
	
	// Draw background
	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Draw tooltip
	for (var i = 0; i < _len; i++){
		draw_text(x1, y1 + _fontHeight*i, _tooltip[i]);
	}
}

// Checks if 2 slots have identical items
function inv_item_is_identical(_item1, _item2){
	if (_item1 != undefined && _item2 != undefined && _item1.itemName == _item2.itemName && _item1.quality == _item2.quality){
		return true;
	}
	else return false;
}

// Sets up an empty inventory with a spesified size
function inv_initialize(_inv, _size)
{
	for (var i = 0; i < _size; i++){
		ds_list_add(_inv, undefined);
	}
}

// Craft item
function inv_craft_item(_inv, _recipe){
	
	// Check if player has required items
	var _len = array_length(_recipe.ingredients);
	for (var i = 0; i < _len; i++){
		var _ingredient = _recipe.ingredients[i];
		if (!inv_has_item(_inv, _ingredient.item, _ingredient.quantity)){
			show_debug_message("You don't have the required ingredients!");
			return false;
		}
	}
	
	// Deduct items from inventory
	for (var i = 0; i < _len; i++){
		var _ingredient = _recipe.ingredients[i];
		inv_remove_item(_inv, _ingredient.item, _ingredient.quantity);
		show_debug_message("removed item");
	}
	
	// Add crafted item to inventory
	inv_add_item(_inv, _recipe.result.item, _recipe.result.quantity);
	show_debug_message("crafted item");
}

// checks if a spesific item is in inventory
function inv_has_item(_inv, _item, _quantity){
	var _len = ds_list_size(_inv);
	var _count = 0;
	for (var i = 0; i < _len; i++){
		if (_inv[|i] != undefined && _inv[|i].itemName == _item.itemName){
			_count += _inv[|i].quantity;
			if (_count >= _quantity) return true;
		}
	}
	return false;
}

// returns the slot index of a spesific item if it exists in inventory
function inv_find_item(_inv, _item){
	var _len = ds_list_size(_inv);
	for (var i = 0; i < _len; i++){
		if (_inv != undefined && _inv[|i].itemName == _item.itemName){
			return i;
		}
	}
	return false;
}

// returns the total quantity of a spesific item
function inv_get_total_items(_inv, _item){
	var _len = ds_list_size(_inv);
	var _quantity = 0;
	for (var i = 0; i < _len; i++){
		if (_inv != undefined && _inv[|i].itemName == _item.itemName){
			_quantity += _inv[|i].quantity;
		}
	}
	return _quantity;
}

// checks if inventory is full
function inv_is_full(_inv){
	var _len = ds_list_size(_inv);
	for (var i = 0; i < _len; i++){
		if (_inv[|i] == undefined){
			return false;
		}
	}
	return true;
}

// checks if there's enough space in the inventory to add a spesific quantity of an item
function inv_has_space_for_item(_inv, _item, _quantity){
	var _len = ds_list_size(_inv);
	for (var i = 0; i < _len; i++){
		if (_inv[|i] == undefined){
			_quantity -= _item.maxStackSize; // a free slot has room for "maxStackSize" quantity
		}
		else if (_inv[|i].itemName == _item.itemName){
			_quantity -= _inv[|i].maxStackSize - _inv[|i].quantity; // room to fill items quantity
		}
		if (_quantity <= 0) return true;
	}
	return false;
}

// returns an empty inventory slot
function inv_get_free_slot(_inv){
	var _len = ds_list_size(_inv);
	for (var i = 0; i < _len; i++){
		if (_inv[|i] == undefined){
			return (i);
		}
	}
	return -1;
}

// add items to inventory
function inv_add_item(_inv, _item, _quantity, _dropRemaining){
	var _len = ds_list_size(_inv); // length of inventory
	var _index = -1; // empty inv slot
	
	for (var i = 0; i < _len; i++){
		if (inv_item_is_identical(_inv[|i], _item) && _inv[|i].quantity < _item.maxStackSize){ // items are identical and have room to increase quantity
				
			var _increaseAmount = min(_quantity, _inv[|i].maxStackSize - _inv[|i].quantity); // amount to increase
			_inv[|i].quantity += _increaseAmount; // adds _increaseAmount amount to item.quantity
			_quantity -= _increaseAmount; // updates _quantity amount
			if(_quantity <= 0) {
				return true; // stops loop if all items has been added
			}
		}
		else if (_index == -1 && _inv[|i] == undefined){ // checks if the slot is empty
			_index = i; // remembers an empty slot
		}
	}
	
	if (_index != -1 && _quantity > 0){ // if theres an empty slot & theres quantity left
		_inv[|_index] = _item.clone_item(_item.quality); // adds item to an empty slot (the default quantity is 0)
		inv_add_item(_inv, _item.clone_item(_item.quality), _quantity, _dropRemaining); // repeats the function to add items to the new slot, until quantity is 0 or inv is full
		exit;	
	}
	
	if (_quantity > 0){
		if (_dropRemaining) inv_drop_item(_item, _quantity, oPlayer);
		else return _quantity;
	}
}

// Add items to inventory slot
function inv_add_item_to_slot(_inv, _index, _item, _quantity, _dropRemaining){
	
	 // If slot is empty
	if (_inv[|_index] == undefined){
		_inv[|_index] = _item.clone_item(_item.quality); // Add new item to inventory
		_inv[|_index].quantity = min(_quantity, _item.maxStackSize); // Add quantity to new item
		
		// Drop remaining quantity
			_quantity -= _inv[|_index].quantity;
		if (_dropRemaining && _quantity >0){
			inv_drop_item(_item, _quantity, oPlayer);
		}
		else return _quantity;
	}
	
	// If items are identical
	else if (inv_item_is_identical(_inv[|_index], _item)){ // If items are identical
		var _increaseAmount = min(_quantity, _item.maxStackSize - _inv[|_index].quantity); // amount to increase
		_inv[|_index].quantity += _increaseAmount; // Add quantity to new item
		
		// Drop remaining quantity
		_quantity -= _increaseAmount;
		if (_dropRemaining && _quantity >0){
			inv_drop_item(_item, _quantity, oPlayer);
		}
		else return _quantity;
	}
}

// remove items from inventory
function inv_remove_item(_inv, _item, _quantity){
	var _len = ds_list_size(_inv); // length of inventory
	
	for (var i = 0; i < _len; i++){
		if (_inv[|i] != undefined && _inv[|i].itemName == _item.itemName && _inv[|i].quantity > 0){
			var _removed =  min(_quantity, _inv[|i].quantity);
			_inv[|i].quantity -= _removed; // removes _removed amount to item.quantity
			_quantity -= _removed; // updates _quantity amount
			if(_inv[|i].quantity == 0){
				_inv[|i] = undefined;
			}
			if(_quantity == 0) break; // stops loop if all items has been removed
		}
	}
}

// remove items from inventory slot
function inv_remove_item_in_slot(_inv, _index, _quantity){
	if (_inv[|_index] != undefined && _inv[|_index].quantity >= _quantity){
		_inv[|_index].quantity -= _quantity;
		if(_inv[|_index].quantity == 0){
			_inv[|_index] = undefined;
		}
	}
	else return false;
}

// swaps items from 2 inventory slots
function inv_swap_item(_inv1, _inv2, _index1, _index2){
	var _item = _inv1[|_index1];
	
	// Drops item if placed outside inventory
	if (_index1 == -1 && _inv2[|_index2] != undefined)
	{
		inv_drop_item(_inv2[|_index2], _inv2[|_index2].quantity, oPlayer);
	}
	
	// Merge items if identical
	if (inv_item_is_identical(_inv1[|_index1], _inv2[|_index2])){
		_item.quantity = inv_add_item_to_slot(_inv2, _index2, _item, _item.quantity, false);
		// Delete item if 0 quantity
		if(_item.quantity == 0){
			_item = undefined;
		}
	}
	// Items swaps slots
	_inv1[|_index1] = _inv2[|_index2];
	_inv2[|_index2] = _item;
}

// displays inventory
function inv_display_inventory(_inv, _width, _height, _startX, _startY, _slotSize, _spacing, _showSlot){
	var _len = ds_list_size(_inv);
	var _index = 0;
	for (var i = 0; i < _width; i++){
		for (var j = 0; j < _height; j++){
			
			// Draw inventory slots
			var _x1 = _startX + _spacing*i + _slotSize*i;
			var _x2 = _startX + _spacing*i + _slotSize*i + _slotSize;
			var _y1 = _startY + _spacing*j + _slotSize*j;
			var _y2 = _startY + _spacing*j + _slotSize*j + _slotSize;
			var _highlight = (mouse_x >= _x1 && mouse_x < _x2 && mouse_y >= _y1 && mouse_y < _y2); // Highlight if mouse is inside inv slot
			if(_showSlot) draw_rectangle(_x1, _y1, _x2, _y2, !_highlight);
		
			// Draw inventory item
			if (_inv[|_index] != undefined){
				draw_sprite_stretched(_inv[|_index].sprite, 0, _x1, _y1, _slotSize, _slotSize);
			}
			
			// Draw item info
			if (_highlight && _inv[|_index] != undefined){
				draw_text(mouse_x+12, mouse_y, _inv[|_index].itemName);
				draw_text(mouse_x+12, mouse_y+12, _inv[|_index].quantity);
				draw_text(mouse_x+12, mouse_y+24, _inv[|_index].quality);
			}
			_index++;
			if (_index >= _len) break;
		}
	}
}

// Drops item
function inv_drop_item(_item, _quantity, _source)
{
	var _itemObject = instance_create_depth(_source.x, _source.y, _source.depth, oItem);
	_itemObject.item = _item.clone_item(_item.quality);
	_itemObject.item.quantity = _quantity;
}

// Split stack
function inv_split_stack(_inv1, _inv2, _index1, _index2, _amount){
	if (_inv1[|_index1] != undefined && _inv1[|_index1].quantity >= _amount && _inv2[|_index2] == undefined){
		var _item = _inv1[|_index1];
		inv_add_item(_inv2, _item, _amount, false); // Adds amount to held items
		inv_remove_item_in_slot(_inv1, _index1, _amount); // Remove amount from inventory
	}
}