width = 64;
height = 36;
gridSize = 10;
map = ds_grid_create(width, height);
start = [0,0];
goal = [0,0];
found = true;
path = [[0,0]];

enum CELL
{
	TERR,
	G_COST,
	H_COST,
	F_COST,
	LOCKED,
	PARENT,
	CHECKED
}

// Generates a random map for testing
random_map = function()
{
	for (var xx = 0; xx < width; xx++){
		for (var yy = 0; yy < height; yy++){
			//        [terrain move cost, path cost, dist to goal, best node cost, locked, parent node, checked]
			map [# xx, yy] = [choose(4, 0, infinity, infinity), 0, infinity, infinity, false, [0,0], false];
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
	var _track = [[0,0]];
	_track[0] = _goal;
	while(_done == false){
		_track[i+1] = map[# _track[i][0],_track[i][1]][CELL.PARENT];
		i++;
		if (_track[i][0] == start[0] && _track[i][1] == start[1]){
			show_debug_message("path tracked");
			show_debug_message(_track)
			_done = true;
			return _track;
		}
	}
}

random_map();