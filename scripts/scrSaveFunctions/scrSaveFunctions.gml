// Room saving
function save_room()
{
	var _coinNum = instance_number(oCoin);
	
	var _roomStruct =
	{
		coinNum : _coinNum,
		coinData : array_create(_coinNum),
	}
	
	// Get the data from the different saveable objects
	
	// Coint
	for (var i = 0; i < _coinNum; i++){
		var _inst = instance_find(oCoin, i);
		
		_roomStruct.coinData[i] = 
		{
			x : _inst.x,
			y : _inst.y,
		}
	}
	
	// Store the spesific room struct in global.levelData's variable meant for that level
	if (room == rmLevel1) {global.levelData.level_1 = _roomStruct;};
	if (room == rmLevel2) {global.levelData.level_2 = _roomStruct;};
}
// Room loading
function load_room()
{
	var _roomStruct = 0;
	
	// Get the correct struct for the room you're in
	if (room == rmLevel1) {_roomStruct = global.levelData.level_1;};
	if (room == rmLevel2) {_roomStruct = global.levelData.level_2;};
	
	// Exit if _roomStruct isnt a struct
	if (!is_struct(_roomStruct)) {exit;};
	
	// Coins - get rid of the default room editor coins
	// the create new coins with all of the data we've previously saved
	if (instance_exists(oCoin)) {instance_destroy(oCoin);};
	for (var i = 0; i < _roomStruct.coinNum; i++){
		instance_create_depth(_roomStruct.coinData[i].x, _roomStruct.coinData[i].y, 0, oCoin);
	}
}

// Overall saving
function save_game(_fileNum = 0)
{
	var _saveArray = array_create(0);
	
	// Save the room you're in
	save_room();
	
	// Set and save stat related stuff
	global.statData.save_x = oPlayer.x;
	global.statData.save_y = oPlayer.y;
	global.statData.save_rm = room_get_name(room);
	
	global.statData.coins = global.coins;
	global.statData.itemInv = global.itemInv;
	
	array_push(_saveArray, global.statData);
	
	// Save all room data
	array_push(_saveArray, global.levelData);
	
	// Actual saving
	var _fileName = "savedata" + string(_fileNum) + ".sav";
	var _json = json_stringify(_saveArray);
	var _buffer = buffer_create(string_byte_length(_json) +1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _json);
	
	buffer_save(_buffer, _fileName);
	
	buffer_delete(_buffer);
}

// Overall loading
function load_game(_fileNum = 0)
{
	// Loading our saved data
	var _fileName = "savedata" + string(_fileNum) + ".sav";
	if (!file_exists(_fileName)) exit;
	
	// Load the buffer, get the JSON, delete the buffer to free memory
	var _buffer = buffer_load(_fileName);
	var _json = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	// Unstringify and get the saved data array
	var _loadArray = json_parse(_json);
	
	// Set the data in our game to match our loaded data
	global.statData = array_get(_loadArray, 0);
	global.levelData = array_get(_loadArray, 1);
	
	global.coins = global.statData.coins;
	global.itemInv = global.statData.itemInv;
	
	// Use our new data to get back to where we were in the game
	// Go to the correct room
	var _loadRoom = asset_get_index(global.statData.save_rm);
	room_goto(_loadRoom);
	// Make sure our oSaveLoad doesn't save the room we're exiting from
	oSaveLoad.skipRoomSave = true;
	
	// Create the player object
	if (instance_exists(oPlayer)) instance_destroy(oPlayer);
	instance_create_depth(global.statData.save_x, global.statData.save_y, 0, oPlayer);
	
	// Manually load the room
	load_room();
}