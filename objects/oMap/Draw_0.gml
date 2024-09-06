var _col = c_white;
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		_col = c_white;
		if (map[# xx, yy][CELL.TERR] == infinity){
			_col = c_black;
		}
		if (map[# xx, yy][CELL.TERR] == 4){
			_col = c_grey;
		}
		if (map[# xx, yy][CELL.LOCKED] == true){
			_col = c_red;
		}
		if (point_in_rectangle(mouse_x, mouse_y, xx*gridSize, yy*gridSize, xx*gridSize+gridSize, yy*gridSize+gridSize)){
			_col = c_green
		}
		if (start[0] == xx && start[1] == yy){
			_col = c_blue;
		}
		if (goal[0] == xx && goal[1] == yy){
			_col = c_teal;
		}
		for (var i = 0; i < array_length(path); i++){
			if (path[i][0] == xx && path[i][1] == yy){
				_col = c_fuchsia;
			}
		}
		draw_set_color(_col)
		draw_rectangle(xx*gridSize, yy*gridSize, xx*gridSize+gridSize, yy*gridSize+gridSize, false);
		draw_set_color(c_black)
		//draw_rectangle(xx*gridSize, yy*gridSize, xx*gridSize+gridSize-1, yy*gridSize+gridSize-1, true);
		//draw_text(xx*gridSize, yy*gridSize-6, string(map[# xx, yy][CELL.G_COST]));
		//draw_text(xx*gridSize, yy*gridSize+6, string(map[# xx, yy][CELL.H_COST]));
		//draw_text(xx*gridSize, yy*gridSize+18, string(map[# xx, yy][CELL.F_COST]));
		if (map[# xx, yy][CELL.CHECKED]){
			draw_line(xx*gridSize+gridSize/2, yy*gridSize+gridSize/2, map[# xx, yy][CELL.PARENT][0]*gridSize+gridSize/2, map[# xx, yy][CELL.PARENT][1]*gridSize+gridSize/2)
		}
	}
}
draw_set_color(c_white)
