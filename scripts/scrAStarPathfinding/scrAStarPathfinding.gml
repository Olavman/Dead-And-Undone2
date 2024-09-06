/*function find_path (_map, _path, _start, _goal){
	var _found = false;
	
	//while(_found == false){
	var _adr = find_lowest(_path, _start);
	_found = check_surroundings(_map, _path, _adr[0], _adr[1], _start, _goal);
	//}
}

function find_lowest (_path, _start)
{
	// Find the lowest F-cost and return the adress to that node
	var _width = ds_grid_width(_path)
	var _height = ds_grid_height(_path)
	var _lowest = infinity;
	var _adr = [0,0];
	var _found = false;
	for (var xx = 0; xx < _width; xx++){
		for (var yy = 0; yy < _height; yy++){
			if (_lowest > _path [# xx, yy][CELL.F_COST] && _path [# xx, yy][CELL.LOCKED] == false){
				_lowest = _path [# xx, yy][CELL.F_COST];
				_adr = [xx, yy];
				_found = true;
			}
		}
	}
	if (_found == false){
		_adr = _start;
	}
	show_debug_message(_path[#xx, yy] [CELL.LOCKED])
	return _adr;
}

function check_surroundings (_map, _path, xx, yy, _start, _goal)
{
	// Check nodes surrounding a node
	var _width = ds_grid_width(_map)
	var _height = ds_grid_height(_map)
	var _G = 0;
	var _H = 0;
	var _I = 0;
	for (var i = -1; i <= 1; i++){
		for (var j = -1; j <= 1; j++){
			// If goal is found - update and return
			if (xx+i == _goal[0] && yy+j == _goal[1]){
				_path[# xx+i, yy+j][CELL.G_COST] = _G + _path[# xx, yy][CELL.G_COST];
				_path[# xx+i, yy+j][CELL.PARENT] = [xx, yy]
				_path[# xx+i, yy+j][CELL.CHECKED] = true;
				_path[# xx+i, yy+j][CELL.H_COST] =_H;
				_path[# xx+i, yy+j][CELL.F_COST] = _path[# xx+i, yy+j][CELL.G_COST] + _path[# xx+i, yy+j][CELL.H_COST];
				_path[# xx, yy][CELL.LOCKED] = true;
				show_debug_message("Path found");
				return true;
			}
			// Skip if outside lvl
			else if (xx+i < 0 || xx+i >= _width || yy+j < 0 || yy+j >= _height){
				continue;
			}
			// Skip center node
			else if (i == 0 && j == 0){
				continue;
			}
			// Skip if cell is already calculated
			else if (_path[#xx+i, yy+j][CELL.LOCKED]){
				continue;
			}
			// Update surrounding nodes
			_G = sqrt(sqr(abs(xx)-abs(xx+i)) + sqr(abs(yy)-abs(yy+j))) * _map[# xx+i, yy+j];
			_H = sqrt(sqr(abs(_goal[0])-abs(xx+i)) + sqr(abs(_goal[1])-abs(yy+j)));
			_I = sqrt(sqr(abs(_start[0])-abs(xx+i)) + sqr(abs(_start[1])-abs(yy+j)));
			// If node havent been checked before it will get the values
			if (_path[# xx+i, yy+j][CELL.CHECKED] != true) {
				_path[# xx+i, yy+j][CELL.G_COST] = _G + _path[# xx, yy][CELL.G_COST];
				_path[# xx+i, yy+j][CELL.PARENT] = [xx, yy]
				_path[# xx+i, yy+j][CELL.CHECKED] = true;
				_path[# xx+i, yy+j][CELL.H_COST] =_H;
				_path[# xx+i, yy+j][CELL.F_COST] = _path[# xx+i, yy+j][CELL.G_COST] + _path[# xx+i, yy+j][CELL.H_COST];
			}
			// If the node has suboptiml values they will update
			if (_path[# xx+i, yy+j][CELL.G_COST] > _G){
				_path[# xx+i, yy+j][CELL.G_COST] = _G + _path[# xx, yy][CELL.G_COST];
				_path[# xx+i, yy+j][CELL.PARENT] = [xx, yy];
				_path[# xx+i, yy+j][CELL.H_COST] =_H;
				_path[# xx+i, yy+j][CELL.F_COST] = _path[# xx+i, yy+j][CELL.G_COST] + _path[# xx+i, yy+j][CELL.H_COST];
			}
		}
	}
	// Lock center node
	_path[# xx, yy][CELL.LOCKED] = true;
	return (false);
}