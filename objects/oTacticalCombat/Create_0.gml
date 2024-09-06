width = 10;
height = 10;
gridSize = 36;
map = ds_grid_create(width, height);
start = [0,0];	// Start path
goal = [0,0];	// Path destination
found = true;	// Path successfully found
path = [[0,0]];	// The path
turnOrder = ds_list_create(); // List of pieces
currTurn = 0;
ready = true;

tileHovered = [0,0];

/*enum CELL
{
	TERR,
	G_COST,
	H_COST,
	F_COST,
	LOCKED,
	PARENT,
	CHECKED
}
*/
// Generates a random map for testing
random_map = function()
{
	for (var xx = 0; xx < width; xx++){
		for (var yy = 0; yy < height; yy++){
			//        [terrain move cost, path cost, dist to goal, best node cost, locked, parent node, checked]
			map [# xx, yy] = [choose(4, 1, 1, infinity), 0, infinity, infinity, false, [0,0], false];
		}
	}
}

// Clears the path so its ready to make a new one
clear_path = function()
{
	for (var xx = 0; xx < width; xx++){
		for (var yy = 0; yy < height; yy++){
			map [# xx, yy] = [map [# xx, yy][CELL.TERR], 0, infinity, infinity, false, [0,0], false];
		}
	}
	array_resize(path, 1)
}

// Find the best node
find_lowest = function()
{
	var _lowest = infinity;
	var _adr = [0,0];
	var _found = false;
	for (var xx = 0; xx < width; xx++){
		for (var yy = 0; yy < height; yy++){
			if (_lowest > map [# xx, yy][CELL.F_COST] && map [# xx, yy][CELL.LOCKED] == false){
				_lowest = map [# xx, yy][CELL.F_COST];
				_adr = [xx, yy];
				_found = true;
			}
		}
	}
	if (_found == false){
		_adr = start;
	}
	return _adr;
}

// Find the closest node
find_closest = function()
{
	var _closest = infinity;
	var _adr = [0,0];
	var _found = false;
	for (var xx = 0; xx < width; xx++){
		for (var yy = 0; yy < height; yy++){
			if (_closest > map [# xx, yy][CELL.H_COST] && map [# xx, yy][CELL.LOCKED] == true){
				_closest = map [# xx, yy][CELL.H_COST];
				_adr = [xx, yy];
				_found = true;
			}
		}
	}
	if (_found == false){
		_adr = start;
	}
	return _adr;
}

// Check surrounding nodes and assign values
check_surroundings = function(xx, yy)
{
	var _G = 0;
	var _H = 0;
	var _I = 0;
	for (var i = -1; i <= 1; i++){
		for (var j = -1; j <= 1; j++){
			// If goal is found - update and return
			if (xx+i == goal[0] && yy+j == goal[1]){
				map[# xx+i, yy+j][CELL.G_COST] = _G + map[# xx, yy][CELL.G_COST];
				map[# xx+i, yy+j][CELL.PARENT] = [xx, yy]
				map[# xx+i, yy+j][CELL.CHECKED] = true;
				map[# xx+i, yy+j][CELL.H_COST] =_H;
				map[# xx+i, yy+j][CELL.F_COST] = map[# xx+i, yy+j][CELL.G_COST] + map[# xx+i, yy+j][CELL.H_COST];
				map[# xx, yy][CELL.LOCKED] = true;
				found = true;
				return true;
			}
			// Skip if outside map
			else if (xx+i < 0 || xx+i >= width || yy+j < 0 || yy+j >= height){
				continue;
			}
			// Skip center node
			else if (i == 0 && j == 0){
				continue;
			}
			// Skip if cell is already calculated
			else if (map[#xx+i, yy+j][CELL.LOCKED]){
				continue;
			}
			// Update surrounding nodes
			_G = sqrt(sqr(abs(xx)-abs(xx+i)) + sqr(abs(yy)-abs(yy+j))) * map[# xx+i, yy+j][CELL.TERR];
			_H = sqrt(sqr(abs(goal[0])-abs(xx+i)) + sqr(abs(goal[1])-abs(yy+j)));
			_I = sqrt(sqr(abs(start[0])-abs(xx+i)) + sqr(abs(start[1])-abs(yy+j)));
			// If node havent been checked before it will get the values
			if (map[# xx+i, yy+j][CELL.CHECKED] == false) {
				map[# xx+i, yy+j][CELL.G_COST] = _G + map[# xx, yy][CELL.G_COST];
				map[# xx+i, yy+j][CELL.PARENT] = [xx, yy]
				map[# xx+i, yy+j][CELL.CHECKED] = true;
				map[# xx+i, yy+j][CELL.H_COST] =_H;
				map[# xx+i, yy+j][CELL.F_COST] = map[# xx+i, yy+j][CELL.G_COST] + map[# xx+i, yy+j][CELL.H_COST];
			}
			// If the node has suboptimal values they will update
			if (map[# xx+i, yy+j][CELL.G_COST] > _G + map[# xx, yy][CELL.G_COST]){
				map[# xx+i, yy+j][CELL.G_COST] = _G + map[# xx, yy][CELL.G_COST];
				map[# xx+i, yy+j][CELL.PARENT] = [xx, yy];
				map[# xx+i, yy+j][CELL.H_COST] =_H;
				map[# xx+i, yy+j][CELL.F_COST] = map[# xx+i, yy+j][CELL.G_COST] + map[# xx+i, yy+j][CELL.H_COST];
			}
		}
	}
	map[# xx, yy][CELL.LOCKED] = true;
}

// Backtracks parent nodes from the goal to find the track
backtrack = function(_goal)
{
	var _done = false;
	var i = 0;
	var _track = [[0,0,0]];
	_track[0][0] = _goal[0];
	_track[0][1] = _goal[1];
	while(_done == false){
		_track[i+1][0] = map[# _track[i][0],_track[i][1]][CELL.PARENT][0];
		_track[i+1][1] = map[# _track[i][0],_track[i][1]][CELL.PARENT][1];
		_track[i+1][2] = map[# _track[i][0],_track[i][1]][CELL.G_COST];
		i++;
		if (_track[i][0] == start[0] && _track[i][1] == start[1]){
			_done = true;
			return _track;
		}
	}
}

// Mouse position on map
tile_hover = function()
{
	tileHovered[0] = min(width-1, max(0, floor(mouse_x/gridSize)));
	tileHovered[1] = min(width-1, max(0, floor(mouse_y/gridSize)));
	goal = tileHovered;
}

// Deselect pieces
deselect_pieces = function()
{
	if (instance_exists(oPiece)){
		var _piece = [0]
		for (var i = 0; i < instance_number(oPiece); i++){
			_piece[i] = instance_find(oPiece, i);
			_piece[i].selected = false;
		}
	}
}

// Select piece with mouse
mouse_select = function()
{
	if (instance_exists(oPiece)){
	var _piece = [0]
	for (var i = 0; i < instance_number(oPiece); i++){
		_piece[i] = instance_find(oPiece, i);
		if (tileHovered[0] == _piece[i].gridX && tileHovered[1] == _piece[i].gridY && mouse_check_button_pressed(mb_left)){
			// Unselects all pieces
			deselect_pieces();
			// Selects hovered piece
			_piece[i].selected = true;
		}
		if (_piece[i].selected == true){
			start[0] = _piece[i].gridX;
			start[1] = _piece[i].gridY;
		}
	}
}
}

// Sort pieces by value
sort_pieces_by_value = function (_list, _value) 
{
    var swapped, temp;
    do {
        swapped = false;
        for (var i = 0; i < ds_list_size(_list) - 1; i++) {
            if (variable_instance_get(_list[| i], _value) < variable_instance_get(_list[| i + 1], _value)) {
                temp = _list[| i];
                _list[| i] = _list[| i + 1];
                _list[| i + 1] = temp;
                swapped = true;
            }
        }
    } until (!swapped);
}

// Iterate through all instances of the object(s) and add them to the list
fill_turn_order = function()
{
	var _turnOrder = ds_list_create();
	if (instance_exists(oPiece)){
		var _piece = [0];
		for (var i = 0; i < instance_number(oPiece); i++){
			_piece[i] = instance_find(oPiece, i);
		    ds_list_add(_turnOrder, _piece[i].id);
			ds_list_copy(turnOrder, _turnOrder);
		}
	}
	ds_list_destroy(_turnOrder);
}

// Move selected peice
move = function()
{
	var _piece = [0];
	if (instance_exists(oPiece)){
		for (var i = 0; i < instance_number(oPiece); i++){
			_piece[i] = instance_find(oPiece, i);
			if (_piece[i].selected == true){
				array_copy(_piece[i].path, 0, path, 0, array_length(path));
			}
		}
	}
}

// Does check surroundings and backtracks to either goal or near goal 
pathfind = function (_loops)
{
	var i = 0;
	// Creates a path towards destination
	repeat(_loops){
		var _adr = find_lowest();
		check_surroundings(_adr[0], _adr[1]);
		if (found == true) break;
		i++;
	}
	// Returns path to destination
	if (found == true){
		path = backtrack(goal);		
	}
	// Returns path to closest tile if unable to reach destination
	else{
		path = backtrack(find_closest());
		found = true;		
	}
}

// Find closest enemy
choose_target = function(_selectedID)
{
	if (instance_exists(oPiece)){
		var _dist = infinity;
		var _piece = [0]
		for (var i = 0; i < instance_number(oPiece); i++){
			_piece[i] = instance_find(oPiece, i);
			// Find enemy
			if (_piece[i].side != _selectedID.side){
				// Change target if closer
				var _newDist = abs(_piece[i].gridX - _selectedID.gridX) + abs(_piece[i].gridY - _selectedID.gridY);
				if (_newDist < _dist){
					_dist = _newDist;
					goal[0] = _piece[i].gridX;
					goal[1] = _piece[i].gridY;
				}
			}
		}
	}
}

line_of_sight = function(x1, y1, x2, y2, _blocker) 
{
    var dx = abs(x2 - x1);
    var dy = abs(y2 - y1);
    var sx = x1 < x2 ? 1 : -1;
    var sy = y1 < y2 ? 1 : -1;
    var err = dx - dy;
    
    while (true) {
        if (map[# x1, y1][CELL.TERR] == infinity) {
            return false;
        }
		/*else {
			var _piece = [0];
			for (var i = 0; i < instance_number(_blocker); i++){
				_piece[i] = instance_find(_blocker, i);
				if (_piece[i].gridX == x1 && _piece[i].gridY == y1){
					return false;
				}
			}
		}*/
		
        if (x1 == x2 && y1 == y2) {
            break;
        }
        
        var e2 = 2 * err;
        
        if (e2 > -dy) {
            err -= dy;
            x1 += sx;
        }
        
        if (e2 < dx) {
            err += dx;
            y1 += sy;
        }
    }
    
    return true;
}


fill_turn_order();
random_map();
sort_pieces_by_value(turnOrder, "spd");